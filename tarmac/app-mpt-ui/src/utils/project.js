export const getAggregationMethodologyName = key => (key === 1 ? "Parent" : "Child");

export const getMarketSegmentStoreCuts = marketSegmentStore => {
  const { marketSegment, selectionCuts } = marketSegmentStore;

  let allCuts = [];
  if (marketSegment && marketSegment.cuts?.length) {
    const marketSegmentCutKeyLastId = marketSegment.cuts ? marketSegment.cuts[marketSegment.cuts.length - 1].marketSegmentCutKey : 0;
    let selectionCutsFiltered = selectionCuts.filter(
      sCut =>
        !marketSegment.cuts.some(
          mCut =>
            sCut.industrySectorKeys.some(indKey => indKey === mCut.industrySectorKey) &&
            sCut.organizationTypeKeys.some(orgKey => orgKey === mCut.organizationTypeKey) &&
            sCut.cutGroupKeys.some(cutKey => cutKey === mCut.cutGroupKey) &&
            sCut.cutSubGroupKeys.some(cutSubKey => cutSubKey === mCut.cutSubGroupKey),
        ),
    );
    selectionCutsFiltered = selectionCutsFiltered.map((sCut, index) => ({ ...sCut, marketSegmentCutKey: marketSegmentCutKeyLastId + index + 1 }));
    allCuts = marketSegment.cuts.concat(selectionCutsFiltered);
  } else {
    allCuts = selectionCuts;
  }
  return allCuts;
};
