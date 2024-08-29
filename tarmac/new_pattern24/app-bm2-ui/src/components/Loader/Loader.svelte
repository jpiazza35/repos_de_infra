<script>
  import { Spinner } from 'flowbite-svelte'

  export let fullScreen = false
</script>

<div class={`flex w-full ${fullScreen ? ' h-screen' : ' h-full'} justify-center items-center`} data-cy="loader">
  <Spinner size={'16'} color="green" />
</div>
