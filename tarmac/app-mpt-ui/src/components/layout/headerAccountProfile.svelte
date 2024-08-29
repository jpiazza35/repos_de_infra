<script>
  import { onMount } from "svelte";
  import { AuthLogout } from "../../auth/authHelper";
  import { userStore } from "../../store/user";

  let user;
  onMount(() => {
    userStore.subscribe(value => {
      user = value;
    });
  });

  function handleLogOut() {
    setTimeout(() => {
      console.log("Loging out...");
      AuthLogout();
    }, 1);

    return false;
  }
</script>

<div class="dropdown dropdown-user">
  <a role="button" class="dropdown-toggle" data-cy="dropdownUser" id="dropdownUser" data-bs-toggle="dropdown" aria-expanded="false">
    {user?.name || ""}
  </a>
  <ul class="dropdown-menu" aria-labelledby="dropdownUser">
    <li>
      <button class="dropdown-item link" data-cy="dropdownLogout" type="button" on:click={handleLogOut}>
        <i class="bi bi-power" /> Logout
      </button>
    </li>
  </ul>
</div>

<style>
  .dropdown-toggle::after {
    display: inline-block;
    margin-left: 0.255em;
    vertical-align: 0.255em;
    content: "";
    border-top: 0.3em solid;
    border-right: 0.3em solid transparent;
    border-bottom: 0;
    border-left: 0.3em solid transparent;
  }
  #dropdownUser {
    text-decoration: none !important;
    color: #333;
    margin-right: 20px;
  }
  .link {
    cursor: pointer;
  }
</style>
