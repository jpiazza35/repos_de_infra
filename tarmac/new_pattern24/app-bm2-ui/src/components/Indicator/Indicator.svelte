<script>
  /**
   * @type string
   */
  export let color = '#e5e7eb'

  /**
   * @type  {0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 } number
   */
  export let size = 3
</script>

<span class={`flex-none w-${size} h-${size} rounded-full ${$$props.class}`} style={`background-color: ${color}`} />
