<script>
  // @ts-nocheck

  import { filterStore } from "../../pages/Projects/Tabs/MarketSegmentTab/Sections/marketSegmentStore";

  // @ts-nocheck
  import { onMount } from "svelte";
  import { getTokenToApi } from "../../auth/authHelper";

  export let title,
    key,
    defaultValue,
    disabled = false;

  let token,
    multipleSelect = null,
    multiSelectConfig = {},
    cutGroupKeys = [],
    jsonData = [],
    store = filterStore,
    selectedValues = [];

  const inputPlaceholder = `Select ${title}`,
    dataTextField = "name",
    dataValueField = "keys";

  const handleSelect = e => {
    if (e && e.dataItem) {
      selectedValues.push(e.dataItem);
      jQuery(multipleSelect).data("kendoMultiSelect").input.val("");
      store.update(store => ({
        ...store,
        [`${key}Filter`]: selectedValues,
        [`${key}Keys`]: (key !== "year" && selectedValues?.flatMap(filter => filter?.keys.filter(c => !isNaN(c)))) || [],
      }));
    }
  };

  const handleDeselect = e => {
    if (e && e.dataItem) {
      // filtering the selected values by name, since they can have many keys
      let items = selectedValues.filter(v => v.name === e.dataItem.name);
      if (items && items.length > 0) {
        for (var i = 0; i < items.length; i++) {
          selectedValues.splice(selectedValues.indexOf(items[i]), 1);
        }
        jQuery(multipleSelect).data("kendoMultiSelect").input.val("");
        store.update(store => ({
          ...store,
          [`${key}Filter`]: selectedValues,
          [`${key}Keys`]: (key !== "year" && selectedValues?.flatMap(filter => filter?.keys.filter(c => !isNaN(c)))) || [],
        }));
      }
    }
  };

  let dataSource = new kendo.data.DataSource({
    transport: {
      read: {
        url: "api/survey/market-segment-filters",
        type: "POST",
        beforeSend: function (req) {
          req.setRequestHeader("Authorization", `Bearer ${token}`);
        },
        processData: false,
        dataType: "json",
        data: jsonData,
        contentType: "application/json",
      },
      parameterMap: function (options, operation) {
        if (operation === "read") {
          if (options && options != null) {
            options.publisher = key === "publisher";
            options.survey = key === "survey";
            options.industry = key === "industrySector";
            options.organization = key === "organizationType";
            options.cutGroup = key === "cutGroup";
            options.cutGroupKeys = cutGroupKeys.length > 0 ? cutGroupKeys : [];
            options.cutSubGroup = key === "cutSubGroup";
            jsonData = kendo.stringify(options);
            return jsonData;
          }
        }
      },
    },
    filter: {
      logic: "and",
      filters: [
        {
          field: dataValueField,
          operator: "neq",
          value: null,
        },
      ],
    },
    sort: [
      {
        field: dataTextField,
        dir: "asc",
      },
    ],
    pageSize: 100,
  });

  store.subscribe(store => {
    cutGroupKeys = store?.cutGroupKeys || [];
    // cutSubGroupFilters = store?.cutSubGroupFilter?.map(filter => filter?.keys.filter(c => !isNaN(c))).flat() || [];
  });

  onMount(async () => {
    token = await getTokenToApi();
    multiSelectConfig = {
      key: key,
      height: 280,
      title,
      autoClose: false,
      dataTextField,
      itemTemplate: data => {
        return data ? data[dataTextField] : "";
      },
      tagTemplate: data => {
        return data ? data[dataTextField] : "";
      },
      autoBind: false,
      select: handleSelect,
      deselect: handleDeselect,
      open: () =>
        key === "cutSubGroup"
          ? jQuery(multipleSelect).data("kendoMultiSelect").dataSource.read()
          : jQuery(multipleSelect).data("kendoMultiSelect").dataSource.refresh,
    };

    if (multipleSelect != null && token) {
      if (defaultValue && defaultValue.length > 0) {
        if (key !== "year") {
          let newDataSource = { ...dataSource, data: defaultValue };
          jQuery(multipleSelect).kendoMultiSelect({
            ...multiSelectConfig,
            dataSource: newDataSource,
            value: defaultValue.map(v => v?.name),
            itemTemplate: data => {
              return data && typeof data === "string" ? data : data[dataTextField];
            },
            tagTemplate: data => {
              return data && typeof data === "string" ? data : data[dataTextField];
            },
          });

          selectedValues = defaultValue;
        } else {
          let newDataSource = { data: defaultValue };
          jQuery(multipleSelect).kendoMultiSelect({
            ...multiSelectConfig,
            dataSource: newDataSource,
          });
        }
      } else {
        jQuery(multipleSelect).kendoMultiSelect({
          ...multiSelectConfig,
          dataSource: dataSource,
        });
      }
    }
  });
</script>

<div class="row pt-2 pb-2 form-group w-50" data-cy={`${key}-filterMultipleSelect`}>
  <div class="align-items-center d-flex">
    <label for="label-autocomplete" class="form-label" data-cy={`multiselect-label-${key}`}>{title}</label>
  </div>
  <select
    {key}
    class={`form-control multiple-autocomplete ${key}-autocomplete`}
    data-cy={`${key}-multiselect-autocomplete`}
    multiple={true}
    id="multiselect-autocomplete"
    data-placeholder={inputPlaceholder}
    placeholder={inputPlaceholder}
    bind:this={multipleSelect}
    {disabled}
  />
</div>
