<script>
  import { createEventDispatcher } from 'svelte'
  import Fa from 'svelte-fa'
  import { faXmark } from '@fortawesome/pro-solid-svg-icons'

  /**
   * @type {boolean}
   */
  export let open = false

  /**
   * @type {string}
   */
  export let title = 'Sidebar'

  const dispatch = createEventDispatcher()

  let defaultClass = `absolute w-4/5 h-screen bg-white border-r-2 shadow-lg z-20 top-0 transition-all duration-300 ease-in-out ${$$props.class}`
  let closedClass = `${defaultClass} left-[-100%]`
  let openClass = `${defaultClass} left-0`

  const onClose = () => {
    open = false
    dispatch('close')
  }
</script>

<div class={open ? openClass : closedClass} data-cy="sidebar">
  <div class="flex items-center justify-between border-b border-b-custom-grey-75 h-[64px] p-4">
    <h2 class="font-light text-font text-2xl" data-cy="sidebarTitle">{title}</h2>
    <button on:click={onClose} data-cy="sidebarCloseButton">
      <Fa icon={faXmark} class={'text-black'} scale={1.2} />
    </button>
  </div>
  <div style={`${$$props.style}`}>
    <slot />
  </div>
</div>
