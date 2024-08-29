<script>
  import { onMount } from "svelte";
  import { unsavedMarketSegmentStore } from "../../pages/Projects/Tabs/MarketSegmentTab/Sections/marketSegmentStore";

  export let onClick = null;

  let dialogUnsaved = null;
  $: $unsavedMarketSegmentStore, addRefreshEvent();

  onMount(async () => {
    mountUnsavedDialog();
  });

  const addRefreshEvent = () => {
    if ($unsavedMarketSegmentStore) {
      window.onbeforeunload = function () {
        return "You have unsaved changes. Are you sure you want to leave without saving?";
      };
    } else {
      window.onbeforeunload = undefined;
    }
  };

  const mountUnsavedDialog = () => {
    dialogUnsaved = jQuery("#dialog-unsaved-warning").kendoDialog({
      title: "Confirmation Required",
      visible: false,
      width: 400,
      content: `You have unsaved changes. Are you sure you want to leave without saving?`,
      actions: [
        {
          text: "Yes",
          primary: true,
          action: function () {
            unsavedMarketSegmentStore.set(false);
            if (onClick) onClick();
          },
        },
        {
          text: "No",
          primary: false,
        },
      ],
    });
  };

  const handleClick = e => {
    if ($unsavedMarketSegmentStore) {
      e.preventDefault();
      e.stopPropagation();
      dialogUnsaved.data("kendoDialog").open();
    } else {
      if (onClick) onClick();
    }
  };
</script>

<!-- svelte-ignore a11y-click-events-have-key-events -->
<div on:click={handleClick}>
  <slot />
</div>

<div id="dialog-unsaved-warning" data-cy="unsavedDialogMarketSegment" />
