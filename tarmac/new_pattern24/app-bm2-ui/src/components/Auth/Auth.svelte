<script>
  import { onMount } from 'svelte'
  import auth from 'auth/authService'
  import { isAuthenticated, user, token } from 'store/auth'
  import Loader from '../Loader/Loader.svelte'

  let auth0Client

  onMount(async () => {
    auth0Client = await auth.createClient()
    const authenticated = await auth0Client.isAuthenticated()

    if (authenticated) {
      user.set(await auth0Client.getUser())
      token.set(await auth0Client.getTokenSilently())
      isAuthenticated.set(true)
    } else {
      if (window.location.pathname == '/callback') {
        await auth0Client.handleRedirectCallback().then(() => {
          window.location.href = '/'
        })
      } else {
        auth0Client.loginWithRedirect()
      }
    }
  })
</script>

{#if $isAuthenticated}
  <slot />
{:else}
  <Loader fullScreen={true} />
{/if}
