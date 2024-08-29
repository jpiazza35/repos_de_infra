<script>
  export let title,
    inputType = "text",
    inputFilter = `Search ${title}`,
    ids = [],
    selectedIds = [],
    options = [],
    selectedOptions = [{ optId: "14730", optLabel: `AAA Washington - 14730` }];
  /** TODO: Idealy this component should be typed to receive the selected options object based on some interface or even all props. */
  $: handleAssign = () => {
    let valuesToStay = options.filter(o => !ids.includes(o.optId));
    let valuesToSelect = options.filter(o => ids.includes(o.optId));
    selectedOptions = selectedOptions.concat(valuesToSelect);
    options = valuesToStay;
  };

  $: handleUnassign = () => {
    let valuesToStay = selectedOptions.filter(
      o => !selectedIds.includes(o.optId),
    );
    let valuesToUnselect = selectedOptions.filter(o =>
      selectedIds.includes(o.optId),
    );
    selectedOptions = valuesToStay;
    options = options.concat(valuesToUnselect);
  };
</script>

<div class="row pt-2 pb-2 form-group" data-cy={"multipleSelect"}>
  <div class="col-md-6">
    <div class="row mb-2 ">
      <div class="col-md-6 align-items-center d-flex">
        <!-- svelte-ignore a11y-label-has-associated-control -->
        <label class="form-label">{title}</label>
      </div>
      <div class="col-md-6">
        <input
          class="form-control"
          type={inputType}
          id="multipleSelectSearchinput"
          placeholder={inputFilter}
        />
      </div>
    </div>
    <select class="form-control" multiple bind:value={ids} size="3">
      {#each options as option}
        <option value={option.optId}>
          {option.optLabel}
        </option>
      {/each}
    </select>
  </div>
  <div class="col-md-2 d-flex justify-content-center align-items-center">
    <div class="btn-group-vertical">
      <button
        type="button"
        class="btn btn-primary mt-4"
        name="Add"
        on:click={handleAssign}
        id="btnAddOrg">Assign &#62;</button
      >
      <button
        type="button"
        class="btn btn-primary mt-2"
        name="Remove"
        on:click={handleUnassign}
        id="btnAddOrg"
      >
        &#60; Remove
      </button>
    </div>
  </div>
  <div class="col-md-4">
    <br />
    <!-- svelte-ignore a11y-label-has-associated-control -->
    <label>Selected {title}</label>

    <select
      class="form-control mb-2"
      multiple
      bind:value={selectedIds}
      size="3"
    >
      {#each selectedOptions as option}
        <option value={option.optId}>
          {option.optLabel}
        </option>
      {/each}
    </select>
  </div>
</div>
