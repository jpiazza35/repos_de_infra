<script>
  // @ts-nocheck
  import { createEventDispatcher } from 'svelte'
  import calendarize from 'calendarize'
  import { Card } from 'flowbite-svelte'
  import { numberFormat } from 'utils/strings'
  import { MONTHS } from 'utils/constants'

  /**
   * @typedef {Object.<number, number>} CalendarData
   */

  /** @type {CalendarData} */
  export let data = {}

  /**
   * @typedef {Object} DataColors
   * @property {Object} low
   * @property {string} low.background
   * @property {string} low.font
   * @property {Object} mid
   * @property {string} mid.background
   * @property {string} mid.font
   * @property {Object} high
   * @property {string} high.background
   * @property {string} high.font
   */

  /**
   * @type {DataColors}
   */
  export let dataColors = {
    low: {
      background: '#66CBC4',
      font: '#333335',
    },
    mid: {
      background: '#008E8C',
      font: '#FFFFFF',
    },
    high: {
      background: '#004D52',
      font: '#FFFFFF',
    },
  }

  /**
   * @type {boolean}
   */
  export let active = false

  /**
   * @type {number}
   */
  export let maxValue = 50

  /**
   * @type {number}
   */
  export let year = 2022

  /**
   * @type {number}
   */
  export let month = 0 // Jan

  /**
   * @type {number}
   */
  export const offset = 0 // Sun

  const dispatch = createEventDispatcher()
  const days = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
  const months = MONTHS

  let today = new Date()
  $: today_month = today && today.getMonth()
  $: today_year = today && today.getFullYear()
  $: today_day = today && today.getDate()

  let prev = calendarize(new Date(year, month - 1), offset)
  let current = calendarize(new Date(year, month), offset)
  let next = calendarize(new Date(year, month + 1), offset)

  // if the current month only have 5 weeks, add a 6th week of the next month
  if (current.length === 5) {
    current.push([0, 0, 0, 0, 0, 0, 0])
  }

  // eslint-disable-next-line no-unused-vars
  const isToday = day => {
    return today && today_year === year && today_month === month && today_day === day
  }

  const getColor = value => {
    if (value) {
      if (value > maxValue * 0.75) {
        return `background-color: ${dataColors.high.background}; color: ${dataColors.high.font}`
      } else if (value > maxValue * 0.5) {
        return `background-color: ${dataColors.mid.background}; color: ${dataColors.mid.font}`
      } else {
        return `background-color: ${dataColors.low.background}; color: ${dataColors.low.font}`
      }
    }
    return 'cursor: default'
  }

  const onSelectDay = (value, day) => {
    if (value) dispatch('onSelectDate', { date: new Date(year, month, day) })
  }

  const baseStyle =
    'flex items-center flex-col font-bold relative overflow-hidden  mx-0.5 mb-1 pt-1.5 rounded text-font text-center laptop:text-base laptop:h-[52px] mobile:h-[48px] mobile:text-sm '
  const weekStyle = `${baseStyle} bg-custom-neutral-50`
  const weekendStyle = `${baseStyle} bg-custom-neutral-100`
  const weekOutStyle = `${weekStyle} opacity-40`
  const weekendOutStyle = `${weekendStyle} opacity-40`
</script>

<Card
  padding={'none'}
  class={`h-full max-w-none rounded-2xl shadow-none items-center laptop:p-6 mobile:p-4 ${
    active ? 'rounded-2xl border-[3px] border-primary-green-500' : ''
  }`}
  data-cy="calendar"
>
  <div style="max-width: 420px" class="w-full">
    <header class="flex items-center justify-center m-4">
      <h4 class="block font-bold text-2xl text-center text-custom-neutral-600 my-1" data-cy="calendarMonthLabel">{months[month]} {year}</h4>
    </header>
    <div class="grid grid-cols-7 tablet:gap-1 mobile:gap-0.5 text-right">
      {#each days as day, index (day)}
        <span class="font-bold mb-2 text-center text-sm text-custom-neutral-400" data-cy="calendarDayLabel">{days[(index + offset) % 7]}</span>
      {/each}

      <!--  eslint-disable-next-line no-unused-vars -->
      {#each { length: 6 } as _week, indexWeek (indexWeek)}
        {#if current[indexWeek]}
          <!--  eslint-disable-next-line no-unused-vars -->
          {#each { length: 7 } as _day, indexDay (indexDay)}
            {#if current[indexWeek][indexDay] != 0}
              <button
                on:click={() => onSelectDay(data[current[indexWeek][indexDay]], current[indexWeek][indexDay])}
                class={indexDay !== 0 && indexDay !== 6 ? weekStyle : weekendStyle}
                style={`${getColor(data[current[indexWeek][indexDay]])}`}
                data-cy={`calendarDay-${current[indexWeek][indexDay]}`}
              >
                <span>{current[indexWeek][indexDay]}</span>
                <span class="font-normal mobile:text-[10px] laptop:text-xs"
                  >{data[current[indexWeek][indexDay]] ? numberFormat(data[current[indexWeek][indexDay]]) : ''}</span
                >
                {#if isToday(current[indexWeek][indexDay])}
                  <div class="absolute bg-warning h-5 w-5 rotate-45 top-[-10px] right-[-10px]" />
                {/if}
              </button>
            {:else if indexWeek < 1}
              <div class={indexDay !== 0 && indexDay !== 6 ? weekOutStyle : weekendOutStyle}>{prev[prev.length - 1][indexDay]}</div>
            {:else if indexWeek === 5 && current[indexWeek][0] === 0 && current[indexWeek - 1][6] === 0}
              <div class={indexDay !== 0 && indexDay !== 6 ? weekOutStyle : weekendOutStyle}>{next[1][indexDay]}</div>
            {:else}
              <div class={indexDay !== 0 && indexDay !== 6 ? weekOutStyle : weekendOutStyle}>{next[0][indexDay]}</div>
            {/if}
          {/each}
        {/if}
      {/each}
    </div>
  </div>
</Card>
