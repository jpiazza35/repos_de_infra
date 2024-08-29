<script>
  import { createEventDispatcher } from "svelte";
  export let value = false;
  export let disabled = false;
  export let datacy;

  const dispatch = createEventDispatcher();

  const hancleClick = event => {
    dispatch("onClick", event);
  };
</script>

<input class="form-check-input" type="checkbox" on:click={hancleClick} bind:checked={value} {disabled} data-cy={datacy} />
