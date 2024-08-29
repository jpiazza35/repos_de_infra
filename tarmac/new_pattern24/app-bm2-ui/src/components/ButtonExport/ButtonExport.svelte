<script>
  // @ts-nocheck
  import { fly } from 'svelte/transition'
  import Fa from 'svelte-fa'
  import { faCircleCheck, faDownload } from '@fortawesome/pro-solid-svg-icons'
  import { Button, Toast } from 'flowbite-svelte'
  import ProgressBar from 'lib/widgets/ProgressBar/ProgressBar.svelte'

  let exporting = false
  let exportCompleted = false

  const exportDashboard = () => {
    exporting = true
    setTimeout(() => {
      exportCompleted = true
    }, 3000)
    setTimeout(() => {
      exporting = false
      exportCompleted = false
    }, 5000)
  }
</script>

<Button
  on:click={exportDashboard}
  color="light"
  class="text-black text-base bg-custom-neutral-75 border-custom-neutral-75 font-normal rounded h-10 my-1 px-2.5"
  data-cy="buttonExport"
>
  <Fa icon={faDownload} class={'text-black mr-2'} scale={1.1} />
  Export
</Button>
<div class="fixed bottom-2 w-full">
  <Toast
    simple={true}
    open={exporting}
    transition={fly}
    params={{ x: 200 }}
    position="bottom-right"
    class={exportCompleted ? 'border-l-8 border-success h-20' : 'border-l-8 border-info h-20'}
    data-cy="toastExport"
  >
    <div class="flex items-center mr-6">
      {#if exportCompleted}
        <Fa icon={faCircleCheck} class={'text-success mr-4'} scale={1.5} />
      {:else}
        <Fa icon={faDownload} class={'text-info mr-4'} scale={1.5} />
      {/if}
      <div class="flex flex-col w-full">
        <span class={'text-font text-base font-bold mb-1'}>{exportCompleted ? 'PDF Exporting complete' : 'Exporting PDF'} </span>
        {#if exporting}
          <ProgressBar barColor="#B0B0B1" value={100} transitionTime={3000} />
        {/if}
      </div>
    </div>
  </Toast>
</div>
