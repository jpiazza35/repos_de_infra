<script>
  import { onMount } from "svelte";
  import { useMutation } from "@sveltestack/svelte-query";
  import isEqual from "lodash.isequal";
  import zip from "lodash.zip";

  import { unsavedMarketSegmentStore } from "../MarketSegmentTab/Sections/marketSegmentStore";
  import Loading from "components/shared/loading.svelte";
  import { sheetRowsToDataSourceData, filterNullProperties } from "utils/functions";
  import { showBulkEditMessage } from "store/bulkEdit";
  import { saveJobMatchBulkEdit } from "api/apiCalls";

  export let jobMatchings;
  export let projVersionId;

  let spreadsheet, sheet;
  let amountOfColumns, amountOfRows;
  let invalidStandardJobCodes = [];
  let invalidJobMatchNotes = [];
  let dataBound;
  let notificationWidget;
  let fields = {
    Organization: { type: "string" },
    "Client Job Code": { type: "string" },
    "Client Position Code": { type: "string" },
    "Client Job Title": { type: "string" },
    "Client Job Group": { type: "string" },
    "Market Segment": { type: "string" },
    "Standard Job Code": { type: "string" },
    "Standard Job Title": { type: "string" },
    "Standard Job Description": { type: "string" },
    Status: { type: "string" },
    "Job Match Notes": { type: "string" },
  };

  if (jobMatchings.length > 0) {
    Object.keys(jobMatchings[0].formattedBenchmarkDataTypes).forEach(key => {
      fields[key] = { type: "string" };
    });
  }

  function onRead(e) {
    const records = jobMatchings.map(job => ({
      Organization: job.organizationName,
      "Client Job Code": job.jobCode,
      "Client Position Code": job.positionCode,
      "Client Job Title": job.jobTitle,
      "Client Job Group": job.jobGroup,
      "Market Segment": job.marketSegmentName,
      "Standard Job Code": job.standardJobCode,
      "Standard Job Title": job.standardJobTitle,
      "Standard Job Description": job.standardJobDescription,
      Status: job.jobMatchStatusName,
      "Job Match Notes": job.jobMatchNote,
      ...job.formattedBenchmarkDataTypes,
    }));
    e.success(records);
  }

  let dataSource = new kendo.data.DataSource({
    transport: {
      read: onRead,
    },
    schema: {
      model: {
        id: "JobMatching",
        fields: fields,
      },
    },
  });

  const config = {
    toolbar: {
      data: false,
      insert: false,
    },
    sheetsbar: false,
    dataBound: function () {
      dataBound = JSON.parse(JSON.stringify(dataSource.data()));
    },
    columnWidth: 100,
    change: function () {
      unsavedMarketSegmentStore.set(true);
    },
  };

  onMount(() => {
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
    jQuery("#kendo-spreadsheet").kendoSpreadsheet(config);
    spreadsheet = jQuery("#kendo-spreadsheet").data("kendoSpreadsheet");
    sheet = spreadsheet.activeSheet();
    sheet.setDataSource(dataSource);

    const BASE_COLUMN_NO = 11;
    amountOfColumns = BASE_COLUMN_NO + Object.keys(jobMatchings[0].formattedBenchmarkDataTypes).length;
    amountOfRows = jobMatchings.length + 1;

    sheet.range(0, 0, amountOfRows, amountOfColumns).enable(false);
    sheet.range("G1:G" + amountOfRows).enable(true);
    sheet.range("K1:K" + amountOfRows).enable(true);
  });

  //mutation to save spreadsheet data
  const mutationSaveBulkEdit = useMutation(
    async payload => {
      const data = await saveJobMatchBulkEdit(projVersionId, payload);
      return data.data;
    },
    {
      onSuccess: async data => {
        if (data.result.invalid.length > 0) {
          invalidStandardJobCodes = Array.from(data.result.invalid);
          notificationWidget.show("Error while updating", "error");
          return;
        }
        // remove unsaved changes indicator & show suecces message
        unsavedMarketSegmentStore.set(false);
        notificationWidget.show("The records were saved", "success");
      },
      onError: () => {
        notificationWidget.show("Error while updating", "error");
      },
    },
  );

  export const saveChanges = () => {
    invalidStandardJobCodes = [];
    invalidJobMatchNotes = [];
    const rows = spreadsheet.toJSON().sheets[0].rows.sort((a, b) => a.index - b.index);
    let records = JSON.parse(JSON.stringify(sheetRowsToDataSourceData(rows)));

    let initialData = filterNullProperties(dataBound);

    const differingRows = zip(initialData, records)
      .filter(([row1, row2]) => !isEqual(row1, row2))
      .map(([, row2]) => row2);

    const payload = differingRows.map(row => ({
      selectedJobCode: row["Client Job Code"],
      selectedPositionCode: row["Client Position Code"],
      standardJobCode: row["Standard Job Code"],
      jobMatchNote: row["Job Match Notes"],
    }));

    setTimeout(() => {
      invalidStandardJobCodes = Array.from(payload.filter(row => row.standardJobCode.length > 100).map(row => row.standardJobCode));
      invalidJobMatchNotes = Array.from(payload.filter(row => row.jobMatchNote.length > 200).map(row => row.jobMatchNote));

      if (invalidStandardJobCodes.length > 0 || invalidJobMatchNotes.length > 0) {
        return;
      }
      $mutationSaveBulkEdit.mutate(payload);
    }, 500);
  };
</script>

{#if $mutationSaveBulkEdit.isLoading}
  <div class="overlay">
    <Loading isLoading={true} />
  </div>
{/if}
<div id="notification" />
<div id="bulk-edit">
  {#if $showBulkEditMessage}
    <div class="row mb-3">
      <div class="col">
        <div class="alert alert-primary d-flex align-items-center justify-content-between" role="alert">
          The Standard Job Code and Job Match Notes are the only editable columns! To single edit, create a blend or change the publisher of the
          standards, please navigate to the single edit view.
          <button
            type="button"
            class="btn-close"
            aria-label="Close"
            on:click={() => {
              showBulkEditMessage.set(false);
            }}
          />
        </div>
      </div>
    </div>
  {/if}
  {#if invalidStandardJobCodes.length > 0}
    <div class="row mb-3" data-cy="invalidJobCodeMessage">
      <div class="col">
        <div class="alert alert-danger d-flex align-items-center justify-content-between alert-dismissible" role="alert">
          The following job codes are invalid: {invalidStandardJobCodes.join(", ")}
          <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="alert" />
        </div>
      </div>
    </div>
  {/if}
  {#if invalidJobMatchNotes.length > 0}
    <div class="row mb-3" data-cy="invalidJobMatchNotesMessage">
      <div class="col">
        <div class="alert alert-danger d-flex align-items-center justify-content-between alert-dismissible" role="alert">
          Job Match notes are invalid.
          <button type="button" class="btn-close" aria-label="Close" data-bs-dismiss="alert" />
        </div>
      </div>
    </div>
  {/if}
  <div style="height: 100vh" id="kendo-wrapper">
    <div id="kendo-spreadsheet" style="width: 100%" />
  </div>
</div>

<style>
  .overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 999;
  }
</style>
