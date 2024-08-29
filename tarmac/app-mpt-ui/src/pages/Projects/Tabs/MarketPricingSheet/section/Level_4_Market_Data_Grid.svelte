<script>
  import { onMount, createEventDispatcher } from "svelte";
  import {
    getSurveyGridColumns,
    getMandatoryColumns,
    getPercentileValues,
    getAdjustmentNoteLookUp,
    getGridItemsForSheet,
    saveGridItems,
    getMarketSegmentCombinedAverageInfo,
    getMarketSegmentsInfo,
  } from "../apiMarketPricingCalls.js";
  import { getDefaultBenchmarks, showErrorMessage, showSuccessMessage } from "../marketPricingCommon.js";
  import { YEARFRAC } from "utils/functions";
  import Loading from "components/shared/loading.svelte";
  import { marketPricingSheetStore } from "store/marketPricingSheet.js";
  import { BENCHMARK_IDS_WITH_PERCENTAGE_FORMAT, BENCHMARK_IDS_WITH_DECIMAL_POSITIONS } from "utils/constants";

  export let marketSegments = [];
  export let marketPricingSheetID = 0;
  export let globalSettings = null;
  export let benchmarks = [];
  export let projectVersion = 0;
  export let myFilters = null;
  export let adjustmentNotes = null;
  export let sheetName = null;
  export let jobMatchNotes = "";
  let percentileWidth = 105;
  let defaultGridHeight = 480;
  let hasData = false;
  let adjustmentNoteLookUp = null;
  let gridOriginalCleanData = null;
  export let savePayloadQueue = {};
  let adjustmentGridList = [];
  let mainGridData = [];
  const dispatch = createEventDispatcher();
  let gridLoading = false,
    gridFooterLoading = false;
  $: isLoading = gridLoading || gridFooterLoading;
  $: HasAdjustment = adjustmentGridList != null && adjustmentGridList.length > 0 && adjustmentGridList.some(item => item != 0);
  let marketSegmentNames = [];
  onMount(async () => {
    setTimeout(async () => {
      AdjustGridWidth();
      gridLoading = true;
      await ConfigureGrid();
      await ConfigureFooterGrid();
      gridLoading = false;

      SettingsChanged(globalSettings);
      let notes = await getAdjustmentNoteLookUp();

      adjustmentNotes = [];
      notes[0].forEach(item => {
        adjustmentNotes.push(item.name);
      });

      adjustmentNoteLookUp = notes[0];
    }, 100);
  });

  // data you want in the grid
  let container = null,
    containerFooter = null;

  const getSelectedableColumn = () => {
    let gridColumns = [];

    gridColumns = [
      {
        //template: '<input type="checkbox" #= excludeInCalc ? \'checked="checked"\' : "" # class="chkbx chkMSPRow k-checkbox k-checkbox-md k-rounded-md" />',
        //attributes: { class: "k-text-center" },
        selectable: true,
        width: "50px",
        locked: true,
        lockable: true,
        headerTemplate: '<span style="margin-left: -12px;">Exclude</span>',
      },
    ];

    return gridColumns;
  };

  export const getKendoGridFooterColumns = () => {
    let gridColumns = [];
    let percentileValues = getPercentileValues(null);

    gridColumns = [
      {
        selectable: false,
        width: "50px",
        locked: true,
        lockable: true,
      },
      {
        field: "Desc",
        width: 1850,
      },
    ];

    benchmarks.forEach(item => {
      percentileValues.forEach(pItem => {
        const fieldName = "Field_" + item.Value + "_" + pItem.Text;
        let column = {
          field: fieldName,
          title: `${pItem.Text}th`,
          width: percentileWidth,
          format: "{0:c2}",
          attributes: { class: "numbers" },
          template: function (dataItem) {
            return dataItem[fieldName] === "---"
              ? "<span title='No Survey Data' style='cursor: pointer;'>" + kendo.htmlEncode(dataItem[fieldName]) + "</span>"
              : kendo.htmlEncode(dataItem[fieldName]);
          },
        };

        gridColumns.push(column);
      });
    });

    return gridColumns;
  };

  const getBenchmarkGridColumns = () => {
    let gridColumns = [];
    let percentileValues = getPercentileValues(null);

    benchmarks.forEach(item => {
      let bColumn = { title: item.Text, columns: [] };

      percentileValues.forEach(pItem => {
        const fieldName = `Field_${item.Value}_${pItem.Text}`;
        let column = {
          field: fieldName,
          title: pItem.Text + "th",
          width: percentileWidth,
          format: "{0:c2}",
          attributes: { class: "numbers" },
          template: function (dataItem) {
            return dataItem[fieldName] === "---"
              ? "<span title='No Survey Data' style='cursor: pointer;'>" + kendo.htmlEncode(dataItem[fieldName]) + "</span>"
              : kendo.htmlEncode(dataItem[fieldName]);
          },
        };

        bColumn.columns.push(column);
      });

      gridColumns.push(bColumn);
    });

    return gridColumns;
  };

  const getKendoGridColumns = () => {
    let gridColumns = [];
    let surveyGridColumns = getSurveyGridColumns();
    let benchmarkGridColumns = getBenchmarkGridColumns();
    let selectedableColumn = getSelectedableColumn();

    selectedableColumn.forEach(item => {
      gridColumns.push(item);
    });

    surveyGridColumns.forEach(item => {
      gridColumns.push(item);
    });

    benchmarkGridColumns.forEach(item => {
      gridColumns.push(item);
    });

    return gridColumns;
  };

  let columnsSettings = getKendoGridColumns();
  let footerSettings = getKendoGridFooterColumns();
  let mandatoryColumns = getMandatoryColumns();
  let fields = {};
  export let showExcludedCutsLocal = true;

  columnsSettings.forEach(function (item) {
    if (item.selectable == undefined || item.selectable == false) {
      let editable = false;

      if (item.field != undefined) {
        if (item.field == "adjustmentNotes") {
          item.editor = AdjustmentNotesEditor;
          item.template = "#= adjustmentNotes.join(', ') #";
          editable = true;
        } else if (item.field == "adjustment") {
          item.editor = AdjustmentEditor;
          item.template = '#=kendo.format("{0:p0}", adjustment / 100)#';
          editable = true;
        }

        fields[item.field] = {
          editable: editable,
          nullable: true,
        };
      } else {
        if (item.columns != undefined && item.columns.length > 0) {
          item.headerAttributes = { style: "justify-content: center" };
          item.columns.forEach(function (subItem) {
            subItem.headerAttributes = { style: "justify-content: center" };
            fields[subItem.field] = {
              editable: editable,
              nullable: true,
            };
          });
        }
      }
    }
  });

  addEventListener("JobNotesChanged", async e => {
    e.preventDefault();
    jobMatchNotes = e.detail.text();
    Object.keys(savePayloadQueue).forEach(key => {
      let oItem = savePayloadQueue[key];

      saveGridItemInfo(
        oItem.rawDataKey,
        oItem.marketSegmentCutDetailKey,
        oItem.excludeInCalc,
        oItem.adjustment,
        oItem.adjustmentNotes,
        oItem.cutExternalKey,
      );
    });

    savePayloadQueue = {};
  });

  function AdjustmentEditor(container, options) {
    let uid = container.parent().attr("data-uid");
    let editorCell = jQuery("#mpDataDetail div.k-grid-content-locked tr[data-uid='" + uid + "']");
    let checkboxChecked = editorCell.find("input[type=checkbox]").prop("checked");

    if (checkboxChecked) return true;

    let adjustControl = jQuery("<input data-bind='value :adjustment'/>").appendTo(container);
    adjustControl.blur(async function (inputKendo) {
      let tr = jQuery(inputKendo.target).closest("tr");
      let grid = jQuery("#mpDataDetail").data("kendoGrid");

      let myItem = grid.dataItem(tr);
      let dataUID = tr.attr("data-uid");
      let trFixed = jQuery("tr[data-uid='" + dataUID + "']")[0];
      let excludeInCalc = jQuery(trFixed).find(".k-checkbox").prop("checked");

      CalculateGridValues();

      if (jQuery("#jobMatchNotes").val().trim().length == 0) {
        showErrorMessage("Error: Unable to save, Job Match Adjustment Notes is required.");

        savePayloadQueue[myItem.rawDataKey + "-" + myItem.marketSegmentCutDetailKey] = {
          rawDataKey: myItem.rawDataKey,
          marketSegmentCutDetailKey: myItem.marketSegmentCutDetailKey,
          excludeInCalc: excludeInCalc,
          adjustment: parseInt(jQuery(inputKendo.target).val()),
          adjustmentNotes: myItem.adjustmentNotes,
        };
      } else {
        await saveGridItemInfo(
          myItem.rawDataKey,
          myItem.marketSegmentCutDetailKey,
          excludeInCalc,
          parseFloat(jQuery(inputKendo.target).val()) / 100,
          myItem.adjustmentNotes,
          myItem.cutExternalKey,
        );
      }
    });
    adjustControl.kendoNumericTextBox({
      format: "#",
      decimals: 0,
      step: 1.0,
      min: -50,
      max: 50,
      value: options.model.Adjustment,
    });
  }

  function AdjustmentNotesEditor(container) {
    let uid = container.parent().attr("data-uid");
    let editorCell = jQuery("#mpDataDetail div.k-grid-content-locked tr[data-uid='" + uid + "']");
    let checkboxChecked = editorCell.find("input[type=checkbox]").prop("checked");

    if (checkboxChecked) return true;

    jQuery("<select multiple='multiple' data-bind='value :adjustmentNotes'/>")
      .appendTo(container)
      .kendoMultiSelect({
        dataSource: { data: adjustmentNotes },
        maxSelectedItems: 3,
      })
      .blur(async function (selectKendo) {
        let tr = jQuery(selectKendo.target).closest("tr");
        let grid = jQuery("#mpDataDetail").data("kendoGrid");

        let myItem = grid.dataItem(tr);
        let dataUID = tr.attr("data-uid");
        let trFixed = jQuery("tr[data-uid='" + dataUID + "']")[0];
        let excludeInCalc = jQuery(trFixed).find(".k-checkbox").prop("checked");
        if (myItem.adjustment !== 0 && jQuery("#jobMatchNotes").val().trim().length == 0) {
          showErrorMessage("Error: Unable to save, Job Match Adjustment Notes is required.");

          savePayloadQueue[myItem.rawDataKey + "-" + myItem.marketSegmentCutDetailKey] = {
            rawDataKey: myItem.rawDataKey,
            marketSegmentCutDetailKey: myItem.marketSegmentCutDetailKey,
            excludeInCalc: excludeInCalc,
            adjustment: parseInt(jQuery(selectKendo.target).val()),
            adjustmentNotes: myItem.adjustmentNotes,
          };
        } else {
          await saveGridItemInfo(
            myItem.rawDataKey,
            myItem.marketSegmentCutDetailKey,
            excludeInCalc,
            myItem.adjustment / 100,
            myItem.adjustmentNotes,
            myItem.cutExternalKey,
          );
        }
      });
  }

  // function RefreshFooterWidth() {
  //   jQuery("#mpDataDetailFooter .k-grid-content table").css("width", jQuery("#mpDataDetail .k-grid-content table").css("width"));
  // }

  const GetGridData = async () => {
    let [myGridData, myGridDataError] = await getGridItemsForSheet(projectVersion, marketPricingSheetID);
    marketPricingSheetStore.update(state => {
      return {
        ...state,
        gridData: myGridData,
      };
    });

    if (myGridDataError != undefined && myGridDataError.message != undefined) {
      gridLoading = false;
      showErrorMessage("Error: Failed to load grid data.");
      return;
    }

    let gridOriginalData = myGridData;
    let gridCleanData = [];
    hasData = gridOriginalData.length > 0;
    let percentileValues = getPercentileValues(null);

    gridOriginalData.forEach(item => {
      let cleanItem = {};
      let adjustment = item.adjustment;

      Object.keys(item).forEach(key => {
        if (key == "benchmarks") {
          item[key].forEach(bItem => {
            let agingFactor = bItem.agingFactor;
            let x = 1 + agingFactor;
            let a = item.surveyDataEffectiveDate < globalSettings.AgeToDate ? 1 : -1;
            let b = YEARFRAC(item.surveyDataEffectiveDate, globalSettings.AgeToDate);

            // @ts-ignore
            let y = a * b;
            let agedValue = Math.pow(x, y);
            // benchmark ids that needs to format to 2 decimals in grid
            const decimalPosition = BENCHMARK_IDS_WITH_DECIMAL_POSITIONS.includes(bItem.id) ? 2 : 0;
            let prefix = "";
            let suffix = "";

            if (BENCHMARK_IDS_WITH_PERCENTAGE_FORMAT.includes(bItem.id)) {
              prefix = "";
              suffix = "%";
            } else {
              prefix = "$";
              suffix = "";
            }

            if (bItem.percentiles) {
              bItem.percentiles.forEach(percentile => {
                adjustment = adjustment ? adjustment : 0;
                let agedMarketValue = agedValue * percentile.marketValue;

                cleanItem["Field_" + bItem.id + "_" + percentile.percentile] =
                  percentile.marketValue === null
                    ? "---"
                    : prefix +
                      Number((1 + adjustment) * agedMarketValue)
                        .toFixed(decimalPosition)
                        .toString()
                        .replace(/\B(?=(\d{3})+(?!\d))/g, ",") +
                      suffix;
                cleanItem["Field_" + bItem.id + "_" + percentile.percentile + "_ORG"] = agedMarketValue;
              });
            } else {
              percentileValues.forEach(pItem => {
                cleanItem["Field_" + bItem.id + "_" + pItem.Text] = "---";
                cleanItem["Field_" + bItem.id + "_" + pItem.Text + "_ORG"] = "---";
              });
            }
          });
        } else {
          cleanItem[key] = item[key];
        }
      });

      cleanItem.adjustment = adjustment * 100;
      gridCleanData.push(cleanItem);
    });

    gridOriginalCleanData = JSON.parse(JSON.stringify(gridCleanData));
    return gridCleanData;
  };

  const SendFooterNotes = gdata => {
    if (gdata && gdata.length > 0) {
      let footerNotes = [];

      gdata.forEach(item => {
        if (item.footerNotes) {
          footerNotes.push(item.footerNotes);
        }
      });

      dispatchEvent(new CustomEvent("FooterNotesChanged", { detail: footerNotes }));
    }
  };

  const saveGridItemInfo = async (rawDataKey, marketSegmentCutDetailKey, excludeCalc, adjustment, adjustmentNotesSelected, cutExternalKey) => {
    adjustment = adjustment ? adjustment : 0;
    adjustmentNotesSelected = adjustmentNotesSelected ? adjustmentNotesSelected : [];
    let adjustmentNotesLoad = [];

    adjustmentNotesSelected.forEach(item => {
      adjustmentNoteLookUp.forEach(aItem => {
        if (aItem.name == item) {
          adjustmentNotesLoad.push(aItem.id);
        }
      });
    });

    let data = {
      RawDataKey: rawDataKey,
      ExcludeInCalc: excludeCalc,
      AdjustmentValue: adjustment,
      AdjustmentNotesKey: adjustmentNotesLoad,
      MarketPricingSheetId: marketPricingSheetID,
      MarketSegmentCutDetailKey: marketSegmentCutDetailKey,
      CutExternalKey: cutExternalKey,
    };

    let payload = {
      data: data,
      projectVersion: projectVersion,
      marketPricingSheetID: marketPricingSheetID,
    };

    saveGridItems(payload)
      .then(() => {
        dispatchEvent(new Event("UpdateLastSave"));
        showSuccessMessage("Data saved successfully.");
      })
      .catch(() => {
        showErrorMessage("Error: Unable to save data.");
        RefreshGridData();
      });
  };

  function CalculateGridValues() {
    setTimeout(function () {
      let grid = jQuery("#mpDataDetail").data("kendoGrid");
      let myGridData = grid.dataSource.data();

      myGridData.forEach(item => {
        let myItem = item;

        Object.keys(myItem).forEach(key => {
          if (key.startsWith("Field_")) {
            const benchmarkId = Number(key.split("_")[1]);
            let prefix = "";
            let suffix = "";

            if (BENCHMARK_IDS_WITH_PERCENTAGE_FORMAT.includes(benchmarkId)) {
              prefix = "";
              suffix = "%";
            } else {
              prefix = "$";
              suffix = "";
            }

            const decimalPosition = BENCHMARK_IDS_WITH_DECIMAL_POSITIONS.includes(benchmarkId) ? 2 : 0;

            const row = gridOriginalCleanData.find(item => item.rawDataKey == myItem.rawDataKey);
            myItem[key] =
              row[key] === "---"
                ? "---"
                : prefix +
                  Number(row[key + "_ORG"] * (1 + item.adjustment / 100))
                    .toFixed(decimalPosition)
                    .toString()
                    .replace(/\B(?=(\d{3})+(?!\d))/g, ",") +
                  suffix;
            mainGridData.find(item => item.rawDataKey == myItem.rawDataKey)[key] = myItem[key];
          }
        });
      });

      grid.refresh();

      RefreshFooterGridData();
    }, 5);
  }

  const GetFooterAverageData = async () => {
    let averageData = [];

    var dataOnCurrentPage = mainGridData;
    let footerRowIndex = 0;
    let averages = [];
    let fields = [];

    //Calculate Combined Average
    let marketSegmentID = 0;
    marketSegments.forEach(cnp => {
      if (cnp.Title == sheetName) {
        marketSegmentID = cnp.ID;
      }
    });

    dataOnCurrentPage.forEach(myItem => {
      //Do not include in calc
      if (!myItem.excludeInCalc) {
        //Get rows by cut name
        let mscName = myItem.marketSegmentCutName ? myItem.marketSegmentCutName : "";
        let msn = { marketSegmentCutName: mscName };

        let found = false;
        let poulateFields = fields.length > 0 ? false : true;

        Object.keys(myItem).forEach(key => {
          if (key.startsWith("Field_") && !key.endsWith("_ORG")) {
            if (poulateFields) {
              fields.push(key);
            }

            msn[key] = [];
          }
        });

        averages.forEach(item => {
          if (item.marketSegmentCutName == myItem.marketSegmentCutName) {
            found = true;
            msn = item;
          }
        });

        fields.forEach(key => {
          if (msn[key] != undefined) {
            msn[key].push(myItem[key]);
          }
        });

        if (!found) averages.push(msn);
      }
    });

    averages.forEach(item => {
      footerRowIndex++;
      let averageItem = { Desc_ID: footerRowIndex, Desc: item.marketSegmentCutName + " Average:", Cut_Name: item.marketSegmentCutName };

      fields.forEach(key => {
        let sum = 0;
        let count = 0;

        if (item[key] != undefined) {
          item[key].forEach(value => {
            if (value !== "---") {
              sum += value;
              count++;
            }
          });
        }

        if (sum == 0 || count == 0) {
          averageItem[key] = 0;
        } else {
          averageItem[key] = sum / count;
        }

        if (sum == 0 && count == 0) {
          averageItem[key] = "---";
        }
      });
      averageData.push(averageItem);
    });

    //National ERI Average
    let msResult = [];

    if (projectVersion) {
      if (marketSegmentNames[projectVersion] == null) {
        msResult = await getMarketSegmentsInfo(projectVersion);
        marketSegmentNames[projectVersion] = msResult;
      } else msResult = marketSegmentNames[projectVersion];
    }

    let margetSegments = msResult.filter(item => item.name == sheetName);

    if (margetSegments && margetSegments.length == 1) {
      let eriFactor = margetSegments[0].eriAdjustmentFactor;
      let eriCutName = margetSegments[0].eriCutName;

      if (eriFactor && eriCutName) {
        averages.forEach(item => {
          if (item.marketSegmentCutName.toLowerCase() == "national") {
            footerRowIndex++;
            let averageItem = { Desc_ID: footerRowIndex, Desc: eriCutName + " (" + eriFactor + ")" };

            fields.forEach(key => {
              let sum = 0;
              let count = 0;

              item[key].forEach(value => {
                sum += value;
                count++;
              });

              if (sum == 0 || count == 0) {
                averageItem[key] = 0;
              } else {
                let avgERI = sum / count;
                averageItem[key] = avgERI * eriFactor + avgERI;
              }
            });

            averageData.push(averageItem);
          }
        });
      }
    }

    //Combined average
    if (marketSegmentID > 0) {
      const cnPromiseResult = await getMarketSegmentCombinedAverageInfo(marketSegmentID);

      if (cnPromiseResult) {
        let averageDataClone = [...averageData];

        cnPromiseResult.forEach(cnp => {
          if (cnp && cnp.marketSegmentId) {
            footerRowIndex++;
            let averageItem = { Desc_ID: footerRowIndex, Desc: cnp.name + " Average:" };
            let combinedAvgItem = [];
            let hasData = false;

            if (cnp.cuts) {
              cnp.cuts.forEach(cnpdAvg => {
                averageDataClone.forEach(item => {
                  if (item.Cut_Name == cnpdAvg.name) {
                    combinedAvgItem.push(item);
                    hasData = true;
                  }
                });
              });

              fields.forEach(key => {
                let sum = 0;
                let count = 0;

                combinedAvgItem.forEach(item => {
                  sum += item[key];
                  count++;
                });

                if (sum == 0 || count == 0) {
                  averageItem[key] = 0;
                } else {
                  averageItem[key] = sum / count;
                }
              });
            }

            if (hasData) averageData.push(averageItem);
          }
        });
      }
    }

    return HandleNan(averageData, fields);
  };

  const HandleNan = (averageData, fields) => {
    if (averageData != null && averageData.length > 0) {
      for (let i = 0; i < averageData.length; i++) {
        fields.forEach(function (p) {
          let avd = averageData[i];

          avd[p] = avd[p] ? avd[p] : 0;
        });
      }
    }

    return averageData;
  };

  const RefreshGridData = async () => {
    let kendoGrid = jQuery(container).data("kendoGrid");

    if (kendoGrid) {
      gridLoading = true;
      mainGridData = await GetGridData();
      kendoGrid.dataSource.data(mainGridData);
      SendFooterNotes(mainGridData);
      gridLoading = false;
      RefreshFooterGridData();
    }
  };

  const RefreshFooterGridData = async () => {
    let kendoGrid = jQuery(containerFooter).data("kendoGrid");

    if (kendoGrid) {
      gridFooterLoading = true;
      let averageFooterData = await GetFooterAverageData();

      if (kendoGrid.dataSource != undefined) kendoGrid.dataSource.data(averageFooterData);
      gridFooterLoading = false;
    }
  };

  const ConfigureGrid = async () => {
    if (container != null) {
      mainGridData = await GetGridData();
      SendFooterNotes(mainGridData);

      let dataSource = new kendo.data.DataSource({
        data: mainGridData,
        batch: true,
        schema: {
          model: {
            id: "marketSegmentCutDetailKey",
            fields: fields,
          },
        },
      });

      jQuery(container).kendoGrid({
        dataSource: dataSource,
        navigatable: true,
        height: defaultGridHeight,
        filterable: false,
        sortable: true,
        resizable: true,
        scrollable: true,
        pageable: false,
        columns: columnsSettings,
        editable: true,
        columnResize: function () {
          FixAverageColumnWidth();
        },
        dataBound: async function (e) {
          var grid = e.sender;
          var rows = e.sender.content.find("tr");
          var dataOnCurrentPage = grid.dataSource.view();
          adjustmentGridList = [];

          dataOnCurrentPage.forEach(function (model) {
            if (model.excludeInCalc == true) {
              var uid = model.uid;
              var row = jQuery("tbody tr[data-uid=" + uid + "]");
              grid.select(row);
            }

            if (model.adjustment) {
              adjustmentGridList.push(model.adjustment);
            }
          });

          e.sender.wrapper.find(".k-checkbox").bind("change", async function (chkSelect) {
            let tr = jQuery(chkSelect.target).closest("tr");
            let myItem = grid.dataItem(tr);
            let excludeInCalc = jQuery(chkSelect.target).prop("checked");
            myItem.excludeInCalc = excludeInCalc;

            mainGridData.forEach(item => {
              if (item.marketSegmentCutDetailKey == myItem.marketSegmentCutDetailKey) {
                item.excludeInCalc = excludeInCalc;
              }
            });

            RefreshFooterGridData();
            ChangeExcludedCutUIUpdate();
            await saveGridItemInfo(
              myItem.rawDataKey,
              myItem.marketSegmentCutDetailKey,
              excludeInCalc,
              myItem.adjustment,
              myItem.adjustmentNotes,
              myItem.cutExternalKey,
            );
          });

          var editableCol = [];
          e.sender.wrapper.find(".k-grid-header-wrap thead tr:nth-child(1) th").each(function (index, item2) {
            let item = jQuery(item2);
            var attr = item.attr("data-field");
            if (attr != undefined && (attr == "adjustment" || attr == "adjustmentNotes")) {
              editableCol.push(index);
            }
          });

          rows.each(function (index, row) {
            let itemRow = jQuery(row);
            editableCol.forEach(function (index2) {
              itemRow.children("td:eq(" + index2 + ")").css("background-color", "#d6f0ff");
            });
          });

          setTimeout(() => {
            jQuery("#mpDataDetail .k-grid-header .k-grid-header-locked table thead tr").css("height", "68px");

            if (!showExcludedCutsLocal) jQuery("#mpDataDetail tr.k-selected").hide();

            SetKendoGridHeight();
            dispatch("LoadingComplete");
          }, 50);
        },
      });

      var gridMain = jQuery(container).data("kendoGrid");

      if (gridMain) {
        gridMain.resizable.bind("start", function (e) {
          //first checkbox column
          if (jQuery(e.currentTarget).data("th").data("field") == undefined) {
            e.preventDefault();
            setTimeout(function () {
              gridMain.wrapper.removeClass("k-grid-column-resizing");
              jQuery(document.body).add(".k-grid th").add(".k-grid th .k-link").css("cursor", "");
            });
          }
        });
      }
    }

    RefreshGrid();
  };

  const ConfigureFooterGrid = async () => {
    let averageFooterData = await GetFooterAverageData();

    let dataSourceFooter = new kendo.data.DataSource({
      data: averageFooterData,
      schema: {
        model: {
          id: "Desc_ID",
        },
      },
    });

    jQuery(containerFooter).kendoGrid({
      dataSource: dataSourceFooter,
      navigatable: false,
      filterable: false,
      sortable: false,
      resizable: false,
      scrollable: true,
      pageable: false,
      columns: footerSettings,
      dataBound: async function () {
        SetFooterGridStyle();
        FixAverageColumnWidth();
      },
    });
  };

  export function LayoutChanged() {
    AdjustGridWidth();
  }

  // @ts-ignore
  export const FilterChanged = async filters => {
    myFilters = filters;
    RefreshGridData();

    setTimeout(async function () {
      AdjustGridWidth();
    }, 200);
  };

  export function AdjustGridHeight() {
    jQuery(container).hasClass("fullHeightGrid") ? jQuery(container).removeClass("fullHeightGrid") : jQuery(container).addClass("fullHeightGrid");
  }

  export function ChangeExcludedCuts(showExcludedCuts) {
    showExcludedCutsLocal = showExcludedCuts;
    ChangeExcludedCutUIUpdate();
  }

  export function ChangeExcludedCutUIUpdate() {
    if (showExcludedCutsLocal) jQuery("#mpDataDetail.k-grid .k-selected").show(500);
    else jQuery("#mpDataDetail.k-grid .k-selected").hide(500);
  }

  function RefreshGrid() {
    // var mpDataDetail = jQuery("#mpDataDetail").data("kendoGrid");
    // var mpDataDetailFooter = jQuery("#mpDataDetailFooter").data("kendoGrid");
    // if (mpDataDetail != null) jQuery("#mpDataDetail").data("kendoGrid").refresh();
    // if (mpDataDetailFooter != null) jQuery("#mpDataDetailFooter").data("kendoGrid").refresh();
    jQuery(".k-grid-header").css({
      background: "#808080",
      color: "#fff",
    });
    jQuery(".k-grid-header thead th").css({
      "border-color": "#fff",
    });
    jQuery(".k-grid-header span.k-icon").css({
      color: "#fff",
    });

    SetFooterGridStyle();
    SetKendoGridHeight();
  }

  function SetFooterGridStyle() {
    jQuery("#mpDataDetailFooter .k-grid-header").hide();
    jQuery("#mpDataDetailFooter .k-auto-scrollable").css({
      overflow: "hidden",
    });
    jQuery("#mpDataDetailFooter .k-grid-content table").css("position", "relative");
    jQuery("#mpDataDetailFooter .k-auto-scrollable table tr td").css({
      "background-color": "#e2e2e2",
      "font-weight": "bold",
    });
    jQuery("#mpDataDetailFooter .k-auto-scrollable table tr td:nth-child(1)").css("text-align", "right");
  }

  function AdjustGridWidth() {
    jQuery("#gridHolder").hide();
    let innerWid = jQuery("#divMarketData .card-body").innerWidth();
    jQuery("#gridHolder").css("width", innerWid);
    jQuery("#gridHolder").show();
    RefreshGrid();
  }

  function SetKendoGridHeight() {
    var hGrid = jQuery(window).height() - 250;
    var totalRowsHeight =
      jQuery("#mpDataDetail .k-grid-content table tbody tr").length * jQuery("#mpDataDetail .k-grid-content table tbody tr:nth-child(1)").height();
    if (totalRowsHeight < hGrid - 100) {
      hGrid = totalRowsHeight + 100;

      hGrid = hGrid > defaultGridHeight ? hGrid : defaultGridHeight;
    }
    jQuery("#mpDataDetail").css("height", hGrid - 6);
    jQuery("#mpDataDetail .k-grid-content-locked").css("height", hGrid - 93);
    jQuery("#mpDataDetail .k-grid-content").css("height", hGrid - 76);
  }

  export function SettingsChanged(data) {
    let descWidth = HideShowSurveyCutColumns(data.SurveyCutColumns);

    if (data.Benchmarks && data.Benchmarks.length == 0) {
      let defaultBenchmarks = getDefaultBenchmarks(benchmarks);
      let castedDefaultBenchmarks = [];

      defaultBenchmarks.forEach(item => {
        castedDefaultBenchmarks.push({
          id: item.Value,
          percentiles: item.Percentile,
        });
      });

      HideShowBenchmarkColumns(data.SurveyCutColumns, castedDefaultBenchmarks);
    } else HideShowBenchmarkColumns(data.SurveyCutColumns, data.Benchmarks);

    if (descWidth > 0) {
      jQuery(
        "#mpDataDetailFooter .k-grid-header-wrap table colgroup col:nth-child(1), #mpDataDetailFooter .k-grid-content table colgroup col:nth-child(1)",
      ).css("width", descWidth);
      jQuery("#mpDataDetailFooter .k-grid-content table").css("width", jQuery("#mpDataDetail .k-grid-content table").css("width"));
    }

    jQuery("#mpDataDetail .k-grid-header .k-grid-header-locked table thead tr").css("height", "68px");
    FixAverageColumnWidth();

    //If age changed, then we have to recaculate the values
    if (data.AgeChanged) {
      globalSettings.AgeToDate = data.AgeToDate;
      RefreshGridData();
    } else {
      dispatch("LoadingComplete");
    }
  }

  function HideShowBenchmarkColumns(benchmarkColumns, benchmarks) {
    let grid = jQuery(container).data("kendoGrid");

    if (grid == undefined || grid == null) {
      return 0;
    }

    let showColumns = [];
    benchmarks.forEach(function (benchmark) {
      if (benchmark.percentiles) {
        benchmark.percentiles.forEach(function (field) {
          showColumns.push("Field_" + benchmark.id + "_" + field);
        });
      }
    });

    let gridFooter = jQuery(containerFooter).data("kendoGrid");

    if (gridFooter) {
      grid.columns.forEach(function (item) {
        if (item.columns != undefined && item.columns.length > 0 && item.title != "Survey Cut Details") {
          item.columns.forEach(function (subItem) {
            let field = subItem.field;
            let colVisible = showColumns.indexOf(field) > -1;

            if (colVisible) {
              grid.showColumn(field);
              gridFooter.showColumn(field);
            } else {
              grid.hideColumn(field);
              gridFooter.hideColumn(field);
            }
          });
        }
      });
    }
  }

  function HideShowSurveyCutColumns(columns) {
    let grid = jQuery(container).data("kendoGrid");
    let descWidth = 0;

    if (grid == undefined || grid == null) {
      return 0;
    }

    var allColumns = columns == null || (columns.length == 1 && columns[0] == -1);

    grid.columns.forEach(function (item) {
      if (item.field != undefined && item.field != null) {
        let colVisible = false;
        if (allColumns || columns.includes(item.field)) {
          grid.showColumn(item.field);
          colVisible = true;
        } else {
          if (mandatoryColumns.indexOf(item.field) > -1) {
            grid.showColumn(item.field);
            colVisible = true;
          } else grid.hideColumn(item.field);
        }
        if (colVisible) {
          descWidth += item.width;
        }
      }
    });
    return descWidth;
  }

  function FixAverageColumnWidth() {
    setTimeout(() => {
      let firstColumn = 0;
      let allColumns = [],
        restColumns = [];

      jQuery("#mpDataDetail .k-grid-content table colgroup col").each(function (index, item) {
        allColumns.push(jQuery(item).width());
      });

      let footerLength = jQuery("#mpDataDetailFooter .k-grid-content table colgroup col").length;

      let firstColumnSize = allColumns.length - footerLength;

      for (var i = 0; i < allColumns.length; i++) {
        if (i <= firstColumnSize) {
          firstColumn += allColumns[i];
        } else {
          restColumns.push(allColumns[i]);
        }
      }

      let colList = "<col style='width:" + firstColumn + "px'>";

      for (var j = 0; j < restColumns.length; j++) {
        colList += "<col style='width:" + restColumns[j] + "px'>";
      }

      jQuery("#mpDataDetailFooter .k-grid-content table colgroup").html(colList);
    }, 1);
  }

  var lastScrollLeft = 0;
  document.addEventListener(
    "scroll",
    function (event) {
      if (jQuery(event.target).hasClass("k-grid-content")) {
        // or any other filtering condition
        var documentScrollLeft = jQuery(event.target).scrollLeft();
        if (lastScrollLeft != documentScrollLeft) {
          lastScrollLeft = documentScrollLeft;
          jQuery("#mpDataDetailFooter .k-grid-content table").css("right", lastScrollLeft);
        }
      }
    },
    true /*Capture event*/,
  );

  addEventListener("SidebarToggled", () => {
    setTimeout(() => {
      AdjustGridWidth();
    }, 1);
  });

  $: gridDisplayStyle = hasData ? "inherit" : "none";
</script>

<div id="gridHolder">
  {#if !hasData}
    <div class="nodata">No market data for the standard job matched</div>
  {/if}
  <div style="display: {gridDisplayStyle}">
    <div bind:this={container} id="mpDataDetail" data-cy="mpDataDetailGrid" />
    <div bind:this={containerFooter} id="mpDataDetailFooter" />
  </div>
  <input type="hidden" id="hdnTriggerRowChange" value="0" />
  <input type="hidden" id="hdnHasAdjustment" value={HasAdjustment} />
</div>
{#if isLoading}
  <div class="overlay">
    <Loading {isLoading} />
  </div>
{/if}
<svelte:window on:resize={() => AdjustGridWidth()} />

<style>
  .overlay {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: rgba(0, 0, 0, 0.5);
    z-index: 999;
  }

  .nodata {
    padding: 0px 0px 8px 7px;
    font-weight: bold;
    color: red;
  }

  :global(.fullHeightGrid) {
    height: calc(100%) !important;
  }

  :global(.fullHeightGrid .k-grid-content-locked) {
    height: calc(100% - 25px) !important;
  }

  :global(.fullHeightGrid .k-grid-content) {
    height: calc(100% - 25px) !important;
  }

  :global(#gridHolder .k-grid) {
    font-size: 12px;
  }

  :global(#gridHolder .k-grid td) {
    line-height: 11px;
  }

  :global(.excludeCalc) {
    position: absolute;
    top: 42px;
    left: 0px;
    width: 53px;
    white-space: pre-wrap;
    text-align: center;
  }

  :global(#mpDataDetail td) {
    white-space: nowrap;
  }

  :global(#mpDataDetail th) {
    background: rgb(128, 128, 128) !important;
    color: rgb(255, 255, 255) !important;
  }

  :global(#mpDataDetail.k-grid .k-selected td),
  :global(#mpDataDetail.k-grid .k-selected.k-alt td) {
    text-decoration: line-through;
    background-color: rgba(255, 0, 0, 0.2) !important;
  }

  :global(#mpDataDetail.k-grid .k-grid-header-locked tr th:first-child input) {
    display: none;
  }

  :global(#mpDataDetail.k-grid span.k-dirty) {
    display: none;
  }

  :global(#mpDataDetail .k-grid-header-locked .k-grid-header-table tr th:first-child) {
    border-color: rgb(128, 128, 128) !important;
  }

  :global(#mpDataDetail th .k-svg-icon, #mpDataDetail th .k-svg-icon > svg) {
    fill: white !important;
  }

  :global(#mpDataDetailFooter td) {
    text-overflow: ellipsis;
    white-space: nowrap;
  }

  :global(#mpDataDetail .numbers, #mpDataDetailFooter .numbers) {
    text-align: right;
  }
</style>
