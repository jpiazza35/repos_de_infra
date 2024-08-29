<script>
  import { Tooltip } from 'flowbite-svelte'
  import { onMount } from 'svelte'
  import { guidGenerator } from 'utils/strings'
  import { numberFormat } from 'utils/strings'

  const BAR_RED = '#AC3431'
  const BAR_GREEN = '#61A961'

  /**
   * @type {boolean}
   */
  export let isPercentage = false

  /**
   * @type {string}
   */
  export let barColor = undefined

  /**
   * @type {Array<number>}
   */
  export let markValues = []

  /**
   * @type {number}
   */
  export let value = 50

  /**
   * @type {number}
   */
  export let transitionTime = 1000

  let maxMarkValue = Math.max(...markValues)
  let progressBarColor = barColor ? barColor : maxMarkValue > value ? BAR_RED : BAR_GREEN
  let progressBarValue = 0
  $: markValuesId = markValues.map(() => guidGenerator())
  onMount(() => {
    progressBarValue = value
  })
</script>

<div class="relative w-full bg-gray-200 rounded-full h-2.5 dark:bg-gray-700" data-cy="progressBar">
  <div
    class="h-2.5 rounded-full"
    style={`background-color: ${progressBarColor}; transition: width ${transitionTime}ms; transition-timing-function: ease-in-out; width: ${progressBarValue}%`}
  />
  {#each markValues as markValue, index}
    <div
      id={`markValue-${markValuesId[index]}`}
      class="flex flex-col items-center absolute w-px"
      style={`top: -8px; left: ${markValue}%`}
      data-cy="progressBarMark"
    >
      <div class="bg-black rounded-full w-2 h-2" />
      <div style="height: 14px; border-right: 2px solid black; width: 2px;" />
      <div class="mt-1 text-font text-xs" data-cy="progressBarMarkValue">
        {index === markValues.length - 1 ? (isPercentage ? `${markValue}%` : numberFormat(markValue)) : ''}
      </div>
    </div>
    <Tooltip class="font-normal text-xs" triggeredBy={`#markValue-${markValuesId[index]}`} placement="top"
      >{isPercentage ? `${markValue}%` : numberFormat(markValue)}</Tooltip
    >
  {/each}
</div>
