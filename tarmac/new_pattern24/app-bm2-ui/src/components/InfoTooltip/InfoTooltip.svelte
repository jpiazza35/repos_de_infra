<script>
  // @ts-nocheck
  import Fa from 'svelte-fa'
  import { faCircleInfo } from '@fortawesome/pro-solid-svg-icons'
  import { Tooltip } from 'flowbite-svelte'
  import { guidGenerator } from 'utils/strings'
  import { device } from 'utils/device'

  /**
   * @type {import("@floating-ui/dom").Placement}
   */
  export let placement = 'bottom'

  /**
   * @type {string}
   */
  export let text = 'Tooltip content'

  let id = guidGenerator()
</script>

<button
  class={`text-neutral-800 tablet:ml-3 mobile:ml-0`}
  data-cy="infoTooltipIcon"
  on:click={event => {
    event.stopPropagation()
  }}
>
  <Fa icon={faCircleInfo} id={`infoTooltip-${id}`} scale={1.2} />
</button>
<Tooltip
  class="font-normal text-xs"
  trigger={`${device === 'mobile' ? 'click' : 'hover'}`}
  triggeredBy={`#infoTooltip-${id}`}
  {placement}
  data-cy="infoTooltip">{@html text}</Tooltip
>
