/**
 * @typedef {Object} SortByOption
 * @property {string} label
 * @property {string} type
 */

/** @type {Array<SortByOption>} */
export const SORT_OPTIONS = [
  {
    label: 'Charge Lag',
    type: 'LH',
  },
  {
    label: 'Charge Post Date',
    type: 'EL',
  },
  {
    label: 'Patient Number',
    type: 'LH',
  },
  {
    label: 'CPT Mod 1',
    type: 'AZ',
  },
  {
    label: 'CPT Mod 2',
    type: 'AZ',
  },
  {
    label: 'CPT Mod 3',
    type: 'AZ',
  },
  {
    label: 'CPT Mod 4',
    type: 'AZ',
  },
  {
    label: 'Billing Code',
    type: 'LH',
  },
  {
    label: 'Billing Code Description',
    type: 'AZ',
  },
  {
    label: 'Service Group',
    type: 'AZ',
  },
  {
    label: 'Billing Org',
    type: 'AZ',
  },
  {
    label: 'CPT Code',
    type: 'LH',
  },
  {
    label: 'wRVUs',
    type: 'LH',
  },
  {
    label: 'Units',
    type: 'LH',
  },
]
