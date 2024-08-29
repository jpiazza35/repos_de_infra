<script>
  import { Button, Checkbox, List, Li, Popover } from 'flowbite-svelte'
  import Fa from 'svelte-fa'
  import { faCaretDown, faCheck } from '@fortawesome/pro-solid-svg-icons'
  import { clickOutside } from 'utils/clickOutside.js'
  import { performanceFilterStore, SPECIALTY_OPTIONS } from './filters'

  let popoverOpen = false
  let filters = undefined

  performanceFilterStore.subscribe(storeFilter => {
    filters = structuredClone(storeFilter)
  })

  const applyFilters = () => {
    performanceFilterStore.set(filters)
    popoverOpen = false
  }

  const cancelChanges = () => {
    filters = structuredClone($performanceFilterStore)
    popoverOpen = false
  }

  const handleClickOutside = () => {
    if (popoverOpen) {
      cancelChanges()
    }
  }

  $: disabledFilter = !Object.values(filters.specialty).every(specialty => specialty)
</script>

<div use:clickOutside on:click_outside={handleClickOutside}>
  <Button
    on:click={() => (popoverOpen = !popoverOpen)}
    id="specialtyButton"
    color={disabledFilter ? 'red' : 'light'}
    class={disabledFilter
      ? 'text-white bg-error border-error font-normal rounded h-10 mr-2 px-2.5 my-1'
      : 'text-base border-custom-neutral-300 font-normal rounded h-10 mr-2 px-2.5 my-1'}
    data-cy="specialtyButton"
  >
    Specialty
    {#if $performanceFilterStore.specialty.family && $performanceFilterStore.specialty.internal}
      <b class="mx-1">Family Medicine</b> or <b class="ml-1">Internal Medicine</b>
    {:else if $performanceFilterStore.specialty.family}
      <b class="ml-1">Family Medicine</b>
    {:else if $performanceFilterStore.specialty.internal}
      <b class="ml-1">Internal Medicine</b>
    {/if}
    <Fa icon={faCaretDown} class={'text-base ml-2'} />
  </Button>

  <Popover arrow={false} class="p-2 w-64 z-10" placement="bottom-start" open={popoverOpen} triggeredBy="#specialtyButton" trigger="click">
    <div class="mb-5">
      <h4 class="mb-3 text-font text-xl">Specialty</h4>
      <List class="ml-2" list="none" data-cy="specialtyList">
        {#each SPECIALTY_OPTIONS as specialty}
          <Li class="my-2 flex items-center w-full">
            <Checkbox class="mr-1" color="green" bind:checked={filters.specialty[specialty.id]} />
            <span class="text-font" data-cy="familyMedicine">{specialty.name}</span>
          </Li>
        {/each}
      </List>
    </div>
    <div class="flex items-center">
      <Button
        on:click={applyFilters}
        color="green"
        class="text-white text-base font-normal rounded h-10 px-2.5"
        disabled={disabledFilter}
        data-cy="applySpecialtyButton"
      >
        <Fa icon={faCheck} class={'text-white mr-1.5'} scale={1} />
        Apply
      </Button>
      <Button
        on:click={cancelChanges}
        color="light"
        class="text-font text-base bg-custom-grey-75 border-custom-grey-75 font-normal ml-2 rounded h-10 px-2.5"
        data-cy="cancelSpecialtyButton"
      >
        Cancel
      </Button>
    </div>
  </Popover>
</div>
