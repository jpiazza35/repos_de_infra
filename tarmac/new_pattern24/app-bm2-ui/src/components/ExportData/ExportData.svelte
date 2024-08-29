<script>
  // @ts-nocheck
  import { Listgroup, ListgroupItem, Popover } from 'flowbite-svelte'
  import Fa from 'svelte-fa'
  import { createEventDispatcher } from 'svelte'
  import { faEllipsisVertical } from '@fortawesome/pro-solid-svg-icons'

  /**
   * @type {boolean}
   */
  export let disabled = false

  const dispatch = createEventDispatcher()

  const exportPDF = () => {
    dispatch('exportPDF')
  }

  const exportCSV = () => {
    dispatch('exportCSV')
  }

  const exportExcel = () => {
    dispatch('exportExcel')
  }
</script>

<div data-cy="exportData">
  <Fa
    icon={faEllipsisVertical}
    id="dots"
    class={`outline-none text-font text-lg ${disabled ? 'opacity-40 pointer-events-none' : 'cursor-pointer'}`}
    scale={1.1}
  />
</div>
<Popover
  arrow={false}
  class="w-48 border-transparent shadow-none z-10"
  defaultClass="p-0"
  placement="bottom-end"
  triggeredBy="#dots"
  trigger="click"
  data-cy="exportDataPopover"
>
  <Listgroup active class="rounded w-full" defaultClass="">
    <ListgroupItem
      class="font-normal text-custom-neutral-800 hover:text-primary-green-500 hover:bg-custom-neutral-50"
      focusClass="shadow-none text-primary-green-500"
      data-cy="exportDataPDF"
      on:click={exportPDF}>Export Data to PDF</ListgroupItem
    >
    <ListgroupItem
      class="font-normal text-custom-neutral-800 hover:text-primary-green-500 hover:bg-custom-neutral-50"
      focusClass="shadow-none text-primary-green-500"
      data-cy="exportDataCSV"
      on:click={exportCSV}>Export Data to CSV</ListgroupItem
    >
    <ListgroupItem
      class="font-normal text-custom-neutral-800 hover:text-primary-green-500 hover:bg-custom-neutral-50"
      focusClass="shadow-none text-primary-green-500"
      data-cy="exportDataExcel"
      on:click={exportExcel}>Export Data to Excel</ListgroupItem
    >
  </Listgroup></Popover
>
