import { get, writable } from 'svelte/store'

export const PERIOD_TIME_TYPES = {
  MONTH: 'month',
  QUARTER: 'quarter',
}

export const SPECIALTY_OPTIONS = [
  {
    id: 'family',
    name: 'Family Medicine',
  },
]

export const PERIOD_TYPES_OPTIONS = [
  {
    id: 'main',
    name: 'Main',
  },
  {
    id: 'shadow',
    name: 'Shadow',
  },
  {
    id: 'contract',
    name: 'Contract',
  },
]

export const YEARS_OPTIONS = [2022, 2023]

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

function createPerformanceFilterStore() {
  const { subscribe, set, update } = writable(
    localStorage.getItem('performanceFilters')
      ? JSON.parse(localStorage.getItem('performanceFilters'))
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
      }),
    resetDefaultFilters: () => {
      localStorage.removeItem('performanceFilters')
    },
    setDefaultFilters: () => {
      const data = JSON.stringify(get(performanceFilterStore))
      localStorage.setItem('performanceFilters', data)
    },
  }
}

export const performanceFilterStore = createPerformanceFilterStore()
