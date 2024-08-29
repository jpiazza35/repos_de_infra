<script>
  export let id = "",
    name = "",
    label = "",
    value = "",
    prepend = "",
    append = "",
    error = "",
    colSize = "12",
    type = "text",
    valid = false,
    required = false,
    showFeedback = false,
    maxlength = "";

  function typeAction(node) {
    node.type = type;
  }
</script>

<div class="col-md-{colSize}">
  {#if label !== ""}
    <label for={id} class="form-label" class:required data-cy="{id}-label">{label}</label>
  {/if}
  <div class:input-group={prepend !== "" || append !== ""}>
    {#if prepend}
      <span class="input-group-text">{prepend}</span>
    {/if}
    <input
      use:typeAction
      class="form-control"
      class:is-valid={valid}
      class:is-invalid={error !== ""}
      {id}
      {name}
      {required}
      {maxlength}
      data-cy="{id}-input"
      on:change
      on:blur
      on:keyup
      on:keypress
      bind:value
      {...$$restProps}
      title={value}
    />
    {#if append}
      <span class="input-group-text">{append}</span>
    {/if}

    {#if valid}
      <div class="valid-feedback">Looks good!</div>
    {/if}
    {#if error != "" && showFeedback}
      <div class="invalid-feedback">{error}</div>
    {/if}
  </div>
</div>
