<script>
  import { onDestroy } from "svelte";
  import { tabFullScreen } from "../../store/tabs";

  const unsubscribeToTabFullScreen = tabFullScreen.subscribe(value => {
    window.location.hash = value ? "fullScreen" : "";
  });

  window.onhashchange = function () {
    if ($tabFullScreen && window.location.hash != "#fullScreen") {
      tabFullScreen.update(() => false);
    }
  };

  onDestroy(() => {
    unsubscribeToTabFullScreen();
  });
</script>

<style>
  :global(body) {
    overflow: hidden;
  }
  :global(header) {
    display: none;
  }
  :global(nav) {
    display: none;
  }
  :global(footer) {
    display: none;
  }
</style>
