<script>
  export let isLoading = false;
</script>

{#if isLoading}
    <div class="loading">
      <div class="loading-bar" />
      <div class="loading-bar" />
      <div class="loading-bar" />
      <div class="loading-bar" />
      <div class="loading-bar" />
      <div class="loading-bar" />
  </div>
{/if}

<style>
  .loading {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 50px;
    margin-top: 10px;
  }

  .loading-bar {
    display: inline-block;
    width: 6px;
    height: 18px;
    margin-right: 4px;
    background-color: #3498db;
    animation: loading 1.5s ease-in-out infinite;
  }

  .loading-bar:nth-child(1) {
    animation-delay: 0s;
  }

  .loading-bar:nth-child(2) {
    animation-delay: 0.1s;
  }

  .loading-bar:nth-child(3) {
    animation-delay: 0.2s;
  }

  .loading-bar:nth-child(4) {
    animation-delay: 0.3s;
  }

  .loading-bar:nth-child(5) {
    animation-delay: 0.4s;
  }

  .loading-bar:nth-child(6) {
    animation-delay: 0.5s;
  }
  /* .overlay {
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
  } */

  @keyframes loading {
    0% {
      transform: scale(1);
    }

    20% {
      transform: scale(1, 2.5);
    }

    40% {
      transform: scale(1);
    }
  }
</style>
