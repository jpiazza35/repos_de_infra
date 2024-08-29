<script>
  import MSM_DATA from "mocks/market-segment-mapping.json";
  // in a real implementation, we'd want to expose part or all of the config being passed to kendoSpreadsheet
  // and either reinitialize the kendoSpreadsheet or use methods on it to update its data / config / etc
  let container = null;

  $: if (container != null) {
    jQuery(container).kendoSpreadsheet(sampleConfig);
    let spreadsheet = jQuery(container).data("kendoSpreadsheet");
    let sheet = spreadsheet.activeSheet();

    sheet.range("A2:C10001").enable(false);
    sheet.range("F2:AF10001").enable(false);
    sheet.frozenRows(1);
  }

  let crudServiceBaseUrl = "https://demos.telerik.com/kendo-ui/service";

  let dataSource = new kendo.data.DataSource({
    transport: {
      read: onRead,
      submit: onSubmit,
    },
    batch: true,
    change: function () {
      jQuery("#cancel, #save").toggleClass("k-disabled", !this.hasChanges());
    },
    schema: {
      model: {
        id: "MarketSegmentMapping",
        fields: {
          organization: { type: "string" },
          clientJobCode: { type: "string" },
          clientJobTitle: { type: "string" },
          clientJobGroup: { type: "string" },
          marketSegment: { type: "string" },
          nIncumbents: { type: "number" },
          nFTEs: { type: "number" },
          locationDescription: { type: "string" },
          jobFamily: { type: "string" },
          payGrade: { type: "number" },
          payType: { type: "string" },
          positionCode: { type: "string" },
          positionCodeDescription: { type: "string" },
          jobLevel: { type: "string" },
          basePayHourlyRate: { type: "number" },
          annualizedBaseSalary: { type: "number" },
          payRangeMinimum: { type: "number" },
          payRangeMidpoint: { type: "number" },
          payRangeMaximum: { type: "number" },
          annualizedPayRangeMinimum: { type: "number" },
          annualizedPayRangeMidpoint: { type: "number" },
          annualizedPayRangeMaximum: { type: "number" },
          actualAnnualIncentive: { type: "number" },
          annualIncentiveReceiving: { type: "boolean" },
          targetAnnualIncentive: { type: "number" },
          targetIncentivePercent: { type: "number" },
          annualIncentiveThresholdOpportunity: { type: "number" },
          thresholdIncentivePercent: { type: "number" },
          annualIncentiveMaximumOpportunity: { type: "number" },
          maximumIncentivePercentage: { type: "number" },
          TCCHourly: { type: "number" },
          TCC: { type: "number" },
        },
      },
    },
  });

  function onSubmit(e) {
    jQuery.ajax({
      url: crudServiceBaseUrl + "/Products/Submit",
      data: { models: kendo.stringify(e.data) },
      contentType: "application/json",
      dataType: "jsonp",
      success: function (result) {
        e.success(result.Updated, "update");
        e.success(result.Created, "create");
        e.success(result.Destroyed, "destroy");
      },
      error: function (xhr) {
        alert(xhr.responseText);
      },
    });
  }

  function onRead(options) {
    let baseRecord = {
      organization: "Hodkiewicz, Hammes and Harris",
      clientJobCode: "441ffb75-f9e2-4a71-a6be-3da6ebdbbce2",
      clientJobTitle: "Human Research Facilitator",
      clientJobGroup: "Computers",
      marketSegment: "Chair",
      nIncumbents: 7,
      nFTEs: 9,
      locationDescription: "West Johanna",
      jobFamily: "Configuration",
      payGrade: 4,
      payType: "Hourly",
      positionCode: "04179658",
      positionCodeDescription: "Assistant",
      jobLevel: "Junior",
      basePayHourlyRate: 68,
      annualizedBaseSalary: 102369,
      payRangeMinimum: 90572,
      payRangeMidpoint: 76483,
      payRangeMaximum: 142949,
      annualizedPayRangeMinimum: 97813,
      annualizedPayRangeMidpoint: 82109,
      annualizedPayRangeMaximum: 108391,
      actualAnnualIncentive: 20404,
      annualIncentiveReceiving: "No",
      targetAnnualIncentive: 20070,
      targetIncentivePercent: 7,
      annualIncentiveThresholdOpportunity: 10146,
      thresholdIncentivePercent: 13,
      annualIncentiveMaximumOpportunity: 45334,
      maximumIncentivePercentage: 16,
      TCCHourly: 94,
      TCC: 68223,
    };

    let data = Array.from({ length: 10000 }, () => Object.assign({}, baseRecord));

    options.success([...MSM_DATA, ...data]);
  }

  function SaveChanges() {
    if (!jQuery(this).hasClass("k-disabled")) {
      dataSource.sync();
    }
  }

  function CancelChanges() {
    if (!jQuery(this).hasClass("k-disabled")) {
      dataSource.cancelChanges();
    }
  }

  function PdfExport() {
    jQuery(container).data("kendoSpreadsheet").saveAsPDF();
  }

  function ExcelExport() {
    jQuery(container).data("kendoSpreadsheet").saveAsExcel();
  }

  function sheetResize() {
    let height =
      window.innerHeight -
      jQuery("footer").outerHeight(true) - // Header
      jQuery("header").outerHeight(true) - // Footer
      parseInt(jQuery("body").css("margin-top")) - // Margin of the <body>
      parseInt(jQuery("body").css("margin-bottom")) -
      2; // border of the Spreadsheet Div.
    let mySpreadsheet = jQuery("body").find(jQuery("div[data-role='spreadsheet']"));
    mySpreadsheet.css({ height: height });
    if (mySpreadsheet.data("kendoSpreadsheet")) mySpreadsheet.data("kendoSpreadsheet").resize();
  }

  let sampleConfig = {
    toolbar: false,
    sheetsbar: false,
    render: sheetResize,
    dataBinding: function (e) {
      console.log('Data is about to be bound to sheet "' + e.sheet.name() + '".');
    },
    dataBound: function (e) {
      console.log('Data has been bound to sheet "' + e.sheet.name() + '".');
    },
    excel: {
      // Required to enable saving files in older browsers
      proxyURL: "//demos.telerik.com/kendo-ui/service/export",
    },
    pdf: {
      proxyURL: "//demos.telerik.com/kendo-ui/service/export",
    },
    rows: 10001,
    columns: 32,
    sheets: [
      {
        name: "Sheet 1",
        dataSource: dataSource,
        filter: {
          ref: "A1:AF10001",
          columns: [],
        },
        // rows: [
        //   {
        //     cells: [
        //       {
        //         ...headerStyle,
        //         value: "Organization",
        //       },
        //       {
        //         ...headerStyle,
        //         value: "Client Job Code",
        //       },
        //       {
        //         ...headerStyle
        //       }
        //     ],
        //   },
        // ],
        columns: [{ width: 100 }, { width: 415 }, { width: 145 }, { width: 145 }, { width: 145 }],
      },
    ],
  };
</script>

<div class="configurator">
  <button id="save" on:click={SaveChanges}>Save changes</button>
  <button id="cancel" on:click={CancelChanges}>Cancel changes</button>
  <button id="excelExport" on:click={ExcelExport}>Excel Export</button>
  <button id="pdfExport" on:click={PdfExport}>PDF Export</button>
</div>
<br />
<div style="width: 400px">
  <div bind:this={container} style="width: 100%" />
</div>
