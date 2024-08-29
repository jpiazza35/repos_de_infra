<script>
  import jquery from "jquery";

  // data you want in the grid
  const data = [
    { Title: "Star Wars: A New Hope", Year: 1977 },
    { Title: "Star Wars: The Empire Strikes Back", Year: 1980 },
    { Title: "Star Wars: Return of the Jedi", Year: 1983 },
  ];

  let container = null;

  $: if (container != null && data != null) {
    let crudServiceBaseUrl = "https://demos.telerik.com/kendo-ui/service";

    let dataSource = new kendo.data.DataSource({
      transport: {
        read: {
          url: crudServiceBaseUrl + "/Products",
          dataType: "jsonp",
        },
        update: {
          url: crudServiceBaseUrl + "/Products/Update",
          dataType: "jsonp",
        },
        destroy: {
          url: crudServiceBaseUrl + "/Products/Destroy",
          dataType: "jsonp",
        },
        create: {
          url: crudServiceBaseUrl + "/Products/Create",
          dataType: "jsonp",
        },
        parameterMap: function (options, operation) {
          if (operation !== "read" && options.models) {
            return { models: kendo.stringify(options.models) };
          }
        },
      },
      batch: true,
      pageSize: 10,
      schema: {
        model: {
          id: "ProductID",
          fields: {
            ProductID: { editable: false, nullable: true },
            ProductName: { validation: { required: true } },
            UnitPrice: {
              type: "number",
              validation: { required: true, min: 1 },
            },
            Discontinued: { type: "boolean" },
            UnitsInStock: {
              type: "number",
              validation: { min: 0, required: true },
            },
          },
        },
      },
    });

    // when container and data are set / change, create a new kendoGrid
    // we could optimize this to only instantiate once and use methods inside kendoGrid to update its data
    jQuery(container).kendoGrid({
      dataSource: dataSource,
      navigatable: true,
      height: 800,
      filterable: false,
      sortable: true,
      resizable: true,
      pageable: {
        alwaysVisible: false,
        pageSizes: [5, 10, 20, 100],
      },
      toolbar: ["create", "save", "cancel"],
      columns: [
        "ProductName",
        {
          field: "UnitPrice",
          title: "Unit Price",
          format: "{0:c}",
          width: 120,
        },
        { field: "UnitsInStock", title: "Units In Stock", width: 120 },
        { field: "Discontinued", width: 120 },
        { command: "destroy", title: "&nbsp;", width: 150 },
      ],
      editable: true,
    });

    jquery(".k-grid-header").css({ background: "#333", color: "#fff" });
    jquery(".k-grid-header thead th").css({ "border-color": "#fff" });
    jquery(".k-grid-header span.k-icon").css({ color: "#fff" });
  }
</script>

<div bind:this={container} />
