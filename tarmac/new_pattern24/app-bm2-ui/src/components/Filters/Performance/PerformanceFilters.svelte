<script>
  import { Toggle } from 'flowbite-svelte'
  import { device } from 'utils/device'
  import { performanceFilterStore } from './filters'
  import FiltersMobile from './FiltersMobile.svelte'
  import FiltersDesktop from './FiltersDesktop.svelte'

  $: setDetault = localStorage.getItem('performanceFilters') !== null

  $: if (setDetault) {
    performanceFilterStore.setDefaultFilters()
  } else {
    performanceFilterStore.resetDefaultFilters()
  }

  performanceFilterStore.subscribe(() => {
    setDetault = false
  })

  const setDefaultFilters = event => {
    setDetault = event.target.checked
  }
</script>

<div>
  <div class="flex flex-wrap items-center mb-3">
    {#if $device === 'mobile' || $device === 'tablet'}
      <FiltersMobile />
    {:else}
      <FiltersDesktop />
    {/if}
  </div>
  <div class="flex mb-2">
    <Toggle color="green" checked={setDetault} on:change={setDefaultFilters} data-cy="toggleDefaultFilters" />
    <span class="font-normal text-font" data-cy="labelDefaultFilters">Set current filters as default</span>
  </div>
</div>
