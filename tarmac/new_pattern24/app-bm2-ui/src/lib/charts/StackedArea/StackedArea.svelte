<script>
  import * as am5 from '@amcharts/amcharts5'
  import * as am5xy from '@amcharts/amcharts5/xy'
  import am5themes_Animated from '@amcharts/amcharts5/themes/Animated'
  import { onMount } from 'svelte'
  import { CHART_COLOR_FONT } from 'utils/constants'
  import { device } from 'utils/device'

  /** @type {Array<number>} */
  export let dates = []

  /**
   * @typedef {Object} StakedAreaData
   * @property {Array<number>} values
   * @property {string} name
   * @property {string} color
   */

  /** @type {Array<StakedAreaData>} */
  export let data = []

  let container
  let root
  let chart
  let xAxis
  let yAxis

  onMount(() => {
    // Create root element
    root = am5.Root.new(container)

    // Set themes
    root.setThemes([am5themes_Animated.new(root)])

    // Create chart
    chart = root.container.children.push(am5xy.XYChart.new(root, {}))

    // Add cursor
    var cursor = chart.set(
      'cursor',
      am5xy.XYCursor.new(root, {
        behavior: 'none',
      }),
    )
    cursor.lineY.set('visible', false)
    cursor.lineX.set('visible', false)

    // Set X axis
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
        startLocation: 0.5,
        endLocation: 0.5,
        baseInterval: {
          timeUnit: 'month',
          count: 1,
        },
        markUnitChange: false,
        renderer: xRenderer,
      }),
    )
    xAxis.get('dateFormats')['month'] = $device === 'mobile' ? 'MMMMM' : 'MMM'
    xAxis.get('renderer').grid.template.set('forceHidden', true)

    // Set Y axis
    let yRenderer = am5xy.AxisRendererY.new(root, {})
    yRenderer.labels.template.setAll({
      fill: am5.color(CHART_COLOR_FONT),
      fontSize: '0.8em',
      paddingRight: 10,
    })

    yAxis = chart.yAxes.push(
      am5xy.ValueAxis.new(root, {
        min: 0,
        strictMinMax: true,
        renderer: yRenderer,
      }),
    )
    yAxis.get('renderer').grid.template.set('forceHidden', true)

    // Make stuff animate on load
    chart.appear(1000, 100)
  })

  // Create chart data
  let chartData = []

  // Update the chart data with the values from the data prop
  $: if (data && xAxis && chart) {
    chartData = dates.map(date => {
      return { date }
    })
    data.forEach((item, index) => {
      chartData.forEach((dataItem, dataIndex) => {
        dataItem[`value${index + 1}`] = item.values[dataIndex]
      })
    })

    // Set the xAxis data
    xAxis.data.setAll(chartData)
    // Detele current series
    chart.series.clear()
    // Add series to chart
    data.forEach((item, index) => {
      createSeries(item.name, `value${index + 1}`, item.color)
    })
  }

  // Create series
  const createSeries = (name, field, color) => {
    let series = chart.series.push(
      am5xy.LineSeries.new(root, {
        name: name,
        xAxis: xAxis,
        yAxis: yAxis,
        stacked: true,
        valueYField: field,
        valueXField: 'date',
        fill: am5.color(color),
      }),
    )
    series.fills.template.setAll({
      fillOpacity: 1,
      visible: true,
    })

    // Add tooltip
    let tooltip = am5.Tooltip.new(root, {
      autoTextColor: false,
      getFillFromSprite: false,
      pointerOrientation: 'horizontal',
      labelHTML: `<div style="display: flex; align-items: center">
        <div style="background-color: ${color}; margin-right: 3px; width: 8px; height: 8px"></div>
        <span style="color: white; font-size: 0.8em"><b>{name}</b>: {valueY}</span>
        </div>`,
    })
    tooltip.get('background').setAll({
      fill: am5.color('#000000'),
    })
    series.set('tooltip', tooltip)

    // Add data
    series.data.setAll(chartData)
    series.appear(1000)
  }
</script>

<div bind:this={container} class={`w-full h-full ${$$props.class}`} data-cy="stackedArea" />
