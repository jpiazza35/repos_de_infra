/* eslint-disable no-unused-vars */
import * as am5 from "@amcharts/amcharts5";
// @ts-ignore
import * as am5xy from "@amcharts/amcharts5/xy";
// @ts-ignore
import * as am5percent from "@amcharts/amcharts5/percent";

// Load license
am5.addLicense(import.meta.env.VITE_AM5_LICENSE_KEY);

/**
 * Set tooltip for line series
 * @param {am5xy.LineSeries} series
 * @param {am5.Root} root
 */
export const createTooltipLineSeries = (series, root) => {
  createTooltipSeries("{valueY.formatNumber('#,###.00')}", series, root);
};

/**
 * Set tooltip for column series
 * @param {string} labelText
 * @param {am5xy.ColumnSeries} series
 * @param {am5.Root} root
 */
export const createTooltipColumnSeries = (labelText, series, root) => {
  createTooltipSeries(labelText, series, root);
};

/**
 * Set tooltip for pie series
 * @param {string} labelText
 * @param {am5percent.PieSeries} series
 * @param {am5.Root} root
 */
export const createTooltipPieSeries = (labelText, series, root) => {
  createTooltipSeries(labelText, series, root);
};

const createTooltipSeries = (labelText, series, root) => {
  let tooltip = am5.Tooltip.new(root, {
    autoTextColor: false, //If we need specific color for tooltip text, we will first need to disable default behavior
    getFillFromSprite: false, //If we need to change background color, we will first need to disable fill inheritance
    labelText: labelText,
  });
  tooltip.label.setAll({
    fill: am5.color("#FFFFFF"),
  });
  tooltip.get("background").setAll({
    fill: am5.color("#000000"),
  });
  series.set("tooltip", tooltip);
};
