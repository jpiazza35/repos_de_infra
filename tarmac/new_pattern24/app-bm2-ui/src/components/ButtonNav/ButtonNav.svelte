<script>
  import { onMount } from 'svelte'
  import { navigate } from 'svelte-routing'
  import Fa from 'svelte-fa'
  import { ButtonGroup, Button } from 'flowbite-svelte'
  import { faBusinessTime, faChartLine } from '@fortawesome/pro-solid-svg-icons'
  import { ROUTES, currentRoute } from 'utils/routes'

  let currentPath = ''

  onMount(() => {
    currentPath = Object.values(ROUTES).find(route => route === window.location.pathname) ?? ROUTES.Tab1
    currentRoute.set(currentPath)
  })

  /**
   * Navigate to the selected page
   * @param {string} route
   */
  const onSelectPage = route => {
    navigate(route)
    currentPath = route
    currentRoute.set(route)
  }

  const defaultButtonStyle = 'text-green-100 bg-white border-green-100 font-normal px-3 text-base hover:text-green-100 mobile:w-1/2 tablet:w-auto'
  const activeButtonStyle =
    'text-white bg-green-100 border-green-100 font-normal px-3 text-base hover:text-white hover:bg-green-100 mobile:w-1/2 tablet:w-auto'
</script>

<ButtonGroup class="h-10 mobile:w-full tablet:w-auto">
  <Button
    color="light"
    on:click={() => onSelectPage(ROUTES.Tab1)}
    class={currentPath === ROUTES.Tab1 ? activeButtonStyle : defaultButtonStyle}
    data-cy="buttonNavProductivity"
  >
    <Fa icon={faBusinessTime} class={currentPath === ROUTES.Tab1 ? 'text-white mr-1' : 'text-green-100 mr-1'} />
    Tab 1
  </Button>
  <Button
    color="light"
    on:click={() => onSelectPage(ROUTES.Tab2)}
    class={currentPath === ROUTES.Tab2 ? activeButtonStyle : defaultButtonStyle}
    data-cy="buttonNavPerformance"
  >
    <Fa icon={faChartLine} class={currentPath === ROUTES.PERFORMANCE ? 'text-white mr-1' : 'text-green-100 mr-1'} />
    Tab 2
  </Button>
</ButtonGroup>
