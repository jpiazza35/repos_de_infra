<script>
  import * as am5 from '@amcharts/amcharts5'
  import * as am5percent from '@amcharts/amcharts5/percent'
  import am5themes_Animated from '@amcharts/amcharts5/themes/Animated'
  import { onMount } from 'svelte'
  import { createTooltipPieSeries } from 'utils/amcharts'
  import { CHART_PIE_COLORS } from 'utils/constants'
  import { dollarFormat, numberFormat } from 'utils/strings'

  /**
   * @typedef PieData
   * @type {Object}
   * @property {string} category
   * @property {number} total
   */

  /** @type {Array<PieData>} */
  export let data = []

  /**
   * @type {boolean}
   */
  export let currentyFormat = false

  /**
   * @type {Array<string>}
   */
  export let chartColors = undefined

  /**
   * @type {number}
   */
  export let innerRadius = 0

  /**
   * @type {number}
   */
  export let radius = 80

  /**
   * @type {boolean}
   */
  export let showTotalLabel = false

  /**
   * @type {boolean}
   */
  export let showLabel = false

  /**
   * @type {boolean}
   */
  export let showTooltips = false

  let container

  onMount(() => {
    const totalValue = data.reduce((acc, item) => acc + item.total, 0)

    // Create root element
    let root = am5.Root.new(container)

    // Set themes
    root.setThemes([am5themes_Animated.new(root)])

    // Create chart
    let chart = root.container.children.push(
      am5percent.PieChart.new(root, {
        radius: am5.percent(radius),
        layout: root.verticalLayout,
        innerRadius: innerRadius ? am5.percent(innerRadius) : 0,
        startAngle: -180,
        endAngle: 180,
      }),
    )

    // Create center label
    if (showTotalLabel)
      chart.seriesContainer.children.push(
        am5.Label.new(root, {
          textAlign: 'center',
          centerY: am5.p50,
          centerX: am5.p50,
          text: `[fontSize:18px fontWeight:600 #00737B]${currentyFormat ? dollarFormat(totalValue) : numberFormat(totalValue)}[/]`,
        }),
      )

    // Create series
    let series = chart.series.push(
      am5percent.PieSeries.new(root, {
        valueField: 'total',
        categoryField: 'category',
        startAngle: -180,
        endAngle: 180,
      }),
    )
    series.slices.template.set('toggleKey', 'none')

    // Set labels
    if (showLabel) {
      series.labels.template.setAll({
        fontSize: '0.7em',
        fill: am5.color('#B0B0B1'),
        html: currentyFormat
          ? `<span style="font-size: 16px"><b>{value.formatNumber('#,###.00')}</b></span><br><span style="font-size: 14px">{category}</span>`
          : `<span style="font-size: 16px"><b>{value}%</b></span><br><span style="font-size: 14px">{category}</span>`,
      })
    } else {
      series.labels.template.set('forceHidden', true)
      series.ticks.template.set('visible', false)
    }

    // Set tooltips
    if (showTooltips) {
      const labelText = currentyFormat
        ? "[fontSize: 11px]{category}: ${value.formatNumber('#,###.00')}[/]"
        : "[fontSize: 11px]{category}: {value.formatNumber('#,###.00')}[/]"
      createTooltipPieSeries(labelText, series, root)
    } else {
      series.slices.template.set('tooltipText', '')
    }

    // Set chart colors
    const pieColors = chartColors ? chartColors : CHART_PIE_COLORS
    series.get('colors').set(
      'colors',
      pieColors.map(color => {
        return am5.color(color)
      }),
    )
    series.appear()

    // Set data
    if (data) series.data.setAll(data)
  })
</script>

<div bind:this={container} class="w-full h-full" data-cy="pieChart" />
