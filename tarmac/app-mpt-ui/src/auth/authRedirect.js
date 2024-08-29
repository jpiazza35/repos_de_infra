import * as msal from "@azure/msal-browser";
import { b2cPolicies } from "./policies";
import { apiConfig } from "../api/apiConfig";
import { msalConfig } from "./authConfig";
import { addHoursFromNow, getParameterByName } from "../utils/functions";

/**
 * Scopes you add here will be prompted for user consent during sign-in.
 * By default, MSAL.js will add OIDC scopes (openid, profile, email) to any login request.
 * For more information about OIDC scopes, visit:
 * https://docs.microsoft.com/azure/active-directory/develop/v2-permissions-and-consent#openid-connect-scopes
 */

let domainHint = "cliniciannexus.com";
let qHint = getParameterByName("domainhint");

if (qHint) domainHint = qHint;

const loginRequest = {
  scopes: ["openid", ...apiConfig.b2cScopes],
  extraQueryParameters: { domain_hint: domainHint },
};

/**
 * Scopes you add here will be used to request a token from Azure AD B2C to be used for accessing a protected resource.
 * To learn more about how to work with scopes and resources, see:
 * https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/resources-and-scopes.md
 */
const tokenRequest = {
  scopes: [...apiConfig.b2cScopes], // e.g. ["https://fabrikamb2c.onmicrosoft.com/helloapi/demo.read"]
  forceRefresh: true, // Set this to "true" to skip a cached token and go to the server to get a new token
};

// Create the main myMSALObj instance
// configuration parameters are located at authConfig.js
const myMSALObj = new msal.PublicClientApplication(msalConfig);

const tokenExpirationBuffer = 1; // in hours

let loggedAccount = null;
let accountId = "";
let username = "";
let accessToken = null;
let idToken = null;
let expiresOn = null;

await myMSALObj
  .handleRedirectPromise()
  .then(response => {
    if (response) {
      /**
       * For the purpose of setting an active account for UI update, we want to consider only the auth response resulting
       * from SUSI flow. "tfp" claim in the id token tells us the policy (NOTE: legacy policies may use "acr" instead of "tfp").
       * To learn more about B2C tokens, visit https://docs.microsoft.com/en-us/azure/active-directory-b2c/tokens-overview
       */
      if (response.idTokenClaims["acr"].toUpperCase() === b2cPolicies.names.signUpSignIn.toUpperCase()) {
        handleResponse(response);
      }
    }
  })
  .catch(error => {
    console.log(error);
  });

function setAccount(account) {
  loggedAccount = account;
  accountId = account.homeAccountId;

  if (!account.name) {
    username = `${account.idTokenClaims.given_name} ${account.idTokenClaims.family_name}`;
  } else {
    username = account.name;
  }
}

export function getAccount() {
  return loggedAccount;
}

export function getUserName() {
  return username;
}

function selectAccount() {
  /**
   * See here for more information on account retrieval:
   * https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-common/docs/Accounts.md
   */

  const currentAccounts = myMSALObj.getAllAccounts();

  if (currentAccounts.length < 1) {
    return;
  } else if (currentAccounts.length > 1) {
    /**
     * Due to the way MSAL caches account objects, the auth response from initiating a user-flow
     * is cached as a new account, which results in more than one account in the cache. Here we make
     * sure we are selecting the account with homeAccountId that contains the sign-up/sign-in user-flow,
     * as this is the default flow the user initially signed-in with.
     */
    const accounts = currentAccounts.filter(
      account =>
        account.homeAccountId.toUpperCase().includes(b2cPolicies.names.signUpSignIn.toUpperCase()) &&
        account.idTokenClaims.iss.toUpperCase().includes(b2cPolicies.authorityDomain.toUpperCase()) &&
        account.idTokenClaims.aud === msalConfig.auth.clientId,
    );

    if (accounts.length > 1) {
      // localAccountId identifies the entity for which the token asserts information.
      if (accounts.every(account => account.localAccountId === accounts[0].localAccountId)) {
        // All accounts belong to the same user
        setAccount(accounts[0]);
      } else {
        // Multiple users detected. Logout all to be safe.
        signOut();
      }
    } else if (accounts.length === 1) {
      setAccount(accounts[0]);
    }
  } else if (currentAccounts.length === 1) {
    setAccount(currentAccounts[0]);
  }
}

// in case of page refresh
selectAccount();

async function handleResponse(response) {
  /**
   * To see the full list of response object properties, visit:
   * https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/request-response-object.md#response
   */

  if (response !== null) {
    idToken = response.idToken;

    setAccount(response.account);
  } else {
    selectAccount();
  }
}

export async function signIn() {
  /**
   * You can pass a custom request object below. This will override the initial configuration. For more information, visit:
   * https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/request-response-object.md#request
   */
  myMSALObj.loginRedirect(loginRequest);
}

export function signOut() {
  /**
   * You can pass a custom request object below. This will override the initial configuration. For more information, visit:
   * https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-browser/docs/request-response-object.md#request
   */

  const logoutRequest = {
    postLogoutRedirectUri: msalConfig.auth.redirectUri,
    idTokenHint: idToken,
    mainWindowRedirectUri: msalConfig.auth.redirectUri,
  };

  myMSALObj.logoutRedirect(logoutRequest);
}

function getTokenRedirect(request) {
  /**
   * See here for more info on account retrieval:
   * https://github.com/AzureAD/microsoft-authentication-library-for-js/blob/dev/lib/msal-common/docs/Accounts.md
   */
  request.account = myMSALObj.getAccountByHomeId(accountId);

  /**
   *
   */
  return myMSALObj
    .acquireTokenSilent(request)
    .then(response => {
      // In case the response from B2C server has an empty accessToken field
      // throw an error to initiate token acquisition
      if (!response.accessToken || response.accessToken === "") {
        throw new msal.InteractionRequiredAuthError();
      } else {
        // console.log("access_token acquired at: " + new Date().toString());
        accessToken = response.accessToken;
        expiresOn = addHoursFromNow(tokenExpirationBuffer);

        //make fetch request, and response.accessToken to API
        //API, will add cliams to this token
        //return the udpated token.

        return response.accessToken;
      }
    })
    .catch(error => {
      console.log("Silent token acquisition fails. Acquiring token using popup. \n", error);
      if (error instanceof msal.InteractionRequiredAuthError) {
        // fallback to interaction when silent call fails
        return myMSALObj.acquireTokenRedirect(request);
      } else {
        console.log(error);
      }
    });
}

// Acquires and access token and then passes it to the API call
export function getB2CTokenToApi() {
  if (!accessToken || !expiresOn || new Date() > expiresOn) {
    return getTokenRedirect(tokenRequest);
  } else {
    return accessToken;
  }
}

if (username == "") {
  const oktaConfig = import.meta.env.VITE_AUTH_TYPE == "OKTA";

  if (!oktaConfig) {
    signIn();
  }
}
