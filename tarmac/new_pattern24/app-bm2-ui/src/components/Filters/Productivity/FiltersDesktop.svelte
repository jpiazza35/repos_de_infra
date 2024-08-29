<script>
  import { Button } from 'flowbite-svelte'
  import Fa from 'svelte-fa'
  import { faArrowRotateLeft } from '@fortawesome/pro-solid-svg-icons'
  import { productivityFilterStore } from './filters'
  import Specialty from './Specialty.svelte'
  import PeriodType from './PeriodType.svelte'
  import Period from './Period.svelte'
  import ServiceGroup from './ServiceGroup.svelte'

  const resetFilters = () => {
    productivityFilterStore.reset()
  }
</script>

<Button
  on:click={resetFilters}
  color="light"
  class="text-black text-base border-warning font-normal rounded h-10 mr-2 px-2.5 my-1"
  data-cy="resetFiltersButton"
>
  <Fa icon={faArrowRotateLeft} class={'text-base mr-2'} />
  Reset Filters
</Button>
<Specialty />
<PeriodType />
<Period />
<ServiceGroup />
