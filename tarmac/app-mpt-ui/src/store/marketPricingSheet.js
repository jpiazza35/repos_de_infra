import { writable } from "svelte/store";

export const marketPricingSheetStore = writable({
  headerInfo: null,
  marketPricingSheetID: "",
  clientPositionDetail: null,
  jobMatchDetail: null,
  gridData: [],
  marketSegments: [],
});

export const marketPricingModalStore = writable({
  addExternalData: false,
  addSurveyData: false,
});
