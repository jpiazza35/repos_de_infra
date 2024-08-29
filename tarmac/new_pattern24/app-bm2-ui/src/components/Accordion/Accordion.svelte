<script>
  import { slide } from 'svelte/transition'
  import Fa from 'svelte-fa'
  import { faChevronDown } from '@fortawesome/pro-solid-svg-icons'

  /**
   * @type {boolean}
   */
  export let open = false

  /**
   * @type {string}
   */
  export let headerClass = ''

  /**
   * @type {string}
   */
  export let iconClass = ''

  const handleClick = () => (open = !open)
</script>

<div class="relative bg-white border border-gray-200 rounded-lg shadow-md" {...$$props}>
  <button on:click={handleClick} class={`flex items-center h-16 px-4 w-full ${headerClass}`} data-cy="accordionHeader">
    <div class="flex-1 mr-2">
      <slot name="head" />
    </div>
    <Fa icon={faChevronDown} class={`text-black duration-100 ${open ? 'rotate-180' : ''} ${iconClass}`} scale={1.1} />
  </button>

  {#if open}
    <div class="p-4 pt-0" data-cy="accordionDetails" transition:slide>
      <slot name="details" />
    </div>
  {/if}
</div>
