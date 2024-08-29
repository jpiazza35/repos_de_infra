<script>
  import { createEventDispatcher } from "svelte";

  export let disabled;
  export let value;
  export let showDelete = true;
  export let showDragAndDrop = true;
  const dispatch = createEventDispatcher();

  const handleDelete = () => {
    if (!disabled) dispatch("onDelete", value);
  };

  const handleMoveTop = () => {
    if (!disabled) dispatch("onMoveTop", value);
  };

  const handleMoveBottom = () => {
    if (!disabled) dispatch("onMoveBottom", value);
  };

  const handleMoveUp = () => {
    if (!disabled) dispatch("onMoveUp", value);
  };

  const handleMoveDown = () => {
    if (!disabled) dispatch("onMoveDown", value);
  };
</script>

<div class="d-flex">
  {#if showDelete}
    <i class={`fa fa-trash ${disabled ? "isDisabled" : ""}`} aria-hidden="true" on:click={handleDelete} data-cy="deleteActionIcon" />
  {/if}
  {#if showDragAndDrop}
    <i class={`fa fa-bars ${disabled ? "isDisabled" : ""}`} aria-hidden="true" />
  {/if}
  <i class={`fa fa-angle-double-up ${disabled ? "isDisabled" : ""}`} aria-hidden="true" on:click={handleMoveTop} data-cy="faAngleDoubleUp" />
  <i class={`fa fa-angle-up ${disabled ? "isDisabled" : ""}`} aria-hidden="true" on:click={handleMoveUp} data-cy="faAngleUp">
    <i class={`fa fa-angle-down ${disabled ? "isDisabled" : ""}`} aria-hidden="true" on:click={handleMoveDown} data-cy="faAngleDown" />
    <i class={`fa fa-angle-double-down ${disabled ? "isDisabled" : ""}`} aria-hidden="true" on:click={handleMoveBottom} data-cy="faAngleDoubleDown" />
  </i>
</div>

<style>
  .fa-trash {
    cursor: pointer;
    margin-right: 20px;
  }
  .fa-bars {
    cursor: move;
    margin: 0px 20px 0px 0px;
  }
  .fa-angle-double-up,
  .fa-angle-up,
  .fa-angle-down,
  .fa-angle-double-down {
    cursor: pointer;
    margin: 0px 3px;
  }
  .isDisabled {
    opacity: 0.7;
    cursor: auto;
  }
</style>
