<script>
  import { width } from 'utils/device'
  import { Router, Route } from 'svelte-routing'
  import 'flowbite'
  import Footer from './components/Footer/Footer.svelte'
  import Navbar from './components/Navbar/Navbar.svelte'
  import { COMPONENTS, ROUTES } from './utils/routes'

  const { DASHBOARD_ROUTES } = ROUTES
  const { physicianDashboards, appDashboards, otherStudiesDashboards } = DASHBOARD_ROUTES
  const {
    physicianDashboards: physicianDashboard,
    appDashboards: appDashboard,
    otherStudiesDashboards: otherStudiesDashboard,
  } = COMPONENTS.SECTIONS_COMPONENTS

  const {
    marketReport: MarketReport,
    benchmarks: Benchmarks,
    providerAtGlance: ProviderAtGlance,
    percentileReport: PercentileReport,
    clinicalFTEAssessment: ClinicalFTEAssessment,
    marketPositioning: MarketPositioning,
    marketOuterAnalysis: MarketOuterAnalysis,
    trendReport: TrendReport,
    riskAssessment: RiskAssessment,
  } = physicianDashboard

  const { appBenchmarks: AdvancedBenchmarks, appMarketReport: AdvancedMarketReport } = appDashboard
  const { marketOuterAnalysis: OtherMarketOuterAnalysis } = otherStudiesDashboard
</script>

<Navbar />
<div class="mt-[69px]" style="min-height: calc(100vh - 69px);">
  <Router>
    <Route path={ROUTES.homeDashboard} component={COMPONENTS.homeDashboard} />

    <!-- Physhician Routes -->
    <Route path={physicianDashboards.marketReport} component={MarketReport} />
    <Route path={physicianDashboards.benchmarks} component={Benchmarks} />
    <Route path={physicianDashboards.providerAtGlance} component={ProviderAtGlance} />
    <Route path={physicianDashboards.percentileReport} component={PercentileReport} />
    <Route path={physicianDashboards.clinicalFTEAssessment} component={ClinicalFTEAssessment} />
    <Route path={physicianDashboards.marketPositioning} component={MarketPositioning} />
    <Route path={physicianDashboards.marketOuterAnalysis} component={MarketOuterAnalysis} />
    <Route path={physicianDashboards.trendReport} component={TrendReport} />
    <Route path={physicianDashboards.riskAssessment} component={RiskAssessment} />

    <!-- Advanced Practice Provider -->
    <Route path={appDashboards.appMarketReport} component={AdvancedMarketReport} />
    <Route path={appDashboards.appBenchmarks} component={AdvancedBenchmarks} />

    <!-- Other Studies -->
    <Route path={otherStudiesDashboards.marketOuterAnalysis} component={OtherMarketOuterAnalysis} />
  </Router>
</div>
<Footer />

<svelte:window bind:innerWidth={$width} />
