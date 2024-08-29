<script>
  import Card from 'components/Card/Card.svelte'
  import ValueCard from 'lib/widgets/ValueCard/ValueCard.svelte'
  import { dollarFormat } from 'utils/strings'
  import { ERROR_COLOR, SUCCESS_COLOR } from 'utils/constants'
  import BarChart from 'lib/charts/Bar/BarChart.svelte'

  /**
   * @typedef SettlementData
   * @type {Object}
   * @property {string} title
   * @property {string} image
   * @property {number} value
   * @property {string} label
   */

  /** @type {Array<SettlementData>} */
  /*export let data = []*/

  /**
   * @type {string}
   */
  export let title = 'Demo Widget'
</script>

<Card cyComponent="settlementCard" cyTitle="settlementTitle" {title}>
  <div class="grid gap-4 desktop:grid-cols-5 laptop:grid-cols-3 tablet:grid-cols-2 mobile:grid-cols-1 mb-4">
    Chart or content goes here
    <BarChart data={[{
  country: "USA",
  value: 2025
}, {
  country: "China",
  value: 1882
}, {
  country: "Japan",
  value: 1809
}, {
  country: "Germany",
  value: 1322
}, {
  country: "UK",
  value: 1122
}, {
  country: "France",
  value: 1114
}, {
  country: "India",
  value: 984
}, {
  country: "Spain",
  value: 711
}, {
  country: "Netherlands",
  value: 665
}, {
  country: "South Korea",
  value: 443
}, {
  country: "Canada",
  value: 441
}]}></BarChart>
  </div>
</Card>
