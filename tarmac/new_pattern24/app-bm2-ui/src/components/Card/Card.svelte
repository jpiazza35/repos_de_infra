<script>
  // @ts-nocheck
  import { createEventDispatcher } from 'svelte'
  import { Card } from 'flowbite-svelte'
  import Accordion from 'components/Accordion/Accordion.svelte'
  import ExportData from 'components/ExportData/ExportData.svelte'
  import InfoTooltip from 'components/InfoTooltip/InfoTooltip.svelte'
  import Loader from 'components/Loader/Loader.svelte'
  import Title from 'components/Title/Title.svelte'
  import { device } from 'utils/device'

  /**
   * @type {string}
   */
  export let infoTooltip = undefined

  /**
   * @type {string}
   */
  export let subTitle = undefined

  /**
   * @type {string}
   */
  export let title = 'Title'

  /**
   * @type {string}
   */
  export let cyComponent = 'cyComponent'

  /**
   * @type {string}
   */
  export let cyTitle = 'cyTitle'

  /**
   * @type {string}
   */
  export let cySubTitle = 'cySubTitle'

  /**
   * @type {boolean}
   */
  export let isLoading = false

  /**
   * @type {boolean}
   */
  export let open = false

  const dispatch = createEventDispatcher()

  const onExportCSV = () => {
    dispatch('exportPDF')
  }

  const onExportPDF = () => {
    dispatch('exportCSV')
  }

  const onExportExcel = () => {
    dispatch('exportExcel')
  }
</script>

{#if $device === 'mobile'}
  <Accordion data-cy={cyComponent} {open}>
    <div class="flex items-center" slot="head">
      <Title data-cy={cyTitle} {title} class="!text-lg" />
    </div>
    <div slot="details">
      {#if isLoading}
        <Loader />
      {:else}
        <div class={`flex mb-6 mr-1.5 ${infoTooltip || subTitle ? 'justify-between' : 'justify-end'}`}>
          {#if subTitle}
            <span class="font-normal text-custom-neutral-600 text-xs" data-cy={cySubTitle}>{subTitle}</span>
          {/if}
          {#if infoTooltip}
            <InfoTooltip text={infoTooltip} />
          {/if}
          <ExportData on:exportCSV={onExportCSV} on:exportPDF={onExportPDF} on:exportExcel={onExportExcel} />
        </div>
        <slot />
      {/if}
    </div>
  </Accordion>
{:else}
  <Card padding="md" class="h-full max-w-none" data-cy={cyComponent}>
    <div class="flex justify-between w-full">
      <div class="mb-6">
        <div class="flex items-center">
          <Title class="mb-0" data-cy={cyTitle} {title} />
          {#if infoTooltip}
            <InfoTooltip text={infoTooltip} />
          {/if}
        </div>
        {#if subTitle}
          <span class="font-normal text-custom-neutral-600 text-xs" data-cy={cySubTitle}>{subTitle}</span>
        {/if}
      </div>
      <ExportData on:exportCSV={onExportCSV} on:exportPDF={onExportPDF} on:exportExcel={onExportExcel} disabled={isLoading} />
    </div>
    {#if isLoading}
      <Loader />
    {:else}
      <slot />
    {/if}
  </Card>
{/if}
