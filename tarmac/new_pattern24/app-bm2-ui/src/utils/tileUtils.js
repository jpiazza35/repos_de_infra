import MarketReportDashboard from '../pages/dashboards/advancedPracticeProvider/AppMarketReportDashboard.svelte'
import BenchmarksDashboard from '../pages/dashboards/physician/BenchmarksDashboard.svelte'
import ProviderAtGlanceDashboard from '../pages/dashboards/physician/ProviderAtGlanceDashboard.svelte'
import PercentileReportDashboard from '../pages/dashboards/physician/PercentileReportDashboard.svelte'
import ClinicalAssessmentDashboard from '../pages/dashboards/physician/ClinicalAssessmentDashboard.svelte'
import MarketPositioningDashboard from '../pages/dashboards/physician/MarketPositioningDashboard.svelte'
import MarketOuterAnalysisDashboard from '../pages/dashboards/physician/MarketOuterAnalysisDashboard.svelte'
import TrendReportDashboard from '../pages/dashboards/physician/TrendReportDashboard.svelte'
import RiskAssessmentDashboard from '../pages/dashboards/physician/RiskAssessmentDashboard.svelte'
import AppBenchmarksDashboard from '../pages/dashboards/advancedPracticeProvider/AppBenchmarksDashboard.svelte'
import AppMarketReportDashboard from '../pages/dashboards/advancedPracticeProvider/AppMarketReportDashboard.svelte'
import OtherMarketOuterAnalysisDashboard from '../pages/dashboards/otherStudies/OtherMarketOuterAnalysisDashboard.svelte'
import tileSpaceship from '/assets/imgs/tiles/tile-spaceship.svg'
import tileStar from '/assets/imgs/tiles/tile-star.svg'
import tileOther from '/assets/imgs/tiles/tile-other.svg'
import { toCamelCase } from './strings'

export const SECTIONS_COMPONENTS = {
  physicianDashboards: {
    marketReport: MarketReportDashboard,
    benchmarks: BenchmarksDashboard,
    providerAtGlance: ProviderAtGlanceDashboard,
    percentileReport: PercentileReportDashboard,
    clinicalFTEAssessment: ClinicalAssessmentDashboard,
    marketPositioning: MarketPositioningDashboard,
    marketOuterAnalysis: MarketOuterAnalysisDashboard,
    trendReport: TrendReportDashboard,
    riskAssessment: RiskAssessmentDashboard,
  },
  appDashboards: {
    appMarketReport: AppMarketReportDashboard,
    appBenchmarks: AppBenchmarksDashboard,
  },
  otherStudiesDashboards: {
    marketOuterAnalysis: OtherMarketOuterAnalysisDashboard,
  },
}
export const DASHBOARD_ROUTES = {
  physicianDashboards: {
    marketReport: '/physician/marketReport',
    benchmarks: '/physician/benchmarks',
    providerAtGlance: '/physician/providerAtGlance',
    percentileReport: '/physician/percentileReport',
    clinicalFTEAssessment: '/physician/clinicalFTEAssessment',
    marketPositioning: '/physician/marketPositioning',
    marketOuterAnalysis: '/physician/marketOuterAnalysis',
    trendReport: '/physician/trendReport',
    riskAssessment: '/physician/riskAssessment',
  },
  appDashboards: {
    appMarketReport: '/app/marketReport',
    appBenchmarks: '/app/benchmarks',
  },
  otherStudiesDashboards: {
    marketOuterAnalysis: '/otherStudies/benchmarks',
  },
}
export const ICONS = {
  SPACESHIP: 'tile-spaceship',
  STAR: 'tile-star',
  OTHER: 'tile-other',
}
export const PHYSICIAN_TILES = [
  {
    title: 'Market Report',
    icon: getTileIcon(ICONS.SPACESHIP),
    url: DASHBOARD_ROUTES.physicianDashboards.marketReport,
  },
  {
    title: 'Benchmarks',
    icon: getTileIcon(ICONS.SPACESHIP),
    url: DASHBOARD_ROUTES.physicianDashboards.benchmarks,
  },
  {
    title: 'Provider At-A-Glance',
    icon: getTileIcon(ICONS.SPACESHIP),
    url: DASHBOARD_ROUTES.physicianDashboards.providerAtGlance,
  },
  {
    title: 'Percentile Report',
    icon: getTileIcon(ICONS.SPACESHIP),
    url: DASHBOARD_ROUTES.physicianDashboards.percentileReport,
  },
  {
    title: 'Clinical FTE Assessment',
    icon: getTileIcon(ICONS.SPACESHIP),
    url: DASHBOARD_ROUTES.physicianDashboards.clinicalFTEAssessment,
  },
  {
    title: 'Market Positioning',
    icon: getTileIcon(ICONS.SPACESHIP),
    url: DASHBOARD_ROUTES.physicianDashboards.marketPositioning,
  },
  {
    title: 'Market Outer Analysis',
    icon: getTileIcon(ICONS.SPACESHIP),
    url: DASHBOARD_ROUTES.physicianDashboards.marketOuterAnalysis,
  },
  {
    title: 'The Trend Report',
    icon: getTileIcon(ICONS.SPACESHIP),
    url: DASHBOARD_ROUTES.physicianDashboards.trendReport,
  },
  {
    title: 'Risk Assessment',
    icon: getTileIcon(ICONS.SPACESHIP),
    url: DASHBOARD_ROUTES.physicianDashboards.riskAssessment,
  },
]
export const ADVANCED_PRACTICE_PROVIDER_TILES = [
  {
    title: 'Market Report',
    icon: getTileIcon(ICONS.STAR),
    url: DASHBOARD_ROUTES.appDashboards.appMarketReport,
  },
  {
    title: 'Benchmarks',
    icon: getTileIcon(ICONS.STAR),
    url: DASHBOARD_ROUTES.appDashboards.appBenchmarks,
  },
]
export const OTHER_STUDIES_TILES = [
  {
    title: 'On-Call',
    icon: getTileIcon(ICONS.OTHER),
    url: import.meta.env.VITE_PAY_PRACTICE_URL || '',
  },
]

export const ALL_TILES = {
  physician: PHYSICIAN_TILES,
  advancedPracticeProvider: ADVANCED_PRACTICE_PROVIDER_TILES,
  otherStudies: OTHER_STUDIES_TILES,
}

export function getTileIcon(icon) {
  switch (icon) {
    case ICONS.OTHER:
      return tileOther
    case ICONS.SPACESHIP:
      return tileSpaceship
    case ICONS.STAR:
      return tileStar
    default:
      return tileSpaceship
  }
}

export function setDataCy(element, params) {
  switch (element) {
    case 'container':
      return `tile-${params?.type}-${toCamelCase(params?.title)}`
    case 'icon':
      return setIconDataCy(params?.icon || tileSpaceship)
    case 'title':
      return `${toCamelCase(params?.title) || 'title'}-text-cy`
  }
}

export function setIconDataCy(icon) {
  switch (icon) {
    case tileOther:
      return `icon-${ICONS.OTHER}-cy`
    case tileSpaceship:
      return `icon-${ICONS.SPACESHIP}-cy`
    case tileStar:
      return `icon-${ICONS.STAR}-cy`
  }
}
