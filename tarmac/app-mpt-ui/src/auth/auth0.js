import { createAuth0Client } from "@auth0/auth0-spa-js";

let auth0Client = null;
// eslint-disable-next-line no-unused-vars

const configureClient = async () => {
  if (auth0Client == null) {
    const domainParam = import.meta.env.VITE_AUTH0_DOMAIN;
    const clientIDParam = import.meta.env.VITE_AUTH0_CLIENT_ID;
    const redirectLocation = window.location.origin + "/" + import.meta.env.VITE_AUTH0_CALLBACK;

    let audienceParam = "https://mpt.cliniciannexus.com";

    if (window.location.origin.includes(".dev.") || window.location.origin.includes(".qa.") || window.location.origin.includes("localhost")) {
      audienceParam = "https://mpt.dev.cliniciannexus.com";
    }

    auth0Client = await createAuth0Client({
      domain: domainParam,
      clientId: clientIDParam,
      authorizationParams: {
        redirect_uri: redirectLocation,
        audience: audienceParam,
        scope: "openid profile email offline_access",
      },
      useRefreshTokens: true,
      cacheLocation: "localstorage",
    })
      .then(async client => {
        return client;
      })
      .catch(error => {
        console.error(error);
      });
  }
  //auth0Client.logout();
  return auth0Client;
};

export const getAuthTokenToApi = async () => {
  await configureClient();
  return await auth0Client.getTokenSilently();
};

export const getAuth0User = async () => {
  await configureClient();
  let user = await auth0Client.getUser();

  return user;
};

export const getAuth0UserName = async () => {
  await configureClient();
  let user = await auth0Client.getUser();

  return user.nickname;
};

export const isAuthenticated = async () => {
  await configureClient();
  let isAuthenticated = await auth0Client.isAuthenticated();

  return isAuthenticated;
};

export const setupUser = async () => {
  await configureClient();

  const isAuthenticated = await auth0Client.isAuthenticated();

  if (isAuthenticated) {
    await auth0Client.getUser();
  } else {
    if (document.location.pathname == "/callback") {
      await auth0Client
        .handleRedirectCallback()
        .then(async () => {
          window.history.replaceState({}, document.title, "/");

          return await auth0Client.getUser().then(user => {
            return user.name;
          });
        })
        .catch(error => {
          console.error(error);
        });

      //username = user.name;
    } else {
      //debugger;
      await auth0Client.loginWithRedirect();
    }
  }
};

export const auth0SignOut = async () => {
  await configureClient();
  await auth0Client.logout({
    logoutParams: {
      returnTo: window.location.origin,
    },
  });
};
