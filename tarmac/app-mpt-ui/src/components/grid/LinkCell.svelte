<script>
  import { createEventDispatcher } from "svelte";
  export let value;
  export let disabled = false;
  export let dataCy = "";
  export let className = "";

  const dispatch = createEventDispatcher();

  const hancleClick = () => {
    if (!disabled) dispatch("onClick", value);
  };
</script>

<p><a class={disabled ? `isDisabled ${className}` : `${className}`} href={"#"} on:click={hancleClick} data-cy={dataCy}>{value.name}</a></p>

<style>
  a {
    color: #0076be;
    text-decoration: underline;
  }
  .isDisabled {
    color: #6c757d;
    cursor: auto;
    text-decoration: none;
  }
</style>
