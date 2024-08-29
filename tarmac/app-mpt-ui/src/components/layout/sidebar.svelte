<script>
  import UnsavedWarning from "components/shared/unsavedWarning.svelte";

  import { links } from "svelte-routing";

  function setProjectListSelected() {
    const projectsLink = jQuery('a[href="/projects"]');
    projectsLink?.addClass("active");
  }

  jQuery(document).ready(function () {
    const listItems = jQuery(".list-group-item");

    listItems.on("click", function () {
      listItems.removeClass("active");
      jQuery(this).addClass("active");
    });

    setProjectListSelected();
  });

  const clientPortalLink = import.meta.env.VITE_CLIENT_PORTAL_LINK || "/";
</script>

<div class="border-end bg-white" id="sidebar-wrapper" use:links>
  <div class="list-group list-group-flush">
    <!-- <a class="list-group-item p-3" href="/">Market Pricing</a> -->
    <div class="p-4 d-flex align-items-center">
      <div class="app-logo">MP</div>
      <div class="app-title">Market Pricing</div>
    </div>
    <div class="divider" />
    <a class="list-group-item list-group-item-action list-group-item-light p-4" href={`${clientPortalLink}`}>
      <UnsavedWarning><i class="bi bi-display-fill" />Client Portal</UnsavedWarning></a
    >
    <a class="list-group-item list-group-item-action list-group-item-light p-4" href="/projects" data-cy="project-sidebar"
      ><i class="bi bi-folder" />Project List</a
    >
  </div>
</div>

<style>
  .app-logo {
    font-size: 18px;
    font-weight: 700;
    padding: 10px;
    background: #0076be;
    border-radius: 8px;
    color: #fff;
    margin-right: 15px;
  }

  .app-title {
    font-size: 16px;
    line-height: 1.2;
  }

  .divider {
    border: 1px solid #d6d6d7;
    margin-left: 1.5rem;
    margin-right: 1.5rem;
    margin-bottom: 1.5rem;
  }

  .list-group-item {
    border: none;
  }

  #sidebar-wrapper .list-group-item i {
    margin-right: 12px;
  }
</style>
