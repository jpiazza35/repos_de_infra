<script>
  import { Toggle } from 'flowbite-svelte'
  import { device } from 'utils/device'
  import { productivityFilterStore } from './filters'
  import FiltersDesktop from './FiltersDesktop.svelte'
  import FiltersMobile from './FiltersMobile.svelte'

  $: setDetault = localStorage.getItem('productivityFilters') !== null

  $: if (setDetault) {
    productivityFilterStore.setDefaultFilters()
  } else {
    productivityFilterStore.resetDefaultFilters()
  }

  productivityFilterStore.subscribe(() => {
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
