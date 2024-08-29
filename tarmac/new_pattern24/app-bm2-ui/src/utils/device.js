import { writable, derived } from 'svelte/store'
import { isCypressTest } from 'utils/constants'

export const width = writable(0)

/**
 * Returns the current device type
 * @param {number} [width]
 * @returns ['desktop'|'laptop'|'tablet'|'mobile']
 */
export const device = derived([width], ([width]) => {
  if (width >= 1920 || isCypressTest) {
    return 'desktop'
  } else if (width >= 1440) {
    return 'laptop'
  } else if (width >= 768) {
    return 'tablet'
  } else {
    return 'mobile'
  }
})
