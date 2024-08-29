<script>
  import * as am5 from '@amcharts/amcharts5'
  import * as am5xy from '@amcharts/amcharts5/xy'
  import * as am5radar from '@amcharts/amcharts5/radar'
  import { onMount } from 'svelte'

  /**
   * @typedef {Object} GaugeChartProps
   * @property {string} fontSize
   */

  /**
   * @type {string}
   */
  export let label = 'YES'

  /**
   * @type {number}
   */
  export let value = 50

  /**
   * @type {string}
   */
  export let colorValue = '#61A961'

  /** @type GaugeChartProps */
  export let chartProps = {
    fontSize: '2em',
  }

  let container

  onMount(() => {
    // Create root element
    let root = am5.Root.new(container)

    // Create Chart
    let chart = root.container.children.push(
      am5radar.RadarChart.new(root, { panX: false, panY: false, startAngle: -180, endAngle: 0, innerRadius: -30 }),
    )

    // Set center label
    if (label) {
      let chartLabel = chart.radarContainer.children.push(
        am5.Label.new(root, {
          // @ts-ignore
          fill: colorValue,
          fontWeight: 'bold',
          fontSize: chartProps.fontSize,
          centerX: am5.p50,
          centerY: am5.p100,
        }),
      )
      chartLabel.set('text', label)
    }

    // Create axis renderer
    let axisRenderer = am5radar.AxisRendererCircular.new(root, {})
    axisRenderer.labels.template.set('forceHidden', true)
    axisRenderer.grid.template.set('forceHidden', true)

    // Create axis
    let axis = chart.xAxes.push(
      am5xy.ValueAxis.new(root, {
        min: 0,
        max: 100,
        renderer: axisRenderer,
      }),
    )

    // Init default range
    for (let index = 1; index < 100; index += 2) {
      createRange(index, index + 1, '#E8E8E9')
    }

    // Set value range
    let indexInterval = 1
    let index = 1
    let intervalID = setInterval(() => {
      createRange(index, index + 1, colorValue)
      indexInterval += 1
      index += 2
      if (index > value) clearInterval(intervalID)
    }, 20 * indexInterval)

    function createRange(start, end, color) {
      let rangeDataItem = axis.makeDataItem({
        value: start,
        endValue: end,
      })
      axis.createAxisRange(rangeDataItem)

      rangeDataItem.get('axisFill').setAll({
        visible: true,
        fill: color,
      })
      rangeDataItem.get('tick').setAll({
        visible: false,
      })
    }
  })
</script>

<div bind:this={container} class="w-full h-full" data-cy="gaugeChart" />
