<script>
  import { updateKendoDialogStyles } from "../../../../../components/shared/functions";
  import { beforeUpdate } from "svelte";
  export let deleteProps;

  beforeUpdate(() => {
    jQuery("#deleteDialog").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      width: 400,
      content: "Are you sure you want to delete the Market Segment?",
      actions: [
        {
          text: "Yes",
          primary: true,
          action: function () {
            close();
            return true;
          },
        },
        {
          text: "No",
          primary: true,
        },
      ],
    });
    var dialog = jQuery("#deleteDialog").data("kendoDialog");
    dialog.open();
    updateKendoDialogStyles(dialog.element);
  });
</script>

<div id="deleteDialog" data-cy="deleteDialog" />
