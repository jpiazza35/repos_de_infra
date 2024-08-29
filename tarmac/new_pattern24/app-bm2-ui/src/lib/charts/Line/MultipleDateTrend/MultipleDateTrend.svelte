<script>
  import * as am5 from '@amcharts/amcharts5'
  import * as am5xy from '@amcharts/amcharts5/xy'
  import am5themes_Animated from '@amcharts/amcharts5/themes/Animated'
  import { onMount } from 'svelte'
  import { CHART_COLOR_FONT } from 'utils/constants'
  import { device } from 'utils/device'

  /**
   * @typedef {Object} LineTrendData
   * @property {number} date
   * @property {number} [value]
   * @property {number} [total]
   */

  /** @type {Array<LineTrendData>} */
  export let dataCurrent = []

  /** @type {Array<LineTrendData>} */
  export let dataPrior = []

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
   * @type {string}
   */
  export let tooltipHTML = `<div style="color: white; font-size: 0.8em">
          <span>{valueX.formatDate('MMMM yyyy')}</span><br/>
          <span>wRVU: {valueY.formatNumber('#,###.00')}</span><br/>
          <span><b>{total}</b></span>
          </div>`

  /**
   * @typedef {Object} LineTrendChartProps
   * @property {number} [minGridDistance]
   * @property {number} [rangeWidth]
   */

  /** @type LineTrendChartProps */
  export let chartProps = {
    minGridDistance: 50,
    rangeWidth: 10,
  }

  let container
  let xAxis0
  let xAxis1
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
      paddingTop: 0,
    })

    xAxis0 = chart.xAxes.push(
      am5xy.DateAxis.new(root, {
        baseInterval: {
          timeUnit: 'month',
          count: 1,
        },
        markUnitChange: false,
        startLocation: 0.25,
        renderer: xRenderer,
      }),
    )
    xAxis0.get('dateFormats')['month'] = $device === 'mobile' || $device === 'tablet' ? 'MMMMM' : 'MMM'
    xAxis0.get('renderer').grid.template.set('forceHidden', true)

    xAxis1 = chart.xAxes.push(
      am5xy.DateAxis.new(root, {
        baseInterval: {
          timeUnit: 'month',
          count: 1,
        },
        markUnitChange: false,
        startLocation: 0.25,
        renderer: xRenderer,
      }),
    )
    xAxis1.get('dateFormats')['month'] = $device === 'mobile' || $device === 'tablet' ? 'MMMMM' : 'MMM'
    xAxis1.get('renderer').grid.template.set('forceHidden', true)

    // Set Y axes
    let yRenderer = am5xy.AxisRendererY.new(root, {
      minGridDistance: chartProps.minGridDistance,
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
        xAxis: xAxis0,
        yAxis: yAxis,
        valueYField: 'value',
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
    createTooltipSeries(series, root)

    // Add series 2
    let series2 = chart.series.push(
      am5xy.LineSeries.new(root, {
        name: 'Series 2',
        xAxis: xAxis1,
        yAxis: yAxis,
        valueYField: 'value',
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
    createTooltipSeries(series2, root)

    // Set data
    series.data.setAll(dataCurrent)
    series2.data.setAll(dataPrior)

    // Make stuff animate on load
    series.appear(1000)
    series2.appear(1000)
    chart.appear(1000, 100)

    function createTooltipSeries(series, root) {
      let tooltip = am5.Tooltip.new(root, {
        autoTextColor: false,
        getFillFromSprite: false,
        labelHTML: tooltipHTML,
      })
      tooltip.label.setAll({
        fill: am5.color('#FFFFFF'),
      })
      tooltip.get('background').setAll({
        fill: am5.color('#000000'),
      })
      series.set('tooltip', tooltip)
    }
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
      affectsMinMax: true,
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

<div bind:this={container} class={`w-full h-full ${$$props.class}`} data-cy="lineCompareChart" />
