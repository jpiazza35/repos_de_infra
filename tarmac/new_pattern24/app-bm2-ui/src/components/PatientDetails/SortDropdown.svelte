<script>
  import { Button, Dropdown, DropdownItem } from 'flowbite-svelte'
  import Fa from 'svelte-fa'
  import { faCaretDown, faCaretUp, faSort } from '@fortawesome/pro-solid-svg-icons'
  import { SORT_OPTIONS } from './sorts'

  let dropdownOpen = false
  $: selectedFilter = {
    label: 'Charge Lag',
    type: 'LH',
    from: 'down',
  }

  const onSelectFilter = (filter, from) => {
    selectedFilter = { ...filter, from }
    dropdownOpen = false
  }

  const getFilterType = (type, from) => {
    switch (type) {
      case 'LH':
        return from === 'up' ? 'from lowest-highest' : 'from highest-lowest'
      case 'EL':
        return from === 'up' ? 'from earliest-latest' : 'from latest-earliest'
      case 'AZ':
        return from === 'up' ? 'from A-Z' : 'from Z-A'
      default:
        break
    }
  }
</script>

<Button
  on:click={() => {
    dropdownOpen = !dropdownOpen
  }}
  color="light"
  class="text-black text-base  bg-custom-neutral-75 border-custom-neutral-75 font-normal justify-between rounded h-10 laptop:mx-2 laptop:px-3 laptop:max-w-[350px] mobile:mx-1 mobile:px-1 mobile:w-full"
  data-cy="patientDetailsFilters"
>
  <Fa icon={faSort} class={'text-black mr-3'} scale={1} />
  <span>
    Sort by {selectedFilter.label}<span class="text-sm italic">&nbsp;{getFilterType(selectedFilter.type, selectedFilter.from)}</span>
  </span>
  <Fa icon={faCaretDown} class={'text-black ml-3 text-bold'} scale={1} />
</Button>
<Dropdown class="rounded-sm py-0 w-[325px]" bind:open={dropdownOpen}>
  {#each SORT_OPTIONS as sort}
    <div class="border-b border-black">
      <DropdownItem
        on:click={() => onSelectFilter(sort, 'up')}
        class="flex items-center justify-between text-base text-font border-b border-custom-grey-75 font-normal hover:text-primary-green-500 hover:bg-custom-neutral-50"
        data-cy={`option-${sort.label.replaceAll(' ', '')}-${getFilterType(sort.type, 'up').replace('from ', '')}`}
      >
        <span class="flex items-center">
          <Fa icon={faCaretUp} class={'mr-2 text-inherit'} scale={1} />{sort.label}
        </span>
        <span class="italic text-sm">{getFilterType(sort.type, 'up')}</span>
      </DropdownItem>
      <DropdownItem
        on:click={() => onSelectFilter(sort, 'down')}
        class="flex items-center justify-between text-base text-font font-normal hover:text-primary-green-500 hover:bg-custom-neutral-50"
        data-cy={`option-${sort.label.replaceAll(' ', '')}-${getFilterType(sort.type, 'down').replace('from ', '')}`}
      >
        <span class="flex items-center"> <Fa icon={faCaretDown} class={'mr-2 text-inherit'} scale={1} />{sort.label}</span>
        <span class="italic text-sm">{getFilterType(sort.type, 'down')}</span>
      </DropdownItem>
    </div>
  {/each}
</Dropdown>
