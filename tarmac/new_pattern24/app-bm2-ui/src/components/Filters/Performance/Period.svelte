<script>
  import { Button, Dropdown, DropdownItem, Radio } from 'flowbite-svelte'
  import Fa from 'svelte-fa'
  import { faCaretDown, faCheck } from '@fortawesome/pro-solid-svg-icons'
  import Popover from 'components/Popover/Popover.svelte'
  import { clickOutside } from 'utils/clickOutside.js'
  import { PERIOD_TIME_TYPES, MONTHS_OPTIONS, QUARTERS_OPTIONS, YEARS_OPTIONS } from './filters'

  export let filterStore

  let popoverOpen = false
  let dropdownCalendarOpen = false
  let dropdownMonthOpen = false
  let dropdownQuarterOpen = false
  let filters = undefined

  filterStore.subscribe(storeFilter => {
    filters = structuredClone(storeFilter)
  })

  $: selectedMonth = MONTHS_OPTIONS[filters.period.month]
  $: selectedQuarter = QUARTERS_OPTIONS[filters.period.quarter]
  $: selectedYear = filters ? filters.period.year : 2023

  const getQuarterLabel = quarter => {
    return `${quarter} ${selectedYear}`
  }

  const getMonthLabel = month => {
    return `${month} ${selectedYear}`
  }

  const selectYear = year => {
    selectedYear = year
    filters.period.year = year
    dropdownCalendarOpen = false
  }

  const selectQuarter = quarter => {
    filters.period.quarter = quarter
    dropdownQuarterOpen = false
  }

  const selectMonth = month => {
    filters.period.month = month
    dropdownMonthOpen = false
  }

  const applyFilters = () => {
    filterStore.set(filters)
    popoverOpen = false
  }

  const cancelChanges = () => {
    filters = structuredClone($filterStore)
    popoverOpen = false
  }

  const handleClickOutside = () => {
    if (popoverOpen) {
      cancelChanges()
      popoverOpen = false
    }
  }
</script>

<div use:clickOutside on:click_outside={handleClickOutside}>
  <Button
    id="periodButton"
    color="light"
    class="text-black text-base border-custom-neutral-300 font-normal rounded h-10 mr-2 my-1 px-2.5"
    data-cy="periodButton"
  >
    Period
    <b class="mx-1"
      >Calendar Year {$filterStore.period.year}, {$filterStore.period.type === PERIOD_TIME_TYPES.MONTH
        ? MONTHS_OPTIONS[$filterStore.period.month]
        : QUARTERS_OPTIONS[$filterStore.period.quarter]}</b
    >
    <Fa icon={faCaretDown} class={'text-base ml-2'} />
  </Button>

  <Popover bind:open={popoverOpen} triggeredBy="#periodButton">
    <div class="mb-5">
      <h4 class="mb-2 text-font text-xl">Period</h4>
      <h4 class="mb-3 italic text-font text-sm">Year, Month or Quarter</h4>
      <Button
        on:click={() => (dropdownCalendarOpen = !dropdownCalendarOpen)}
        color="light"
        class="font-normal px-2.5 h-10 justify-between rounded text-font text-base bg-custom-grey-75 hover:bg-neutral-200 w-48"
        data-cy="yearCalendarButton"
        >Calendar Year {filters.period.year}
        <Fa icon={faCaretDown} class="h-1.5 ml-2" />
      </Button>
      <Dropdown class="rounded bg-white w-48" open={dropdownCalendarOpen}>
        {#each YEARS_OPTIONS as year}
          <DropdownItem class="hover:bg-primary-green-500 hover:text-white font-normal text-base h-10" on:click={() => selectYear(year)}>
            {year}
          </DropdownItem>
        {/each}
      </Dropdown>
    </div>
    <div class="mb-5">
      <div class="my-2 flex items-center w-full" data-cy="periodMonth">
        <Radio name="period" class="mr-1" color="green" bind:group={filters.period.type} value={PERIOD_TIME_TYPES.MONTH} />
        <Button
          on:click={() => (dropdownMonthOpen = !dropdownMonthOpen)}
          color="light"
          class="font-normal px-2.5 h-10 justify-between rounded text-font text-base bg-custom-grey-75 hover:bg-neutral-200 w-40"
          data-cy="periodMonthButton"
          disabled={filters.period.type !== PERIOD_TIME_TYPES.MONTH}
          >{filters.period.type === PERIOD_TIME_TYPES.MONTH ? getMonthLabel(selectedMonth) : 'Month'}
          <Fa icon={faCaretDown} class="h-1.5 ml-2" />
        </Button>
        <Dropdown class="rounded bg-white overflow-auto h-72 w-48" open={dropdownMonthOpen}>
          {#each MONTHS_OPTIONS as month, index}
            <DropdownItem class="hover:bg-primary-green-500 hover:text-white font-normal text-base h-10" on:click={() => selectMonth(index)}>
              {getMonthLabel(month)}
            </DropdownItem>
          {/each}
        </Dropdown>
      </div>
      <div class="my-2 flex items-center w-full" data-cy="periodQuarter">
        <Radio name="period" class="mr-1" color="green" bind:group={filters.period.type} value={PERIOD_TIME_TYPES.QUARTER} />
        <Button
          on:click={() => (dropdownQuarterOpen = !dropdownQuarterOpen)}
          color="light"
          class="font-normal px-2.5 h-10 justify-between rounded text-font text-base bg-custom-grey-75 hover:bg-neutral-200 w-40"
          disabled={filters.period.type !== PERIOD_TIME_TYPES.QUARTER}
          data-cy="periodQuarterButton"
          >{filters.period.type === PERIOD_TIME_TYPES.QUARTER ? getQuarterLabel(selectedQuarter) : 'Quarter'}
          <Fa icon={faCaretDown} class="h-1.5 ml-2" />
        </Button>
        <Dropdown class="rounded bg-white w-48" open={dropdownQuarterOpen}>
          {#each QUARTERS_OPTIONS as quarter, index}
            <DropdownItem class="hover:bg-primary-green-500 hover:text-white font-normal text-base h-10" on:click={() => selectQuarter(index)}>
              {getQuarterLabel(quarter)}
            </DropdownItem>
          {/each}
        </Dropdown>
      </div>
    </div>
    <div class="flex items-center">
      <Button
        on:click={applyFilters}
        color="green"
        class="text-white text-base font-normal rounded h-10 px-2.5"
        id="applyPeriodButton"
        data-cy="applyPeriodButton"
      >
        <Fa icon={faCheck} class={'text-white mr-1.5'} scale={1} />
        Apply
      </Button>
      <Button
        on:click={cancelChanges}
        color="light"
        class="text-font text-base bg-custom-grey-75 border-custom-grey-75 font-normal ml-2 rounded h-10 px-2.5"
        id="cancelPeriodButton"
        data-cy="cancelPeriodButton"
      >
        Cancel
      </Button>
    </div>
  </Popover>
</div>
