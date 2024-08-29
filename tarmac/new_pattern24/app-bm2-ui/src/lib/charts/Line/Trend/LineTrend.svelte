<script>
  import * as am5 from '@amcharts/amcharts5'
  import * as am5xy from '@amcharts/amcharts5/xy'
  import am5themes_Animated from '@amcharts/amcharts5/themes/Animated'
  import { onMount } from 'svelte'
  import { createTooltipLineSeries } from 'utils/amcharts'
  import { CHART_COLOR_FONT } from 'utils/constants'

  /**
   * @typedef {Object} LineTrendData
   * @property {number} date
   * @property {number} [value1]
   * @property {number} [value2]
   */

  /** @type {Array<LineTrendData>} */
  export let data = []

  /**
   * @typedef {Object} LineTrendRanges
   * @property {number} value
   * @property {string} color
   */

  /** @type {Array<LineTrendRanges>} */
  export let ranges = []

  /**
   * @type {string}
   */
  export let lineColor1 = '#00737B'

  /**
   * @type {string}
   */
  export let lineColor2 = '#99DDD8'

  /**
   * @typedef {Object} LineTrendChartProps
   * @property {number} [minGridDistancedate]
   * @property {number} [rangeWidth]
   */

  /** @type LineTrendChartProps */
  export let chartProps = {
    minGridDistancedate: 50,
    rangeWidth: 10,
  }

  let container
  let xAxis
  let yAxis
  let chartRanges = []

  onMount(() => {
    let root = am5.Root.new(container)

    // Set themes
    root.setThemes([am5themes_Animated.new(root)])

    // Create chart
    let chart = root.container.children.push(
      am5xy.XYChart.new(root, {
        maxTooltipDistance: 0,
      }),
    )

    // Set cursor to enable tooltip on hover
    let cursor = chart.set('cursor', am5xy.XYCursor.new(root, {}))
    cursor.lineY.setAll({
      visible: false,
    })
    cursor.lineX.setAll({
      visible: false,
    })

    // Set X axes
    let xRenderer = am5xy.AxisRendererX.new(root, { minGridDistance: 0 })
    xRenderer.labels.template.setAll({
      centerY: am5.p50,
      centerX: am5.p50,
      fill: am5.color(CHART_COLOR_FONT),
      fontSize: '0.8em',
      paddingTop: 10,
    })

    xAxis = chart.xAxes.push(
      am5xy.DateAxis.new(root, {
        baseInterval: {
          timeUnit: 'month',
          count: 1,
        },
        markUnitChange: false,
        renderer: xRenderer,
      }),
    )
    xAxis.get('dateFormats')['month'] = 'MMM'
    xAxis.get('renderer').grid.template.set('forceHidden', true)

    // Set Y axes
    let yRenderer = am5xy.AxisRendererY.new(root, {
      minGridDistance: chartProps.minGridDistancedate,
    })
    yRenderer.labels.template.setAll({
      centerY: am5.p50,
      centerX: am5.p50,
      fill: am5.color(CHART_COLOR_FONT),
      fontSize: '0.8em',
      paddingRight: 10,
    })

    yAxis = chart.yAxes.push(
      am5xy.ValueAxis.new(root, {
        min: 0,
        renderer: yRenderer,
      }),
    )

    // Add series 1
    let series = chart.series.push(
      am5xy.LineSeries.new(root, {
        name: 'Series 1',
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: 'value1',
        valueXField: 'date',
        stroke: am5.color(lineColor1),
      }),
    )
    series.strokes.template.setAll({
      strokeWidth: 4,
    })
    series.bullets.push(function (root) {
      return am5.Bullet.new(root, {
        sprite: am5.Circle.new(root, {
          radius: 4,
          fill: root.interfaceColors.get('background'),
          stroke: am5.color(lineColor1),
          strokeWidth: 3,
        }),
      })
    })
    createTooltipLineSeries(series, root)

    // Add series 2
    let series2 = chart.series.push(
      am5xy.LineSeries.new(root, {
        name: 'Series 2',
        xAxis: xAxis,
        yAxis: yAxis,
        valueYField: 'value2',
        valueXField: 'date',
        stroke: am5.color(lineColor2),
      }),
    )
    series2.strokes.template.setAll({
      strokeWidth: 4,
    })
    series2.bullets.push(function (root) {
      return am5.Bullet.new(root, {
        sprite: am5.Circle.new(root, {
          radius: 4,
          fill: root.interfaceColors.get('background'),
          stroke: am5.color(lineColor2),
          strokeWidth: 3,
        }),
      })
    })
    createTooltipLineSeries(series2, root)

    // Set data
    series.data.setAll(data)
    series2.data.setAll(data)

    // Make stuff animate on load
    series.appear(1000)
    series2.appear(1000)
    chart.appear(1000, 100)
  })

  // Add ranges
  $: if (ranges && yAxis) {
    chartRanges.forEach(chartRange => {
      yAxis.axisRanges.removeValue(chartRange)
    })

    ranges.forEach(range => {
      createAxisRange(range.value, range.color, yAxis)
    })
  }

  const createAxisRange = (value, color, yAxis) => {
    const rangeDataItem = yAxis.makeDataItem({
      value: value + chartProps.rangeWidth,
      endValue: value - chartProps.rangeWidth,
    })

    const range = yAxis.createAxisRange(rangeDataItem)
    chartRanges.push(range)
    range.get('axisFill').setAll({
      fill: am5.color(color),
      fillOpacity: 1,
      visible: true,
    })
  }
</script>

<div bind:this={container} class="w-full h-full" data-cy="lineCompareChart" />
