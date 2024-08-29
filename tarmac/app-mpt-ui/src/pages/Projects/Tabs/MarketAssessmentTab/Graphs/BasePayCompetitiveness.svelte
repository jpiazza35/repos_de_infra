<script>
  // @ts-nocheck

  import { onMount } from "svelte";
  import * as am5 from "@amcharts/amcharts5";
  import * as AmChartsXY from "@amcharts/amcharts5/xy";
  import am5themes_Animated from "@amcharts/amcharts5/themes/Animated";
  import { createTooltipColumnSeries } from "utils/amcharts";
  import { CHART_COLUMN_COLORS } from "utils/constants";

  let container;

  // Define data
  let data = [
    {
      category: "Less than 1",
      value1: 106,
      value2: 107,
    },
    {
      category: "1-4",
      value1: 108,
      value2: 109,
    },
    {
      category: "4-8",
      value1: 113,
      value2: 120,
    },
    {
      category: "8-15",
      value1: 118,
      value2: 129,
    },
    {
      category: "15-22",
      value1: 123,
      value2: 139,
    },
    {
      category: "22 and more",
      value1: 123,
      value2: 10,
    },
  ];

  onMount(async () => {
    // Initialize the am charts
    let root = am5.Root.new(container);

    // Set themes
    root.setThemes([am5themes_Animated.new(root)]);

    // Create chart
    let chart = root.container.children.push(AmChartsXY.XYChart.new(root, {}));

    // Create X-axis
    let xAxis = chart.xAxes.push(
      AmChartsXY.CategoryAxis.new(root, {
        renderer: AmChartsXY.AxisRendererX.new(root, {}),
        categoryField: "category",
      }),
    );

    // Create Y-axis
    let yAxis = chart.yAxes.push(
      AmChartsXY.ValueAxis.new(root, {
        renderer: AmChartsXY.AxisRendererY.new(root, {}),
        numberFormat: "#'%'",
      }),
    );

    // Create Series
    createSeries(root, chart, xAxis, yAxis, "value1");
    createSeries(root, chart, xAxis, yAxis, "value2");

    xAxis.data.setAll(data);
    chart.appear(1000, 100);
  });

  const createSeries = (root, chart, xAxis, yAxis, valueField) => {
    let series = chart.series.push(
      AmChartsXY.ColumnSeries.new(root, {
        name: "series",
        xAxis: xAxis,
        yAxis: yAxis,
        categoryXField: "category",
        valueYField: valueField,
        sequencedInterpolation: true,
        minBulletDistance: 55,
      }),
    );

    // Add Label bullet
    series.bullets.push(function () {
      return am5.Bullet.new(root, {
        locationY: 1,
        sprite: am5.Label.new(root, {
          text: "{valueY.formatNumber('#')}",
          fill: am5.color("#77777A"),
          fontSize: "0.8em",
          centerY: am5.p100,
          centerX: am5.p50,
          populateText: true,
        }),
      });
    });

    // Add Tooltips
    createTooltipColumnSeries("{valueY.formatNumber(`#,#.00'%'`)}", series, root);

    series.columns.template.setAll({
      cornerRadiusTL: 8,
      cornerRadiusTR: 8,
      cornerRadiusBL: 8,
      cornerRadiusBR: 8,
      strokeOpacity: 0,
      tooltipText: "{valueY}",
      tooltipY: 0,
    });

    series.columns.template.adapters.add("fill", function (fill, target) {
      return am5.color(CHART_COLUMN_COLORS[series.columns.indexOf(target)]);
    });

    series.data.setAll(data);

    // Make stuff animate on load
    series.appear(1000);
  };
</script>

<div class="chart" bind:this={container} data-cy="basePayCompetitivenessGraph" />

<style>
  .chart {
    width: 100%;
    height: 500px;
  }
</style>
