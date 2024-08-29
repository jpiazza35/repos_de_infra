<script>
  import { onMount } from "svelte";
  import HeaderAccountProfile from "./headerAccountProfile.svelte";

  let sidebarToggled = false;

  onMount(() => {
    document.body.classList.add("sb-sidenav-toggled");
  });

  function handleToggleClick() {
    document.body.classList.toggle("sb-sidenav-toggled");
    sidebarToggled = document.body.classList.contains("sb-sidenav-toggled");
    localStorage.setItem("sb|sidebar-toggle", JSON.stringify(sidebarToggled));
    dispatchEvent(new Event("SidebarToggled"));
  }

  function handleToggleKeydown(event) {
    if (event.key === "Enter" || event.key === " ") {
      event.preventDefault();
      handleToggleClick();
    }
  }
</script>

<nav class="navbar navbar-expand-lg border-bottom" id="page-content-wrapper">
  <div class="container-fluid">
    <div class="collapse navbar-collapse">
      <div id="sidebarToggle" class="toggle-icon" on:click={handleToggleClick} on:keydown={handleToggleKeydown}>
        <i class="bi bi-list" style="font-size: 20px; padding: 7px" />
      </div>
      <!-- svelte-ignore a11y-invalid-attribute -->
      <a href="#" class="mx-auto">
        <img alt="sc logo" src="./assets/img/logo-sca-l-no-padding.png" />
      </a>
      <ul class="nav navbar-toolbar">
        <HeaderAccountProfile />
      </ul>
    </div>
  </div>
</nav>

<style>
  .toggle-icon {
    cursor: pointer;
  }
</style>
