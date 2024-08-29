<script>
  import { createQuery } from '@tanstack/svelte-query'
  // import { Button } from 'flowbite-svelte'
  // import auth from 'auth/authService'
  import { getDashboardHeader } from 'api/apiCalls'
  import ButtonNav from 'components/ButtonNav/ButtonNav.svelte'
  import ButtonExport from 'components/ButtonExport/ButtonExport.svelte'
  import Filters from 'components/Filters/Filters.svelte'
  import Loader from 'components/Loader/Loader.svelte'
  import { ROUTES, currentRoute } from 'utils/routes'

  let headerData = {}

  const queryDashboardHeader = createQuery({
    queryKey: ['compensation-summary'],
    queryFn: () => getDashboardHeader(),
  })

  $: if ($queryDashboardHeader.data) {
    headerData = $queryDashboardHeader.data
  }

  $: page = $currentRoute === ROUTES.Tab1 ? 'tab1' : 'tab2'
</script>

{#if $queryDashboardHeader.isLoading}
  <Loader fullScreen={true} />
{:else}
  <div class="bg-white sticky top-0 tablet:px-6 tablet:py-4 mobile:px-4 mobile:py-2" style="z-index: 100;" data-cy="header">
    <div class="flex items-center justify-between flex-wrap mb-4 w-full">
      <h1 class="font-light text-font laptop:text-4xl mobile:text-3xl" data-cy="headerTitle">{headerData[page].name}</h1>
      <div class="text-right tablet:block mobile:hidden">
        <h4 class="font-light text-custom-green-600 text-2xl" data-cy="headerDate">
          {headerData[page].header}
        </h4>
        <h4 class="font-light text-font laptop:text-xl mobile:text-base" data-cy="headerDate">
          {headerData[page].subHeader}
        </h4>
      </div>
    </div>
    <div class="flex items-center flex-wrap mb-3 w-full tablet:justify-between mobile:justify-center">
      <ButtonNav />
      <!-- <Button on:click={auth.logout} data-cy="headerLogout">Logout</Button> -->
    </div>
    <div class="flex items-start justify-between w-full">
      <!--<Filters />
      <ButtonExport /> -->
    </div>
  </div>
{/if}
