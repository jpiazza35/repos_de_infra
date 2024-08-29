<script>
  import { QueryClient, QueryClientProvider } from "@sveltestack/svelte-query";
  import jquery from "jquery";
  import CryptoJS from "crypto-js";
  import Header from "components/layout/header.svelte";
  import Sidebar from "components/layout/sidebar.svelte";
  import PageContainer from "components/layout/pageContainer.svelte";
  import Footer from "components/layout/footer.svelte";
  import { signIn, getUserName } from "./auth/authRedirect";
  import { getUserRoles } from "./api/apiCalls";
  import { promiseWrap } from "utils/functions";
  import AccessDenied from "components/layout/accessDenied.svelte";
  import { isOktaConfig } from "./auth/authHelper";
  import { setupUser, isAuthenticated, getAuth0UserName, getAuth0User } from "./auth/auth0";
  import { onMount } from "svelte";
  import Loading from "components/shared/loading.svelte";
  import { userStore } from "./store/user";
  import * as LaunchDarkly from "launchdarkly-js-client-sdk";
  import { featureFlagStore, featureFlags } from "store/launchdarkly";

  const queryClient = new QueryClient();
  const oktaConfig = isOktaConfig();
  let loading = true;
  let roles = [];
  let user;
  let userName = "";

  //OKTA section
  const setupRoles = async () => {
    if (oktaConfig) {
      let [userRoles, standardsDataError] = await promiseWrap(getUserRoles());

      if (standardsDataError && standardsDataError.response?.status != 200) {
        roles = [];
      } else if (userRoles) {
        roles = userRoles;
        // Encrypt
        const encrypted = CryptoJS.AES.encrypt(JSON.stringify(roles), "MPT").toString();
        localStorage.setItem("userRoles", encrypted);
      }
    }
  };

  const paramsLD = import.meta.env.VITE_LAUNCH_DARKLY;

  const client = LaunchDarkly.initialize(paramsLD, {
    kind: "user",
    key: "mpt-user-ui",
  });

  client.on("ready", () => {
    featureFlags.forEach(flag => {
      setFlag(client.variation(flag, false), flag);
      client.on(`change:${flag}`, val => setFlag(val, flag));
    });
  });

  function setFlag(val, flag) {
    featureFlagStore.update(store => {
      store[flag] = val;
      return store;
    });
  }

  onMount(async () => {
    if (oktaConfig) {
      const isAuth = await isAuthenticated();
      if (!isAuth) {
        await setupUser();
        await setupRoles();
      } else {
        const encrypted = localStorage.getItem("userRoles");
        if (encrypted) {
          // Decrypt
          const bytes = CryptoJS.AES.decrypt(encrypted, "MPT");
          roles = JSON.parse(bytes.toString(CryptoJS.enc.Utf8));
        } else {
          setupRoles();
        }
      }
      userName = await getAuth0UserName();
      user = await getAuth0User();

      userStore.set(user);
    }
  });
  //End of OKTA section

  //B2C section
  if (!oktaConfig) userName = getUserName();

  jquery(document).ready(async function () {
    if (!oktaConfig) {
      if (!userName) {
        signIn();

        setTimeout(() => {
          userName = getUserName();
        }, 1000);
      }

      const [userRoles] = await promiseWrap(getUserRoles());
      if (userRoles) {
        roles = userRoles;
        // Encrypt
        const encrypted = CryptoJS.AES.encrypt(JSON.stringify(roles), "MPT").toString();

        localStorage.setItem("userRoles", encrypted);
        loading = false;
      }
    }
  });
  //End of B2C section
</script>

{#if oktaConfig}
  {#if userName && roles.length === 0}
    <AccessDenied />
  {:else if userName && roles.length > 0}
    <div class="page-wrapper">
      <Header />
      <div class="d-flex" id="wrapper">
        <Sidebar />
        <QueryClientProvider client={queryClient}>
          <PageContainer />
        </QueryClientProvider>
      </div>
      <Footer />
    </div>
  {:else}
    <div class="centered">
      <Loading isLoading={true} />
    </div>
  {/if}
{/if}

{#if !oktaConfig}
  {#if !loading && roles.length === 0}
    <AccessDenied />
  {:else if !loading && roles.length > 0}
    <div class="page-wrapper">
      <Header />
      <div class="d-flex" id="wrapper">
        <Sidebar />
        <QueryClientProvider client={queryClient}>
          <PageContainer />
        </QueryClientProvider>
      </div>
      <Footer />
    </div>
  {:else}
    <p>Redirecting...</p>

    <p>If you are not redirected in five seconds, <a href="/">click here</a>.</p>
  {/if}
{/if}

<style type="text/css">
  .centered {
    position: fixed;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    transform: -webkit-translate(-50%, -50%);
    transform: -moz-translate(-50%, -50%);
    transform: -ms-translate(-50%, -50%);
    color: darkred;
  }
</style>
