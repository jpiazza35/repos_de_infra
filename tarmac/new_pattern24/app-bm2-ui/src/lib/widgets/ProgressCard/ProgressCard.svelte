<script>
  // @ts-nocheck

  import { Card } from 'flowbite-svelte'
  import ProgressBar from 'lib/widgets/ProgressBar/ProgressBar.svelte'
  import Title from 'components/Title/Title.svelte'
  import { numberFormat } from 'utils/strings'

  /**
   * @type {string}
   */
  export let title = 'Title'

  /**
   * @type {string}
   */
  export let subTitle = 'Quality | Individual'

  /**
   * @type {string}
   */
  export let subChartTitle = 'YTD Performance'

  /**
   * @type {number}
   */
  export let value = 50

  /**
   * @type {Array<number>}
   */
  export let markValues = [55]

  let progressBarValue = value > 100 ? 100 : value
</script>

<Card padding="md" class="max-w-none shadow-none" data-cy="progressCard">
  <div class="flex justify-between w-full">
    <div>
      <Title class="mb-1" data-cy="progressTitle" {title} />
      <p class="text-custom-neutral-600 text-xs">{subTitle}</p>
    </div>
    <div>
      <p class="mb-1 text-neutral-600 text-xs">{subChartTitle}</p>
      <p class="font-bold text-font text-base text-end">{numberFormat(value)}</p>
    </div>
  </div>
  <div class="my-6">
    <ProgressBar value={progressBarValue} {markValues} />
  </div>
</Card>
