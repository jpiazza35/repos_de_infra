<script>
  import { onMount } from 'svelte'
  import { navigate, Router, Route } from 'svelte-routing'
  import Header from 'components/Header/Header.svelte'
  import Tab2 from 'pages/tab2/tab2.svelte'
  import Tab1 from 'pages/tab1/tab1.svelte'
  import { ROUTES } from 'utils/routes'

  onMount(() => {
    if (Object.values(ROUTES).find(route => route === window.location.pathname) === undefined) {
      navigate(ROUTES.Tab1)
    }
  })
</script>

<Router>
  <Header />
  <Route path={ROUTES.Tab1} component={Tab1} />
  <Route path={ROUTES.Tab2} component={Tab2} />
</Router>
