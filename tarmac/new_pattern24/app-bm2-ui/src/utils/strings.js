const dollarFormatter = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'USD',
  // These options are needed to round to whole numbers if that's what you want.
  //minimumFractionDigits: 0, // (this suffices for whole numbers, but will print 2500.10 as $2,500.1)
  //maximumFractionDigits: 0, // (causes 2500.99 to be printed as $2,501)
})

/**
 * Format a number to a string with 2 decimal places: 2283 -> $2,283.00
 * @param {number} value
 * @returns {string}
 */
export const dollarFormat = value => dollarFormatter.format(value)

const numberFormatter = new Intl.NumberFormat('en-US', {
  minimumFractionDigits: 2,
  maximumFractionDigits: 2,
})

/**
 * Format a number to a string with 2 decimal places: 2283 -> 2,283.00
 * @param {number} value
 * @returns {string}
 */
export const numberFormat = value => numberFormatter.format(value)

const s = ['th', 'st', 'nd', 'rd']
export function getOrdinalNumberSuffix(n) {
  const v = n % 100
  return s[(v - 20) % 10] || s[v] || s[0]
}
export default function toOrdinalNumber(n) {
  return `${n}${getOrdinalNumberSuffix(n)}`
}

export const guidGenerator = () => btoa(Math.random().toString()).substring(0, 12)

export const rgbToHex = rgb => {
  const hex = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/)
  if (!hex) {
    return rgb
  }

  return `#${((1 << 24) | (parseInt(hex[1]) << 16) | (parseInt(hex[2]) << 8) | parseInt(hex[3])).toString(16).slice(1)}`.toLocaleUpperCase()
}

/**
 * Converts a given string to camelCase with the first letter in lowercase.
 * @param {string} str - The string to be converted.
 * @returns {string} - The string camel cased.
 */
export const toCamelCase = str => {
  return str
    .replace(/-/g, ' ')
    .split(' ')
    .map((word, index) => {
      if (index === 0) return word.toLowerCase()
      return word?.charAt(0)?.toUpperCase() + word?.slice(1)?.toLowerCase()
    })
    .join('')
}
