<script>
  import { Button, Dropdown, DropdownItem, Radio } from 'flowbite-svelte'
  import Fa from 'svelte-fa'
  import { faCaretDown, faCheck } from '@fortawesome/pro-solid-svg-icons'
  import Popover from 'components/Popover/Popover.svelte'
  import { clickOutside } from 'utils/clickOutside.js'
  import { PERIOD_TYPES, PERIOD_TIME_TYPES, YEARS_OPTIONS, MONTHS_OPTIONS, QUARTERS_OPTIONS, productivityFilterStore } from './filters'

  let popoverOpen = false
  let dropdownCalendarOpen = false
  let dropdownMonthOpen = false
  let dropdownQuarterOpen = false
  let filters = undefined

  productivityFilterStore.subscribe(storeFilter => {
    filters = structuredClone(storeFilter)
  })

  $: MONTHS = filters && filters.periodType === PERIOD_TYPES.CONTRACT ? MONTHS_OPTIONS.concat(MONTHS_OPTIONS) : MONTHS_OPTIONS
  $: selectedMonth = MONTHS[filters.period.month]
  $: selectedQuarter = QUARTERS_OPTIONS[filters.period.quarter]
  $: selectedYear = filters ? filters.period.year : 2022

  const getYearLabel = year => {
    switch (filters.periodType) {
      case PERIOD_TYPES.CALENDAR:
        return `Calendar Year ${year}`
      case PERIOD_TYPES.FISCAL:
        return `Fiscal Year ${year}`
      case PERIOD_TYPES.CONTRACT:
        return `Contract Year ${year}`
    }
    return
  }

  const getMonthLabel = (month, index) => {
    return `${month} ${index <= 11 ? selectedYear : selectedYear + 1}`
  }

  const getQuarterLabel = quarter => {
    return `${quarter} ${selectedYear}`
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
    productivityFilterStore.set(filters)
    popoverOpen = false
  }

  const cancelChanges = () => {
    filters = structuredClone($productivityFilterStore)
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
      >{getYearLabel($productivityFilterStore.period.year)}, {$productivityFilterStore.period.type === PERIOD_TIME_TYPES.MONTH
        ? MONTHS[$productivityFilterStore.period.month]
        : QUARTERS_OPTIONS[$productivityFilterStore.period.quarter]}</b
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
        >{getYearLabel(filters.period.year)}
        <Fa icon={faCaretDown} class="h-1.5 ml-2" />
      </Button>
      <Dropdown class="rounded bg-white w-48" open={dropdownCalendarOpen}>
        {#each YEARS_OPTIONS as year}
          <DropdownItem class="hover:bg-primary-green-500 hover:text-white font-normal text-base h-10" on:click={() => selectYear(year)}>
            {getYearLabel(year)}
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
          class="font-normal px-2 h-10 justify-between rounded text-font text-base bg-custom-grey-75 hover:bg-neutral-200 w-40"
          disabled={filters.period.type !== PERIOD_TIME_TYPES.MONTH}
          data-cy="periodMonthButton"
          >{filters.period.type === PERIOD_TIME_TYPES.MONTH ? getMonthLabel(selectedMonth, filters.period.month) : 'Month'}
          <Fa icon={faCaretDown} class="h-1.5 ml-2" />
        </Button>
        <Dropdown class="rounded bg-white overflow-auto h-72 w-48" open={dropdownMonthOpen}>
          {#each MONTHS as month, index}
            <DropdownItem class="hover:bg-primary-green-500 hover:text-white font-normal text-base h-10" on:click={() => selectMonth(index)}>
              {getMonthLabel(month, index)}
            </DropdownItem>
          {/each}
        </Dropdown>
      </div>
      <div class="my-2 flex items-center w-full" data-cy="periodQuarter">
        <Radio name="period" class="mr-1" color="green" bind:group={filters.period.type} value={PERIOD_TIME_TYPES.QUARTER} />
        <Button
          on:click={() => (dropdownQuarterOpen = !dropdownQuarterOpen)}
          color="light"
          class="font-normal px-2 h-10 justify-between rounded text-font text-base bg-custom-grey-75 hover:bg-neutral-200 w-40"
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
      <Button on:click={applyFilters} color="green" class="text-white text-base font-normal rounded h-10 px-2.5" data-cy="applyPeriodButton">
        <Fa icon={faCheck} class={'text-white mr-1.5'} scale={1} />
        Apply
      </Button>
      <Button
        on:click={cancelChanges}
        color="light"
        class="text-font text-base bg-custom-grey-75 border-custom-grey-75 font-normal ml-2 rounded h-10 px-2.5"
        data-cy="cancelPeriodButton"
      >
        Cancel
      </Button>
    </div>
  </Popover>
</div>
