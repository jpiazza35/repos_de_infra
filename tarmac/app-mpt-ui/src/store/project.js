import { writable } from "svelte/store";

export const projectVersionStore = writable({
  aggregationMethodologyKey: null,
  fileLogKey: "",
  id: "",
  surveySourceGroupKey: "",
  versionLabel: "",
  organizationName: "",
  projectName: "",
  organizationID: null,
});
