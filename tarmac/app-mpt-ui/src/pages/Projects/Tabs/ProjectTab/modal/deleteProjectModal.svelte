<script>
  import { onMount } from "svelte";
  import { deleteProject } from "api/apiCalls";
  import { useMutation } from "@sveltestack/svelte-query";

  export let projectId;
  export let projectVersionId;
  export let handleShowDeleteModal;

  let notes = "";
  let notificationWidget;
  let textArea, errorFooter;

  const borderError = "1px solid red";

  onMount(() => {
    textArea = document.querySelector(".noteDeleteModal");
    errorFooter = document.querySelector(".input-error-footer");
    notificationWidget = jQuery("#notification").kendoNotification().data("kendoNotification");
  });

  const closeModal = (isDeleted = false) => {
    handleShowDeleteModal(isDeleted);
  };

  const setError = () => {
    errorFooter.style.display = "block";
    textArea.style.border = borderError;
    notificationWidget.show("Please enter a deletion note", "error");
    return false;
  };

  const checkForm = () => {
    if (notes && notes.length >= 3) {
      errorFooter.style.display = "none";
      return true;
    } else {
      setError();
    }
  };

  const mutationDeleteProject = useMutation(async () => {
    const data = {
      projectId,
      projectVersionId,
      notes: notes,
    };
    const response = await deleteProject(projectId, data);
    return response.data;
  });

  $: if ($mutationDeleteProject.isSuccess) {
    notificationWidget.show("Project has been deleted successfully", "success");
    closeModal($mutationDeleteProject.isSuccess);
  }

  $: if ($mutationDeleteProject.isError) {
    textArea.style.border = borderError;
    notificationWidget.show("Error deleting project", "error");
  }

  const clearError = () => {
    errorFooter.style.display = "none";
    textArea.style.border = "";
  };

  const deleteProjectWithNote = async () => {
    if (checkForm()) {
      try {
        await $mutationDeleteProject.mutateAsync();
      } catch (error) {
        textArea.style.border = borderError;
        notificationWidget.show("Error deleting project", "error");
      }
    }
  };
</script>

<span id="notification" />
<div id="kendo-dialog" />

<div class="card" data-cy="deleteProjectModal">
  <div class="card-header card-header-sticky">
    <h5 class="my-2" data-cy="deleteModalTitle">Confirmation Required</h5>
  </div>

  <div class="row px-3 py-2 justify-content-md-center">
    <div class="col-12 px-3 p-0">
      <div class="d-flex col-12 pt-5 pb-4 justify-content-start">
        <form class="col-12">
          <!-- svelte-ignore a11y-label-has-associated-control -->
          <label class="spanTextArea">
            Are you sure you want to delete the <b><u>Project ID - {projectId}</u> ?</b> A deletion note is required.
          </label>
          <textarea
            id="noteDeleteModal"
            data-cy="noteDeleteModal"
            class="form-control noteDeleteModal textAreaHeight mt-2"
            placeholder="Enter a deletion note"
            maxlength="100"
            minlength="3"
            required
            bind:value={notes}
            on:blur={() => (notes.length >= 3 ? clearError() : setError())}
          />
          <span class="input-error-footer">Note must have at least 3 characters</span>
        </form>
      </div>

      <div class="card-footer pt-4 d-flex justify-content-start px-0">
        <div>
          <button type="submit" class="btn btn-outline-secondary" data-cy="yesDeleteModal" on:click={deleteProjectWithNote}> Yes </button>
          <button class="btn btn-primary" data-cy="cancelDeleteModal" on:click={() => closeModal()}>No</button>
        </div>
      </div>
    </div>
  </div>
</div>

<style>
  .spanTextArea {
    font-size: 16px;
    font-weight: 400;
  }

  .textAreaHeight {
    min-height: 80px;
  }

  .input-error-footer {
    text-decoration: underline;
    display: none;
    font-size: 11px;
    color: red;
  }
</style>
