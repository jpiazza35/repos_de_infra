/**
 * Enter here the user flows and custom policies for your B2C application
 * To learn more about user flows, visit: https://docs.microsoft.com/en-us/azure/active-directory-b2c/user-flow-overview
 * To learn more about custom policies, visit: https://docs.microsoft.com/en-us/azure/active-directory-b2c/custom-policy-overview
 */
const VITE_AB2C_SIGNUP_SIGNIN = import.meta.env.VITE_AB2C_SIGNUP_SIGNIN;
const VITE_AB2C_EDIT_PROFILE = import.meta.env.VITE_AB2C_EDIT_PROFILE;
const VITE_AB2C_SIGNUP_SIGNIN_URL =
  "https://" +
  import.meta.env.VITE_AB2C_HOSTNAME +
  "/" +
  import.meta.env.VITE_AB2C_TENANT_ID +
  "/" +
  import.meta.env.VITE_AB2C_SIGNUP_SIGNIN;
const VITE_AB2C_EDIT_PROFILE_URL =
  "https://" +
  import.meta.env.VITE_AB2C_HOSTNAME +
  "/" +
  import.meta.env.VITE_AB2C_TENANT_ID +
  "/" +
  import.meta.env.VITE_AB2C_EDIT_PROFILE;
const VITE_AB2C_HOSTNAME = import.meta.env.VITE_AB2C_HOSTNAME;

export const b2cPolicies = {
  names: {
    signUpSignIn: VITE_AB2C_SIGNUP_SIGNIN,
    editProfile: VITE_AB2C_EDIT_PROFILE,
  },
  authorities: {
    signUpSignIn: {
      authority: VITE_AB2C_SIGNUP_SIGNIN_URL,
    },
    editProfile: {
      authority: VITE_AB2C_EDIT_PROFILE_URL,
    },
  },
  authorityDomain: VITE_AB2C_HOSTNAME,
};
