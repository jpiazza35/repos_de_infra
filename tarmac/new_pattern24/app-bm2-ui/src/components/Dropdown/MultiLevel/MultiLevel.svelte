<script>
  import { Button, Dropdown, DropdownItem } from 'flowbite-svelte'
  import { Icon } from 'flowbite-svelte-icons'
  import { createEventDispatcher, onMount } from 'svelte'

  /**
   * @typedef SubOptions
   * @type {Object}
   * @property {string} label
   * @property {(string|number)} value
   */

  /**
   * @typedef DropdownOptions
   * @type {Object}
   * @property {string} label
   * @property {Array<SubOptions>} values
   */

  /** @type {Array<DropdownOptions>} */
  export let options

  /**
   * @type {string}
   */
  export let label = 'Filters'

  let mainDropdownOpen = false
  let subDropdownOpen = []

  const dispatch = createEventDispatcher()

  onMount(() => {
    subDropdownOpen = options.map(() => false)
  })

  const hoverDropdown = index => {
    subDropdownOpen = options.map(() => false)
    subDropdownOpen[index] = true
  }

  const onSelectOption = value => {
    mainDropdownOpen = false
    dispatch('onSelect', {
      value,
    })
  }
</script>

<Button class="font-normal rounded text-black text-base bg-neutral-75 hover:bg-neutral-200 focus:ring-transparent" data-cy="multi-level-dropdown"
  >{label}<Icon name="caret-down-solid" class="h-1.5 ml-2" /></Button
>
<Dropdown class="rounded bg-white" bind:open={mainDropdownOpen}>
  {#each options as option, index}
    <DropdownItem
      class="hover:bg-primary-green-500 hover:text-white font-normal"
      on:mouseenter={() => {
        hoverDropdown(index)
      }}>{option.label}</DropdownItem
    >
    <Dropdown bind:open={subDropdownOpen[index]} placement="right-start" class="rounded bg-white w-48">
      {#each option.values as subOption}
        <DropdownItem class="hover:bg-primary-green-500 hover:text-white font-normal" on:click={() => onSelectOption(subOption.value)}
          >{subOption.label}</DropdownItem
        >
      {/each}
    </Dropdown>
  {/each}
</Dropdown>
