<script>
  import { onMount } from "svelte";
  import { Button, Popover } from "sveltestrap";
  import { columnsStore } from "./JobMatchingGridConfig.js";

  let isOpen = false;
  let popoverEl;
  /**
   * Array of columns to be displayed in the grid
   * @param {string} title
   * @param {string} field
   * @param {boolean} show
   */
  let initColumns = [];
  let columns = [];

  columnsStore.subscribe(value => {
    columns = structuredClone(value);
  });

  onMount(() => {
    columns = structuredClone($columnsStore);
  });

  const onOpen = () => {
    if (!isOpen) initColumns = structuredClone($columnsStore);
  };

  const onCancel = () => {
    columns = structuredClone(initColumns);
    isOpen = false;
  };

  const onApply = () => {
    isOpen = false;
    columnsStore.set(columns);
  };

  const handleClick = event => {
    if (isOpen && !popoverEl.contains(event.target)) isOpen = false;
    event.stopPropagation();
  };
</script>

<svelte:window on:mousedown={handleClick} />
<div class="mx-2">
  <button class="btn" id="popoverColumns" on:click={onOpen}><i class="fa fa-cog" /></button>
  <Popover bind:isOpen class="test" placement="left" target="popoverColumns">
    <div bind:this={popoverEl}>
      <ul>
        {#each columns.filter(col => col.visible !== false) as column}
          <li><label><input type="checkbox" bind:checked={column.show} /> {column.title}</label></li>
        {/each}
      </ul>
      <div class="footer">
        <Button class="mx-2" outline color="secondary" on:click={onCancel}>Cancel</Button>
        <Button color="primary" on:click={onApply}>Apply</Button>
      </div>
    </div>
  </Popover>
</div>

<style>
  #popoverColumns {
    background-color: transparent;
    border: none;
    color: #0076be;
    font-size: 20px;
  }
  .footer {
    text-align: right;
  }
  ul {
    padding: 0;
  }
  ul li {
    display: flex;
    align-items: center;
    list-style-type: none;
    background-color: #f8f9fa;
    border-radius: 4px;
    height: 36px;
    margin: 2px 0px;
    padding: 0px 10px;
  }
  li:hover {
    background-color: #e9ecef;
  }
  li label {
    display: flex;
    align-items: center;
  }
  label input {
    margin-right: 10px;
  }
</style>
