<script>
  import { Button, List, Li, Popover, Checkbox } from 'flowbite-svelte'
  import Fa from 'svelte-fa'
  import { faCaretDown, faCheck } from '@fortawesome/pro-solid-svg-icons'
  import { clickOutside } from 'utils/clickOutside.js'
  import { productivityFilterStore, GROUP_OPTIONS } from './filters'

  let popoverOpen = false
  let filters = undefined
  $: disabledFilter = filters && filters.serviceGroup.length === 0

  productivityFilterStore.subscribe(storeFilter => {
    filters = structuredClone(storeFilter)
  })

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
    id="serviceGroupButton"
    color={disabledFilter ? 'red' : 'light'}
    class={disabledFilter
      ? 'text-base text-white bg-error border-error font-normal rounded h-10 mr-2 px-2.5 my-1'
      : 'text-black text-base border-custom-neutral-300 font-normal rounded h-10 mr-2 px-2.5 my-1'}
    data-cy="serviceGroupButton"
  >
    Service Group
    {#if $productivityFilterStore.serviceGroup.length === GROUP_OPTIONS.length}
      <b class="mx-1">Show all</b>
    {:else if $productivityFilterStore.serviceGroup.length === 1}
      <b class="mx-1">{GROUP_OPTIONS.find(group => group.id === $productivityFilterStore.serviceGroup[0]).name}</b>
    {:else if $productivityFilterStore.serviceGroup.length === 2}
      <b class="mx-1">{GROUP_OPTIONS.find(group => group.id === $productivityFilterStore.serviceGroup[0]).name}</b>, or other
    {:else if $productivityFilterStore.serviceGroup.length > 2}
      <b class="mx-1">{GROUP_OPTIONS.find(group => group.id === $productivityFilterStore.serviceGroup[0]).name}</b>, or {$productivityFilterStore
        .serviceGroup.length - 1} others
    {/if}
    <Fa icon={faCaretDown} class={'text-base ml-2'} />
  </Button>

  <Popover arrow={false} class="p-2 w-64 z-10" placement="bottom-start" open={popoverOpen} triggeredBy="#serviceGroupButton" trigger="click">
    <div class="mb-5">
      <h4 class="mb-3 text-font text-xl">Service Group</h4>
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
    <div class="flex items-center">
      <Button
        on:click={applyFilters}
        color="green"
        class="text-white text-base font-normal rounded h-10 px-2.5"
        disabled={disabledFilter}
        data-cy="serviceGroupApplyButton"
      >
        <Fa icon={faCheck} class={'text-white mr-1.5'} scale={1} />
        Apply
      </Button>
      <Button
        on:click={cancelChanges}
        color="light"
        class="text-font text-base bg-custom-grey-75 border-custom-grey-75 font-normal ml-2 rounded h-10 px-2.5"
        data-cy="serviceGroupCancelButton"
      >
        Cancel
      </Button>
    </div>
  </Popover>
</div>
