<script>
  import { showMarketSegmentMappingMessage } from "store/tabs";
  import { ProjectStatus, FileStatus } from "models/project/projectDetails";

  export let projectDetails;

  const getProjectStatusMessage = projectDetails => {
    let message = "";
    switch (projectDetails.fileStatusKey) {
      case FileStatus.Invalid:
        message =
          "The file uploaded for this project version has a status of Invalid. Please upload a new file or correct the current file for data to populate.";
        break;

      default:
        message = `The file uploaded for this project version has a status of ${projectDetails.fileStatusName}. Please check back once it is validated.`;
        break;
    }
    return message;
  };
</script>

{#if projectDetails}
  {#if projectDetails.fileStatusKey && projectDetails.fileStatusKey >= 5 && projectDetails.fileStatusKey <= 8}
    {#if $showMarketSegmentMappingMessage && projectDetails.projectStatus === ProjectStatus.DRAFT}
      <div class="row mb-3">
        <div class="col-6">
          <div class="alert alert-primary d-flex align-items-center justify-content-between" role="alert">
            The Client Job Group and Market Segment columns are the only editable fields.
            <button
              type="button"
              class="btn-close"
              aria-label="Close"
              on:click={() => {
                showMarketSegmentMappingMessage.set(false);
              }}
            />
          </div>
        </div>
      </div>
    {/if}
  {:else}
    <div class="alert alert-danger" role="alert">
      {getProjectStatusMessage(projectDetails)}
    </div>
  {/if}
{/if}
