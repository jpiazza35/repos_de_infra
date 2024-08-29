<script>
  import { Popover } from "sveltestrap";

  export let id;
  export let text;
</script>

<div {id} class="popover-text">{text}</div>
<Popover placement="top" target={id} trigger="hover" {...$$restProps}>
  {text}
</Popover>

<style>
  .popover-text {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
  }
</style>
