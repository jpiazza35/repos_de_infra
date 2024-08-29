<script>
  import * as am5 from '@amcharts/amcharts5'
  import * as am5xy from '@amcharts/amcharts5/xy'
  import am5themes_Animated from '@amcharts/amcharts5/themes/Animated'
  import { onMount } from 'svelte'
  import { createTooltipColumnSeries } from 'utils/amcharts'
  import { CHART_COLUMN_COLORS } from 'utils/constants'
  import { device } from 'utils/device'

  /**
   * @typedef {Object} ColumnData
   * @property {string} category
   * @property {number} value
   */

  /** @type {Array<ColumnData>} */
  export let data = []

  /**
   * @type {string}
   */
  export let bulletLabel

  let container

  onMount(() => {
    // Create root element
    let root = am5.Root.new(container)

    // Set themes
    root.setThemes([am5themes_Animated.new(root)])

    // Create chart
    let chart = root.container.children.push(am5xy.XYChart.new(root, {}))

    // Set X axis
    let xRenderer = am5xy.AxisRendererX.new(root, { minGridDistance: 0 })
    xRenderer.labels.template.setAll({
      centerY: am5.p50,
      centerX: am5.p50,
      fill: am5.color('#77777A'),
      fontSize: '0.8em',
      paddingTop: 10,
      rotation: $device == 'mobile' ? -45 : 0,
    })

    let xAxis = chart.xAxes.push(
      am5xy.CategoryAxis.new(root, {
        categoryField: 'category',
        renderer: xRenderer,
      }),
    )
    xAxis.get('renderer').grid.template.set('forceHidden', true)

    // Set Y axis
    let yRenderer = am5xy.AxisRendererY.new(root, {})
    yRenderer.labels.template.set('visible', false)

    let yAxis = chart.yAxes.push(
      am5xy.ValueAxis.new(root, {
        renderer: yRenderer,
      }),
    )
    yAxis.get('renderer').grid.template.set('forceHidden', true)

    // Create series
    let series = chart.series.push(
      am5xy.ColumnSeries.new(root, {
        name: 'series',
        xAxis: xAxis,
        yAxis: yAxis,
        categoryXField: 'category',
        valueYField: 'value',
        sequencedInterpolation: true,
        minBulletDistance: 55,
      }),
    )

    // Add Label bullet
    series.bullets.push(function () {
      return am5.Bullet.new(root, {
        locationY: 1,
        sprite: am5.Label.new(root, {
          text: bulletLabel ? "{valueY.formatNumber('#,###.00')}" + ` ${bulletLabel}` : "{valueY.formatNumber('#,###.00')}",
          fill: am5.color('#77777A'),
          fontSize: '0.8em',
          centerY: am5.p100,
          centerX: am5.p50,
          populateText: true,
        }),
      })
    })

    // Add Tooltips
    createTooltipColumnSeries("{valueY.formatNumber('#,###.00')}", series, root)

    series.columns.template.setAll({
      cornerRadiusTL: 8,
      cornerRadiusTR: 8,
      cornerRadiusBL: 8,
      cornerRadiusBR: 8,
      strokeOpacity: 0,
      tooltipText: '{valueY}',
      tooltipY: 0,
    })
    series.columns.template.adapters.add('fill', function (fill, target) {
      return am5.color(CHART_COLUMN_COLORS[series.columns.indexOf(target)])
    })

    xAxis.data.setAll(data)
    series.data.setAll(data)

    // Make stuff animate on load
    series.appear(1000)
    chart.appear(1000, 100)
  })
</script>

<div bind:this={container} class="w-full h-full" data-cy="columnChart" />
