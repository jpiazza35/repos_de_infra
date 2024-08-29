export const DefaultFilters = {
  dataScopes: [
    {
      title: "Region Average",
      checked: true,
    },
  ],
  benchmarks: [
    {
      id: 84,
      title: "Hourly Base Pay",
      percentiles: ["25", "50", "75"],
      checked: true,
      selectedPercentiles: ["25", "50", "75"],
      comparisons: [
        {
          id: 84,
          title: "Client Annualized Pay Range Minimum Comparison",
          selectedPercentiles: ["25", "50", "75"],
        },
        {
          id: 79,
          title: "Client Pay Range Maximum Comparison",
          selectedPercentile: ["25", "75"],
        },
      ],
    },
    {
      id: 79,
      title: "Annualized Pay Range Minimum",
      percentiles: ["25", "50", "75"],
      checked: true,
      selectedPercentiles: ["50", "75"],
      comparisons: [
        {
          id: 79,
          title: "Annualized Pay Range Minimum Comparison",
          selectedPercentile: ["25", "75"],
        },
      ],
    },
    {
      title: "Target Annual Incentive",
      percentiles: ["25", "50", "75"],
      checked: true,
      selectedPercentiles: ["25", "75"],
      comparisons: [
        {
          title: "Annualized Pay Range Minimum Comparison",
          selectedPercentiles: ["50", "75"],
        },
      ],
    },
  ],
};

export const mockedJobSummaries = [
  {
    clientJobCode: "2.52",
    clientJobTitle: "Software Developer 2",
    incumbentCount: 12,
    clientPositionCode: "3.001",
    clientPositionCodeDescription: "",
    fteCount: 3,
    marketPricingSheetId: 6,
    benchmarkJobCode: "",
    benchmarkJobTitle: "Software Developer 1 - standard",
    jobMatchAdjustmentNotes: "",
    marketSegment: "market segment test",
    jobGroup: "Group1",
    dataScope: "cut test Average:",
    benchmarks: [
      {
        comparisons: [
          {
            id: 84,
            title: "Client Target Annual Incentive Comparison",
            average: 0,
            ratios: {
              25: "0.100",
              50: "1.200",
              75: "2.000",
              90: "3.000",
            },
          },
          {
            id: 84,
            title: "Client Annualized Pay Range Minimum Comparison",
            average: 1.45,
            ratios: {
              50: "2.000",
            },
          },
          {
            id: 86,
            title: "Client Target Annual Incentiv",
            average: 1.45,
            ratios: {
              50: "0.000",
              75: "0.000",
            },
          },
        ],
        id: 84,
        title: "Market Target Annual Incentive",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 15233.091,
          },
          {
            percentile: 50,
            marketValue: 17838.273,
          },
          {
            percentile: 75,
            marketValue: 18664.727,
          },
          {
            percentile: 90,
            marketValue: 20725.273,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 79,
            title: "Client Annualized Pay Range Minimum Comparison",
            average: 1.45,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 79,
        title: "Market Annualized Pay Range Minimum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 17838.273,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 44,
            title: "Client Pay Range Maximum Comparison",
            average: 0,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 44,
        title: "Market Pay Range Maximum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 17838.273,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 29,
            title: "Client Base Pay Hourly Rate Comparison",
            average: 3.8,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 29,
        title: "Market Base Pay Hourly Rate",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 15233.091,
          },
          {
            percentile: 50,
            marketValue: 17838.273,
          },
          {
            percentile: 75,
            marketValue: 18664.727,
          },
          {
            percentile: 90,
            marketValue: 20725.273,
          },
        ],
      },
    ],
  },
  {
    clientJobCode: "3",
    clientJobTitle: "",
    incumbentCount: 5,
    clientPositionCode: "3.001",
    clientPositionCodeDescription: "",
    fteCount: 5,
    marketPricingSheetId: 12,
    benchmarkJobCode: "1110",
    benchmarkJobTitle: "Family Medicine",
    jobMatchAdjustmentNotes: "",
    marketSegment: "add",
    jobGroup: "",
    dataScope: "ott Average:",
    benchmarks: [
      {
        comparisons: [
          {
            id: 84,
            title: "Client Target Annual Incentive Comparison",
            average: 0,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 84,
        title: "Market Target Annual Incentive",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 100867.336,
          },
          {
            percentile: 50,
            marketValue: 124930.336,
          },
          {
            percentile: 75,
            marketValue: 155517.5,
          },
          {
            percentile: 90,
            marketValue: 186337.5,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 79,
            title: "Client Annualized Pay Range Minimum Comparison",
            average: 2.5,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 79,
        title: "Market Annualized Pay Range Minimum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 124930.336,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 44,
            title: "Client Pay Range Maximum Comparison",
            average: 0,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 44,
        title: "Market Pay Range Maximum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 124930.336,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 29,
            title: "Client Base Pay Hourly Rate Comparison",
            average: 2.35,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 29,
        title: "Market Base Pay Hourly Rate",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 100867.336,
          },
          {
            percentile: 50,
            marketValue: 124930.336,
          },
          {
            percentile: 75,
            marketValue: 155517.5,
          },
          {
            percentile: 90,
            marketValue: 186337.5,
          },
        ],
      },
    ],
  },
  {
    clientJobCode: "3",
    clientJobTitle: "",
    incumbentCount: 5,
    clientPositionCode: "3.001",
    clientPositionCodeDescription: "",
    fteCount: 5,
    marketPricingSheetId: 12,
    benchmarkJobCode: "1110",
    benchmarkJobTitle: "Family Medicine",
    jobMatchAdjustmentNotes: "",
    marketSegment: "add",
    jobGroup: "",
    dataScope: "ERI Adj. National Average (3%):",
    benchmarks: [
      {
        comparisons: [
          {
            id: 84,
            title: "Client Target Annual Incentive Comparison",
            average: 0,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 84,
        title: "Market Target Annual Incentive",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 3026.02,
          },
          {
            percentile: 50,
            marketValue: 3747.91,
          },
          {
            percentile: 75,
            marketValue: 4665.525,
          },
          {
            percentile: 90,
            marketValue: 5590.125,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 79,
            title: "Client Annualized Pay Range Minimum Comparison",
            average: 2.5,
            ratios: {
              50: "0.001",
            },
          },
        ],
        id: 79,
        title: "Market Annualized Pay Range Minimum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 3747.91,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 44,
            title: "Client Pay Range Maximum Comparison",
            average: 0,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 44,
        title: "Market Pay Range Maximum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 3747.91,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 29,
            title: "Client Base Pay Hourly Rate Comparison",
            average: 2.35,
            ratios: {
              25: "0.001",
              50: "0.001",
              75: "0.001",
              90: "0.000",
            },
          },
        ],
        id: 29,
        title: "Market Base Pay Hourly Rate",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 3026.02,
          },
          {
            percentile: 50,
            marketValue: 3747.91,
          },
          {
            percentile: 75,
            marketValue: 4665.525,
          },
          {
            percentile: 90,
            marketValue: 5590.125,
          },
        ],
      },
    ],
  },
  {
    clientJobCode: "3",
    clientJobTitle: "",
    incumbentCount: 5,
    clientPositionCode: "3.001",
    clientPositionCodeDescription: "",
    fteCount: 5,
    marketPricingSheetId: 12,
    benchmarkJobCode: "1110",
    benchmarkJobTitle: "Family Medicine",
    jobMatchAdjustmentNotes: "",
    marketSegment: "add",
    jobGroup: "",
    dataScope: "one Average:",
    benchmarks: [
      {
        comparisons: [
          {
            id: 84,
            title: "Client Target Annual Incentive Comparison",
            average: 0,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 84,
        title: "Market Target Annual Incentive",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 100867.336,
          },
          {
            percentile: 50,
            marketValue: 124930.336,
          },
          {
            percentile: 75,
            marketValue: 155517.5,
          },
          {
            percentile: 90,
            marketValue: 186337.5,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 79,
            title: "Client Annualized Pay Range Minimum Comparison",
            average: 2.5,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 79,
        title: "Market Annualized Pay Range Minimum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 124930.336,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 44,
            title: "Client Pay Range Maximum Comparison",
            average: 0,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 44,
        title: "Market Pay Range Maximum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 124930.336,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 29,
            title: "Client Base Pay Hourly Rate Comparison",
            average: 2.35,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 29,
        title: "Market Base Pay Hourly Rate",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 100867.336,
          },
          {
            percentile: 50,
            marketValue: 124930.336,
          },
          {
            percentile: 75,
            marketValue: 155517.5,
          },
          {
            percentile: 90,
            marketValue: 186337.5,
          },
        ],
      },
    ],
  },
  {
    clientJobCode: "3",
    clientJobTitle: "",
    incumbentCount: 5,
    clientPositionCode: "3.001",
    clientPositionCodeDescription: "",
    fteCount: 5,
    marketPricingSheetId: 12,
    benchmarkJobCode: "1110",
    benchmarkJobTitle: "Family Medicine",
    jobMatchAdjustmentNotes: "",
    marketSegment: "add",
    jobGroup: "",
    dataScope: "two Average:",
    benchmarks: [
      {
        comparisons: [
          {
            id: 84,
            title: "Client Target Annual Incentive Comparison",
            average: 0,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 84,
        title: "Market Target Annual Incentive",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 100867.336,
          },
          {
            percentile: 50,
            marketValue: 124930.336,
          },
          {
            percentile: 75,
            marketValue: 155517.5,
          },
          {
            percentile: 90,
            marketValue: 186337.5,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 79,
            title: "Client Annualized Pay Range Minimum Comparison",
            average: 2.5,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 79,
        title: "Market Annualized Pay Range Minimum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 124930.336,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 44,
            title: "Client Pay Range Maximum Comparison",
            average: 0,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 44,
        title: "Market Pay Range Maximum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 124930.336,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 29,
            title: "Client Base Pay Hourly Rate Comparison",
            average: 2.35,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 29,
        title: "Market Base Pay Hourly Rate",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 100867.336,
          },
          {
            percentile: 50,
            marketValue: 124930.336,
          },
          {
            percentile: 75,
            marketValue: 155517.5,
          },
          {
            percentile: 90,
            marketValue: 186337.5,
          },
        ],
      },
    ],
  },
  {
    clientJobCode: "3",
    clientJobTitle: "",
    incumbentCount: 5,
    clientPositionCode: "3.001",
    clientPositionCodeDescription: "",
    fteCount: 5,
    marketPricingSheetId: 12,
    benchmarkJobCode: "1110",
    benchmarkJobTitle: "Family Medicine",
    jobMatchAdjustmentNotes: "",
    marketSegment: "add",
    jobGroup: "",
    dataScope: "three Average:",
    benchmarks: [
      {
        comparisons: [
          {
            id: 84,
            title: "Client Target Annual Incentive Comparison",
            average: 0,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 84,
        title: "Market Target Annual Incentive",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 100867.336,
          },
          {
            percentile: 50,
            marketValue: 124930.336,
          },
          {
            percentile: 75,
            marketValue: 155517.5,
          },
          {
            percentile: 90,
            marketValue: 186337.5,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 79,
            title: "Client Annualized Pay Range Minimum Comparison",
            average: 2.5,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 79,
        title: "Market Annualized Pay Range Minimum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 124930.336,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 44,
            title: "Client Pay Range Maximum Comparison",
            average: 0,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 44,
        title: "Market Pay Range Maximum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 124930.336,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 29,
            title: "Client Base Pay Hourly Rate Comparison",
            average: 2.35,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 29,
        title: "Market Base Pay Hourly Rate",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 100867.336,
          },
          {
            percentile: 50,
            marketValue: 124930.336,
          },
          {
            percentile: 75,
            marketValue: 155517.5,
          },
          {
            percentile: 90,
            marketValue: 186337.5,
          },
        ],
      },
    ],
  },
  {
    clientJobCode: "3",
    clientJobTitle: "",
    incumbentCount: 5,
    clientPositionCode: "3.001",
    clientPositionCodeDescription: "",
    fteCount: 5,
    marketPricingSheetId: 12,
    benchmarkJobCode: "1110",
    benchmarkJobTitle: "Family Medicine",
    jobMatchAdjustmentNotes: "",
    marketSegment: "add",
    jobGroup: "",
    dataScope: "BLEND TEST Average:",
    benchmarks: [
      {
        comparisons: [
          {
            id: 84,
            title: "Client Target Annual Incentive Comparison",
            average: 0,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 84,
        title: "Market Target Annual Incentive",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 100867.336,
          },
          {
            percentile: 50,
            marketValue: 124930.336,
          },
          {
            percentile: 75,
            marketValue: 155517.5,
          },
          {
            percentile: 90,
            marketValue: 186337.5,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 79,
            title: "Client Annualized Pay Range Minimum Comparison",
            average: 2.5,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 79,
        title: "Market Annualized Pay Range Minimum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 124930.336,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 44,
            title: "Client Pay Range Maximum Comparison",
            average: 0,
            ratios: {
              50: "0.000",
            },
          },
        ],
        id: 44,
        title: "Market Pay Range Maximum",
        agingFactor: null,
        percentiles: [
          {
            percentile: 50,
            marketValue: 124930.336,
          },
        ],
      },
      {
        comparisons: [
          {
            id: 29,
            title: "Client Base Pay Hourly Rate Comparison",
            average: 2.35,
            ratios: {
              25: "0.000",
              50: "0.000",
              75: "0.000",
              90: "0.000",
            },
          },
        ],
        id: 29,
        title: "Market Base Pay Hourly Rate",
        agingFactor: null,
        percentiles: [
          {
            percentile: 25,
            marketValue: 100867.336,
          },
          {
            percentile: 50,
            marketValue: 124930.336,
          },
          {
            percentile: 75,
            marketValue: 155517.5,
          },
          {
            percentile: 90,
            marketValue: 186337.5,
          },
        ],
      },
    ],
  },
];
