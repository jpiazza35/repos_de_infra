<script>
  // @ts-nocheck
  import { Button, Dropdown, Checkbox } from 'flowbite-svelte'
  import Fa from 'svelte-fa'
  import { createEventDispatcher } from 'svelte'
  import { faCaretDown } from '@fortawesome/pro-solid-svg-icons'

  /**
   * @typedef DropdownOptions
   * @type {Object}
   * @property {string} label
   * @property {boolean} checked
   */

  /** @type {Array<DropdownOptions>} */
  export let options = [
    {
      label: 'Default checkbox',
      checked: false,
    },
    {
      label: 'Checked state',
      checked: true,
    },
    {
      label: 'Default checkbox',
      checked: false,
    },
  ]

  /**
   * @type {string}
   */
  export let dropdownWidth = 'w-56'

  /**
   * @type {string}
   */
  export let label = 'Dropdown checkbox'

  const dispatch = createEventDispatcher()

  /**
   * @param {DropdownOptions} option
   */
  const onClick = option => () => {
    option.checked = !option.checked
    dispatch('onSelect', {
      value: option,
    })
  }
</script>

<Button class="font-normal px-2.5 rounded text-font bg-neutral-100 hover:bg-neutral-200 focus:ring-transparent" data-cy="checkboxDropdownButton"
  >{label}
  <Fa icon={faCaretDown} class="h-1.5 ml-2" />
</Button>
<Dropdown class={`${dropdownWidth} p-0 text-sm`} data-cy="checkboxDropdownList">
  {#each options as option, index}
    <li class="flex items-center rounded cursor-pointer px-2 h-9 hover:bg-gray-100" data-cy={`checkboxDropdownOption-${index}`}>
      <Checkbox
        checked={option.checked}
        on:click={onClick(option)}
        color="green"
        class="cursor-pointer font-normal"
        data-cy={`checkboxDropdownCheckbox-${index}`}>{option.label}</Checkbox
      >
    </li>
  {/each}
</Dropdown>
