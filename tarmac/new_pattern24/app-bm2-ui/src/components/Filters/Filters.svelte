<script>
  import { currentRoute, ROUTES } from 'utils/routes'
  import PerformanceFilters from './Performance/PerformanceFilters.svelte'
  import ProductivityFilters from './Productivity/ProductivityFilters.svelte'
</script>

{#if $currentRoute === ROUTES.PERFORMANCE}
  <PerformanceFilters />
{:else}
  <ProductivityFilters />
{/if}
