import { writable } from "svelte/store";

function createFilterStore() {
  const { subscribe, set, update } = writable({
    publisherFilter: [],
    yearFilter: [],
    surveyFilter: [],
    industrySectorFilter: [],
    organizationTypeFilter: [],
    cutGroupFilter: [],
    cutSubGroupFilter: [],

    publisherKeys: [],
    surveyKeys: [],
    industrySectorKeys: [],
    organizationTypeKeys: [],
    cutGroupKeys: [],
    cutSubGroupKeys: [],
  });

  return {
    subscribe,
    set,
    update,
    reset: () =>
      set({
        publisherFilter: [],
        yearFilter: [],
        surveyFilter: [],
        industrySectorFilter: [],
        organizationTypeFilter: [],
        cutGroupFilter: [],
        cutSubGroupFilter: [],
        publisherKeys: [],
        surveyKeys: [],
        industrySectorKeys: [],
        organizationTypeKeys: [],
        cutGroupKeys: [],
        cutSubGroupKeys: [],
      }),
  };
}

export const filterStore = createFilterStore();

export const cutNamesStore = writable([]);

export const unsavedMarketSegmentStore = writable(false);

function createMarketSegmentStore() {
  const { subscribe, set, update } = writable({
    id: null,
    isProjectStatusFinal: false,
    isEditing: false,
    marketSegmentName: "",
    marketSegmentDescription: "",
    marketSegment: null,
    selectionCuts: [],
  });

  return {
    subscribe,
    set,
    update,
    reset: () =>
      set({
        id: null,
        isProjectStatusFinal: false,
        isEditing: false,
        marketSegmentName: "",
        marketSegmentDescription: "",
        marketSegment: null,
        selectionCuts: [],
      }),
  };
}

export const marketSegmentStore = createMarketSegmentStore();

export const marketSegmentListStore = writable([]);
