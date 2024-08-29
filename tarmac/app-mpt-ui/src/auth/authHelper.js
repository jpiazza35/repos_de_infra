import { getB2CTokenToApi, signOut } from "./authRedirect";
import { getAuthTokenToApi, auth0SignOut } from "./auth0";

export const getTokenToApi = async () => {
  if (!isOktaConfig()) {
    return await getB2CTokenToApi();
  } else {
    return await getAuthTokenToApi();
  }
};

export const isOktaConfig = () => {
  const oktaConfig = import.meta.env.VITE_AUTH_TYPE == "OKTA";
  return oktaConfig;
};

export const AuthLogout = async () => {
  if (isOktaConfig()) {
    auth0SignOut();
  } else {
    signOut();
  }
};
