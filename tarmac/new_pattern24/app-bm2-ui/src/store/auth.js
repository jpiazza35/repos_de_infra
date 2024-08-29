import { writable } from 'svelte/store'

/**
 * Represents the authenticated state of the user, true when a user is authenticated, false by default.
 * @type {import('svelte/store').Writable<boolean>}
 */
export const isAuthenticated = writable(false)
/**
 * Represents the details of an authenticated user returned by Auth0 after successful authentication.
 * @type {import('svelte/store').Writable<{email: string}>}
 */
export const user = writable(undefined)
/**
 * Represents the error information if the authentication process fails.
 * @type {import('svelte/store').Writable<Error>}
 */
export const error = writable()

export const token = writable(undefined)
