import { writable } from "svelte/store";

export const reportSelectionStore = writable({
  dataScopes: [],
  benchmarks: [],
  jobGroups: [],
  marketSegments: [],
  filterApplied: false,
});

export const marketSummaryTableStore = writable();
