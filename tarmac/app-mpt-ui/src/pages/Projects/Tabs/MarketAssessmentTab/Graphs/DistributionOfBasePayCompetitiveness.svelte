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
      category: "Below 70%",
      value: 231,
    },
    {
      category: "70% to 80%",
      value: 212,
    },
    {
      category: "80% to 90%",
      value: 432,
    },
    {
      category: "90% to 100%",
      value: 570,
    },
    {
      category: "100% to 110%",
      value: 534,
    },
    {
      category: "110% to 120%",
      value: 338,
    },
    {
      category: "120% to Above%",
      value: 365,
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
      }),
    );

    // Create Series
    // it needs at least one series to display anything
    let series = chart.series.push(
      AmChartsXY.ColumnSeries.new(root, {
        name: "series",
        xAxis: xAxis,
        yAxis: yAxis,
        categoryXField: "category",
        valueYField: "value",
        sequencedInterpolation: true,
        minBulletDistance: 55,
      }),
    );

    // Add Label bullet
    series.bullets.push(function () {
      return am5.Bullet.new(root, {
        locationY: 1,
        sprite: am5.Label.new(root, {
          text: "{valueY.formatNumber('#,###')}",
          fill: am5.color("#77777A"),
          fontSize: "0.8em",
          centerY: am5.p100,
          centerX: am5.p50,
          populateText: true,
        }),
      });
    });

    // Add Tooltips
    createTooltipColumnSeries("{valueY.formatNumber('#,###')}", series, root);

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

    xAxis.data.setAll(data);
    series.data.setAll(data);

    // Make stuff animate on load
    series.appear(1000);
    chart.appear(1000, 100); //appear(duration, delay)
  });
</script>

<div class="chart" bind:this={container} data-cy="distributionOfBasePayChart" />

<style>
  .chart {
    width: 100%;
    height: 500px;
  }
</style>
