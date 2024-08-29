<script>
  import { Button, List, Li, Popover, Radio } from 'flowbite-svelte'
  import Fa from 'svelte-fa'
  import { faCaretDown, faCheck } from '@fortawesome/pro-solid-svg-icons'
  import { clickOutside } from 'utils/clickOutside.js'
  import { PERIOD_TYPES_OPTIONS, productivityFilterStore } from './filters'

  let popoverOpen = false
  let filters = undefined

  productivityFilterStore.subscribe(storeFilter => {
    filters = structuredClone(storeFilter)
  })

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
    }
  }
</script>

<div use:clickOutside on:click_outside={handleClickOutside}>
  <Button
    on:click={() => (popoverOpen = !popoverOpen)}
    id="periodTypeButton"
    color="light"
    class="text-black text-base border-custom-neutral-300 font-normal rounded h-10 mr-2 my-1 px-2.5"
    data-cy="periodTypeButton"
  >
    Period Type
    <b class="mx-1">{PERIOD_TYPES_OPTIONS.find(option => option.id === $productivityFilterStore.periodType).name}</b>
    <Fa icon={faCaretDown} class={'text-base ml-2'} />
  </Button>

  <Popover arrow={false} class="p-2 w-64 z-10" placement="bottom-start" open={popoverOpen} triggeredBy="#periodTypeButton" trigger="click">
    <div class="mb-5">
      <h4 class="mb-3 text-font text-xl">Period Type</h4>
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
    <div class="flex items-center">
      <Button on:click={applyFilters} color="green" class="text-white text-base font-normal rounded h-10 px-2.5" data-cy="applyPeriodTypeButton">
        <Fa icon={faCheck} class={'text-white mr-1.5'} scale={1} />
        Apply
      </Button>
      <Button
        on:click={cancelChanges}
        color="light"
        class="text-font text-base bg-custom-grey-75 border-custom-grey-75 font-normal ml-2 rounded h-10 px-2.5"
        data-cy="cancelPeriodTypeButton"
      >
        Cancel
      </Button>
    </div>
  </Popover>
</div>
