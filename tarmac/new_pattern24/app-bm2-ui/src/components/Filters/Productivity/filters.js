import { get, writable } from 'svelte/store'

export const SPECIALTY_OPTIONS = [
  {
    id: 'family',
    name: 'Family Medicine',
  },
]

export const PERIOD_TYPES = {
  CALENDAR: 'calentar',
  FISCAL: 'fiscal',
  CONTRACT: 'contract',
}

export const PERIOD_TYPES_OPTIONS = [
  {
    id: 'calentar',
    name: 'Calendar Year',
  },
  {
    id: 'fiscal',
    name: 'Fiscal Year',
  },
]

export const YEARS_OPTIONS = [2021, 2022, 2023]

export const MONTHS_OPTIONS = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
]

export const QUARTERS_OPTIONS = [`Qtr 1`, `Qtr 2`, `Qtr 3`, `Qtr 4`]

export const PERIOD_TIME_TYPES = {
  MONTH: 'month',
  QUARTER: 'quarter',
}

export const GROUP_OPTIONS = [
  { id: 'hospital', name: 'Hospital' },
  { id: 'imaging', name: 'Imaging' },
  { id: 'officeEstablished', name: 'Office Established' },
  { id: 'officeNew', name: 'Office New' },
  { id: 'other', name: 'Other' },
  { id: 'preventative', name: 'Preventative' },
  { id: 'snf', name: 'SNF' },
  { id: 'surgical', name: 'Surgical' },
]

function createProductivityFilterStore() {
  const { subscribe, set, update } = writable(
    localStorage.getItem('productivityFilters')
      ? JSON.parse(localStorage.getItem('productivityFilters'))
      : {
          specialty: {
            family: true,
          },
          periodType: PERIOD_TYPES_OPTIONS[0].id,
          period: {
            year: 2023,
            month: 7,
            quarter: 0,
            type: PERIOD_TIME_TYPES.MONTH,
          },
          serviceGroup: ['hospital', 'imaging', 'officeEstablished', 'officeNew', 'other', 'preventative', 'snf', 'surgical'],
        },
  )

  return {
    subscribe,
    set,
    update,
    reset: () =>
      set({
        specialty: {
          family: true,
        },
        periodType: PERIOD_TYPES_OPTIONS[0].id,
        period: {
          year: 2023,
          month: 7,
          quarter: 0,
          type: PERIOD_TIME_TYPES.MONTH,
        },
        serviceGroup: ['hospital', 'imaging', 'officeEstablished', 'officeNew', 'other', 'preventative', 'snf', 'surgical'],
      }),
    resetDefaultFilters: () => {
      localStorage.removeItem('productivityFilters')
    },
    setDefaultFilters: () => {
      const data = JSON.stringify(get(productivityFilterStore))
      localStorage.setItem('productivityFilters', data)
    },
  }
}

export const productivityFilterStore = createProductivityFilterStore()
