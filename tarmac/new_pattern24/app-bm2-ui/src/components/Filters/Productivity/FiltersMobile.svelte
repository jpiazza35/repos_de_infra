<script>
  import { Button, Checkbox, Dropdown, DropdownItem, List, Li, Radio } from 'flowbite-svelte'
  import Fa from 'svelte-fa'
  import { faCheck, faCaretDown, faFilterList, faArrowRotateLeft } from '@fortawesome/pro-solid-svg-icons'
  import Accordion from 'components/Accordion/Accordion.svelte'
  import Sidebar from 'components/Sidebar/Sidebar.svelte'
  import { device } from 'utils/device'
  import {
    productivityFilterStore,
    GROUP_OPTIONS,
    PERIOD_TYPES,
    PERIOD_TYPES_OPTIONS,
    PERIOD_TIME_TYPES,
    MONTHS_OPTIONS,
    QUARTERS_OPTIONS,
    SPECIALTY_OPTIONS,
    YEARS_OPTIONS,
  } from './filters'

  const headerErrorClass = 'bg-error text-white'
  let filters = undefined
  let open = false
  let dropdownCalendarOpen = false
  let dropdownMonthOpen = false
  let dropdownQuarterOpen = false
  $: invalidSpecialty = filters && !Object.values(filters.specialty).every(specialty => specialty)
  $: invalidServiceGroup = filters && filters.serviceGroup.length === 0
  $: disabledFilter = invalidSpecialty || invalidServiceGroup
  $: MONTHS = filters && filters.periodType === PERIOD_TYPES.CONTRACT ? MONTHS_OPTIONS.concat(MONTHS_OPTIONS) : MONTHS_OPTIONS
  $: selectedMonth = MONTHS[filters.period.month]
  $: selectedQuarter = QUARTERS_OPTIONS[filters.period.quarter]
  $: selectedYear = filters ? filters.period.year : 2022

  productivityFilterStore.subscribe(storeFilter => {
    filters = structuredClone(storeFilter)
  })

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

  const selectMonth = month => {
    filters.period.month = month
    dropdownMonthOpen = false
  }

  const selectQuarter = quarter => {
    filters.period.quarter = quarter
    dropdownQuarterOpen = false
  }

  const selectGroup = (id, event) => {
    if (id === 'all' && event.target.checked) {
      filters.serviceGroup = GROUP_OPTIONS.map(group => group.id)
    } else if (id === 'all' && !event.target.checked) {
      filters.serviceGroup = []
    } else if (filters.serviceGroup.includes(id)) {
      filters.serviceGroup = filters.serviceGroup.filter(group => group !== id)
    } else {
      filters.serviceGroup = [...filters.serviceGroup, id]
    }
  }

  const applyFilters = () => {
    productivityFilterStore.set(filters)
    open = false
  }

  const clearFilters = () => {
    productivityFilterStore.reset()
  }
</script>

<Button
  on:click={() => {
    open = true
  }}
  color="light"
  class="text-black text-base bg-custom-neutral-75 border-custom-neutral-75 font-normal rounded h-10 px-3 mr-2"
  data-cy="showFiltersButton"
>
  <Fa icon={faFilterList} class={'text-base mr-2'} />
  Filters
</Button>

<Sidebar bind:open on:close={clearFilters} class={$device === 'tablet' ? '!w-1/2' : '!w-4/5'} style={'height: calc(100% - 200px);'} title="Filters">
  <div class="h-full overflow-auto">
    <div class="flex flex-wrap items-center px-4 py-5">
      <div class="border border-font h-6 m-1 px-2 text-font text-sm rounded">
        {SPECIALTY_OPTIONS.find(specialty => $productivityFilterStore.specialty[specialty.id] === true).name}
      </div>
      <div class="border border-font h-6 m-1 px-2 text-font text-sm rounded">
        {PERIOD_TYPES_OPTIONS.find(periodType => $productivityFilterStore.periodType === periodType.id).name}
      </div>
      <div class="border border-font h-6 m-1 px-2 text-font text-sm rounded">
        Calendar Year {$productivityFilterStore.period.year}
      </div>
      <div class="border border-font h-6 m-1 px-2 text-font text-sm rounded">
        {$productivityFilterStore.period.type === PERIOD_TIME_TYPES.MONTH
          ? MONTHS_OPTIONS[$productivityFilterStore.period.month]
          : QUARTERS_OPTIONS[$productivityFilterStore.period.quarter]}
      </div>
      <div class="border border-font h-6 m-1 px-2 text-font text-sm rounded">
        Service Group{$productivityFilterStore.serviceGroup.length === GROUP_OPTIONS.length
          ? ' All'
          : ` +${$productivityFilterStore.serviceGroup.length}`}
      </div>
    </div>
    <Accordion
      class="shadow-none border-t border-t-custom-grey-75"
      headerClass={`h-[50px] ${invalidSpecialty ? headerErrorClass : ''}`}
      iconClass={`${invalidSpecialty ? 'text-white' : ''}`}
      open
    >
      <h4 class="flex font-bold items-center" slot="head">Specialty</h4>
      <div class="pt-2" slot="details">
        <List class="ml-2" list="none" data-cy="specialtyList">
          {#each SPECIALTY_OPTIONS as specialty}
            <Li class="my-2 flex items-center w-full">
              <Checkbox class="mr-1" color="green" bind:checked={filters.specialty[specialty.id]} />
              <span class="text-font" data-cy="familyMedicine">{specialty.name}</span>
            </Li>
          {/each}
        </List>
      </div>
    </Accordion>
    <Accordion class="shadow-none border-t border-t-custom-grey-75" headerClass={`h-[50px]`} open>
      <h4 class="flex font-bold items-center" slot="head">Period Type</h4>
      <div class="pt-2" slot="details">
        <List class="ml-2" list="none" data-cy="periodTypeList">
          {#each PERIOD_TYPES_OPTIONS as periodType}
            <Li class="my-2 flex items-center w-full">
              <Radio
                name="periodType"
                class="mr-1"
                color="green"
                disabled={periodType.id === 'fiscal'}
                bind:group={filters.periodType}
                value={periodType.id}
              />
              <span class="text-font" data-cy="mainComp">{periodType.name}</span>
            </Li>
          {/each}
        </List>
      </div>
    </Accordion>
    <Accordion class="shadow-none border-t border-t-custom-grey-75" headerClass={`h-[50px]`} open>
      <h4 class="flex font-bold items-center" slot="head">Period</h4>
      <div class="pt-2" slot="details">
        <h4 class="mb-3 italic text-font text-sm">Year, Month or Quarter</h4>
        <Button
          on:click={() => (dropdownCalendarOpen = !dropdownCalendarOpen)}
          color="light"
          class="font-normal px-2.5 h-10 justify-between rounded text-font text-base bg-custom-grey-75 hover:bg-neutral-200 w-48"
          data-cy="yearCalendarButton"
          >{getYearLabel(filters.period.year)}
          <Fa icon={faCaretDown} class="h-1.5 ml-2" />
        </Button>
        <Dropdown class="rounded bg-white w-48" bind:open={dropdownCalendarOpen}>
          {#each YEARS_OPTIONS as year}
            <DropdownItem class="hover:bg-primary-green-500 hover:text-white font-normal text-base h-10" on:click={() => selectYear(year)}>
              {getYearLabel(year)}
            </DropdownItem>
          {/each}
        </Dropdown>
        <div class="ml-2 mb-2 mt-4">
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
            <Dropdown class="rounded bg-white overflow-auto h-72 w-48" bind:open={dropdownMonthOpen}>
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
            <Dropdown class="rounded bg-white w-48" bind:open={dropdownQuarterOpen}>
              {#each QUARTERS_OPTIONS as quarter, index}
                <DropdownItem class="hover:bg-primary-green-500 hover:text-white font-normal text-base h-10" on:click={() => selectQuarter(index)}>
                  {getQuarterLabel(quarter)}
                </DropdownItem>
              {/each}
            </Dropdown>
          </div>
        </div>
      </div>
    </Accordion>
    <Accordion
      class="shadow-none border-t border-t-custom-grey-75"
      headerClass={`h-[50px] ${invalidServiceGroup ? headerErrorClass : ''}`}
      iconClass={`${invalidServiceGroup ? 'text-white' : ''}`}
      open
    >
      <h4 class="flex font-bold items-center" slot="head">Service Group</h4>
      <div class="pt-2" slot="details">
        <List class="ml-2" list="none" data-cy="serviceGroupList">
          <Li class="my-2 flex items-center w-full">
            <Checkbox
              class="mr-1"
              color="green"
              checked={filters.serviceGroup.length === GROUP_OPTIONS.length}
              on:click={event => {
                selectGroup('all', event)
              }}
            />
            <span class="text-font" data-cy={`serviceGroupOption-all`}>Show all</span>
          </Li>
          {#each GROUP_OPTIONS as group, index}
            <Li class="my-2 flex items-center w-full">
              <Checkbox
                class="mr-1"
                color="green"
                checked={filters.serviceGroup.includes(group.id)}
                on:click={event => {
                  selectGroup(group.id, event)
                }}
              />
              <span class="text-font" data-cy={`serviceGroupOption-${index}`}>{group.name}</span>
            </Li>
          {/each}
        </List>
      </div>
    </Accordion>
  </div>
  <div class="flex flex-col items-center px-4 py-5 border-t border-t-custom-grey-75 sticky w-full bottom-0 bg-white">
    <Button
      on:click={clearFilters}
      color="light"
      class={'max-w-[245px] w-full mb-4 text-black text-base border-warning font-normal rounded h-10 mx-2 px-2.5'}
      data-cy="filtersClearButton"
    >
      <Fa icon={faArrowRotateLeft} class={'text-base mr-2'} scale={1} />
      Reset Filters
    </Button>
    <Button
      on:click={applyFilters}
      color="green"
      class="max-w-[245px] w-full text-white text-base font-normal rounded h-10 px-2.5"
      disabled={disabledFilter}
      data-cy="filtersApplyButton"
    >
      <Fa icon={faCheck} class={'text-white mr-1.5'} scale={1} />
      Apply
    </Button>
  </div>
</Sidebar>
