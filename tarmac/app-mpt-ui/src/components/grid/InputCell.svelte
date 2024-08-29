<script>
  import { createEventDispatcher } from "svelte";
  export let value;
  export let id;
  export let name;
  export let datacy;
  export let disabled;

  const dispatch = createEventDispatcher();

  const handleChange = event => {
    dispatch("onChange", event);
  };
</script>

<input class="form-control" type="text" on:change={handleChange} {id} {name} {value} {disabled} data-cy={datacy} />
