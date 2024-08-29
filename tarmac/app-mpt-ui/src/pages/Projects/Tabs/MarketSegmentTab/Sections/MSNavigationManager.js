// @ts-nocheck
import { updateKendoDialogStyles } from "components/shared/functions";

export const MSSectionTypes = {
  BLEND: "blendAccordion",
  ERI: "eriAccordion",
  FILTERS: "filtersAccordion",
  CUTS: "selectedCutsAccordion",
  COMBINED_AVERAGE: "combinedAverageAccordion",
};

const MSConfirmationTexts = {
  BLEND: "Blend selections will be lost.",
  ERI: "ERI adjustments will be lost.",
  CUTS: "Selected Cuts selections will be lost.",
};

const confirmationMessage = type => {
  var message =
    (type == MSSectionTypes.BLEND && MSConfirmationTexts.BLEND) ||
    (type == MSSectionTypes.ERI && MSConfirmationTexts.ERI) ||
    (type == MSSectionTypes.CUTS && MSConfirmationTexts.CUTS);

  return message;
};

export const navigateTo = (currentType, typeToNavigate, confirmationRequired) => {
  if (!confirmationRequired) {
    toggleAccordion(typeToNavigate);
    return;
  }

  confirmNavigation(currentType, typeToNavigate);
};

export const closeAllSections = () => {
  Object.keys(MSSectionTypes).forEach(key => {
    var accordionElement = document.getElementById(MSSectionTypes[key]);
    if (accordionElement && !accordionElement.classList.contains("collapsed")) {
      accordionElement.click();
    }
  });
};

function confirmNavigation(currentType, typeToNavigate) {
  jQuery("<div>").attr("id", "kendo-navigation-dialog").appendTo("body");

  jQuery("#kendo-navigation-dialog").kendoDialog({
    title: "Confirmation Required",
    visible: false,
    content: confirmationMessage(currentType),
    actions: [
      {
        text: "Yes",
        action: function () {
          jQuery("#kendo-navigation-dialog").remove();
          toggleAccordion(typeToNavigate);
          return true;
        },
        primary: true,
      },
      {
        text: "No",
        action: function () {
          jQuery("#kendo-navigation-dialog").remove();
          return true;
        },
        primary: true,
      },
    ],
  });

  var dialog = jQuery("#kendo-navigation-dialog").data("kendoDialog");
  dialog.open();
  updateKendoDialogStyles(dialog.element);
}

function toggleAccordion(type) {
  var accordionElement = document.getElementById(type);
  closeAllSections();
  if (accordionElement && accordionElement.classList.contains("collapsed")) {
    accordionElement.click();
  }
}
