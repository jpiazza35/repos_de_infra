// The current application coordinates were pre-registered in a B2C tenant.
const VITE_AB2C_SCOPES = import.meta.env.VITE_AB2C_SCOPES.split(",");

export const apiConfig = {
  b2cScopes: VITE_AB2C_SCOPES,
};
