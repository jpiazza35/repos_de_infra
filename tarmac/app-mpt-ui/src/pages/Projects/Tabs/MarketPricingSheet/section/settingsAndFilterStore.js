import { writable, get } from "svelte/store";

const localState = sessionStorage.getItem("settingsAndFilterState");

const initialState = {
  JobCodeTitle: "",
  JobGroup: [-1],
  MarketSegmentName: [-1],
  LeftMenu: true,
  LeftMainSettingsMenu: false,
  LeftFilterMenu: false,
  LeftPercentileMenu: false,
  MarketPricingSheetID: -1,
  SheetName: "",
  ShowExcludedCuts: true,
  LeftSortByMenu: false,
  SelectedSortByFields: [],
  SortByFields: [],
};

if (!localState) {
  sessionStorage.setItem("settingsAndFilterState", JSON.stringify(initialState));
}

const appState = localState ? JSON.parse(localState) : initialState;

export const SettingFilterState = writable(appState);
export const benchMarkStore = writable([]);
export const UpdateSettingFilter = callback => {
  const updatedState = callback(get(SettingFilterState));

  SettingFilterState.update(() => updatedState);
  sessionStorage.setItem("settingsAndFilterState", JSON.stringify(updatedState));
};
