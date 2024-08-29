import { writable } from "svelte/store";

export const featureFlagStore = writable({
  MPSHEET: true,
  PRJLSTDET: true,
  MARSEG: true,
  JobMatchingBulkEdit: true,
});

export const featureFlags = [
  "PRJLSTDET",
  "MARSEG",
  // "MARSEGMAP",
  // "JOBMAT",
  "MPSHEET",
  // "JOBSUM"
  "JobMatchingBulkEdit",
];
