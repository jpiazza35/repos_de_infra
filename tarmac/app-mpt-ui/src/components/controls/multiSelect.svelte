<script>
  import { onMount } from "svelte";
  export let title = "",
    key,
    id,
    onChange,
    values = [],
    defaultValues = [],
    disabled = false;
  let multiSelect;
  let isInitialized = false;

  const handleOnChange = () => {
    const selectedItems = jQuery(multiSelect).data("kendoMultiSelect").dataItems();
    onChange(key, selectedItems);
  };

  const initializeMultiSelect = () => {
    jQuery(multiSelect).kendoMultiSelect({
      dataTextField: "text",
      dataValueField: "value",
      dataSource: values,
      filter: "contains",
      change: handleOnChange,
      value: defaultValues,
    });
    isInitialized = true;
  };

  onMount(!isInitialized && initializeMultiSelect);
</script>

<select class="form-control" {id} multiple data-cy={`multiSelect-${key}`} placeholder={`Select ${title}`} bind:this={multiSelect} {disabled} />
