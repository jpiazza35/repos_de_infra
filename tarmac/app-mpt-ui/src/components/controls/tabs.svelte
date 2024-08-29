<script>
  import FullScreen from "components/shared/fullScreen.svelte";
  import UnsavedWarning from "components/shared/unsavedWarning.svelte";
  import { tabFullScreen } from "store/tabs";

  export let items = [];
  export let activeTabValue = 1;
  export let inputOrgId;
  export let inputProjectId;
  export let inputProjectVersionId;

  const handleClick = tabValue => () => (activeTabValue = tabValue);
</script>

<div data-cy="tabs">
  <ul>
    {#each items as item}
      <li data-cy={item.datacy} class={activeTabValue === item.value ? "active" : ""}>
        <a href={"#"}><UnsavedWarning onClick={handleClick(item.value)}>{item.label}</UnsavedWarning></a>
      </li>
    {/each}
  </ul>
  {#each items as item}
    {#if activeTabValue == item.value}
      <div class={$tabFullScreen ? "box fullscreenlayer" : "box"} id={item.datacy + "Tab"}>
        <svelte:component
          this={item.component}
          bind:inputFilterProjectId={inputProjectId}
          bind:inputFilterProjectVersionId={inputProjectVersionId}
          bind:inputFilterOrgId={inputOrgId}
          on:reloadFilters
        />
      </div>
    {/if}
  {/each}
  {#if $tabFullScreen}
    <FullScreen />
  {/if}
</div>

<style>
  .box {
    margin-bottom: 10px;
    padding: 15px;
    border: 1px solid #dee2e6;
    border-radius: 0 0 0.5rem 0.5rem;
    border-top: 0;
    background-color: #fff;
    min-height: 400px;
  }
  ul {
    display: flex;
    flex-wrap: wrap;
    padding-left: 0;
    margin-bottom: 0;
    list-style: none;
    border-bottom: 1px solid #dee2e6;
  }
  li {
    margin-bottom: -1px;
  }

  a {
    border: 1px solid transparent;
    border-top-left-radius: 0.25rem;
    border-top-right-radius: 0.25rem;
    display: block;
    padding: 0.5rem 1rem;
    color: inherit;
    cursor: pointer;
    text-decoration: none;
  }

  a:hover {
    border-color: #e9ecef #e9ecef #dee2e6;
  }

  li.active > a {
    color: #495057;
    background-color: #fff;
    border-color: #dee2e6 #dee2e6 #fff;
  }
</style>
