<script>
  import { Card } from 'flowbite-svelte'
  import Title from 'components/Title/Title.svelte'

  /**
   * @type {string}
   */
  export let label = 'Label'

  /**
   * @type {string}
   */
  export let image = undefined

  /**
   * @type {string}
   */
  export let title = undefined

  /**
   * @type {string}
   */
  export let value = '$69,420'

  /**
   * @type {string}
   */
  export let valueColor = undefined
</script>

<div data-cy="valueCard">
  <Card class="h-full max-w-none tablet:p-4 laptop:py-4 laptop:px-6 rounded-2xl shadow-none">
    {#if title}
      <div class="flex justify-between h-14 w-full">
        <Title class="mb-2 leading-6" data-cy="valueCardTitle" {title} />
      </div>
    {/if}
    <div class="flex flex-col items-center">
      <img class="my-2.5 h-12" src={image} alt={label} />
      <p class="text-3xl mb-2" style={`color: ${valueColor}`} data-cy="valueCardValue">{value}</p>
      <p class="mb-4 font-normal text-custom-neutral-600 text-lg" data-cy="valueCardLabel">{label}</p>
    </div>
  </Card>
</div>
