<script>
  import { onMount, onDestroy } from 'svelte'

  /**
   * @type {string}
   */
  export let triggeredBy = ''

  /**
   * @type {boolean}
   */
  export let open = false

  onMount(() => {
    const trigger = document.querySelectorAll(triggeredBy)
    if (trigger) {
      trigger.forEach(el => {
        el.addEventListener('mousedown', () => {
          open = !open
        })
        el.addEventListener('focus', () => {
          open = true
        })
      })
    }
  })

  onDestroy(() => {
    const trigger = document.querySelectorAll(triggeredBy)
    if (trigger) {
      trigger.forEach(el => {
        el.removeEventListener('mousedown', () => {
          open = !open
        })
        el.removeEventListener('focus', () => {
          open = true
        })
      })
    }
  })
</script>

<div class="relative">
  <div tabindex="-1" role="tooltip" class="absolute z-10 mt-1 flex max-w-max" style:visibility={open ? 'visible' : 'hidden'}>
    <div class="max-w-md px-6 py-4 flex-auto overflow-hidden rounded-md bg-white text-sm shadow-md border border-gray-200">
      <slot />
    </div>
  </div>
</div>
