<script>
  // @ts-nocheck
  import { createEventDispatcher } from 'svelte'
  import Fa from 'svelte-fa'
  import { Card } from 'flowbite-svelte'
  import { faAngleLeft } from '@fortawesome/pro-solid-svg-icons'
  import dayjs from 'utils/dayjs'
  import { width } from 'utils/device'
  import SortDropdown from './SortDropdown.svelte'
  import { numberFormat } from 'utils/strings'
  import { device } from 'utils/device'

  /**
   * @type {Date}
   */
  export let selectedDate = new Date()

  /**
   * @typedef {Object} PatientDetailsData
   * @property {string} id
   * @property {string} billingCode
   * @property {string} billingCodeDesc
   * @property {string} billingOrg
   * @property {string} cptCode
   * @property {string} cptMod1
   * @property {string} cptMod2
   * @property {string} cptMod3
   * @property {string} cptMod4
   * @property {string} serviceGroup
   * @property {Date} serviceDate
   * @property {Date} servicePost
   * @property {number} wRVUs
   * @property {number} units
   */

  /** @type {Array<PatientDetailsData>} */
  export let patientDetails = []

  const dispatch = createEventDispatcher()

  const goBack = () => {
    dispatch('goBack')
  }

  const getDaysDiff = patientDetail => {
    return dayjs(patientDetail.servicePost).diff(patientDetail.serviceDate, 'day')
  }

  const getChargeLagBackgroundColor = patientDetail => {
    if (getDaysDiff(patientDetail) >= 3) return 'bg-custom-error-200'
    else if (getDaysDiff(patientDetail) === 2) return 'bg-custom-warning-200'
    else if (getDaysDiff(patientDetail) <= 1) return 'bg-custom-success-200'
  }

  const getChargeLagTextColor = patientDetail => {
    if (getDaysDiff(patientDetail) >= 3) return 'text-custom-error-800'
    else if (getDaysDiff(patientDetail) === 2) return 'text-custom-warning-800'
    else if (getDaysDiff(patientDetail) <= 1) return 'text-custom-success-800'
  }
</script>

<div data-cy="patientDetails">
  <div class="flex flex-wrap items-center justify-between bg-white laptop:px-8 laptop:h-[80px] laptop:py-0 tablet:px-2 mobile:h-[120px] mobile:py-3">
    <span class="text-primary-green-500 font-bold mx-3 text-lg" data-cy="patientDetailsDate">{dayjs(selectedDate).format('MM/DD/YYYY')}</span>
    <SortDropdown />
  </div>

  <div class="py-4 overflow-auto laptop:max-h-[1675px] laptop:px-8 tablet:max-h-[1100px] mobile:px-2">
    {#if $device === 'mobile'}
      <button on:click={goBack} class="flex items-center h-10 ml-2 mb-4">
        <Fa icon={faAngleLeft} scale={1} class="mr-3" />
        Back
      </button>
    {/if}
    {#each patientDetails as patientDetail, index}
      <Card
        class="min-h-[256px] max-w-none rounded-lg items-center mb-3 overflow-hidden shadow-none"
        style={`padding: 16px; min-width: ${$width / 2 - 100}px`}
        data-cy={`patientDetailCard-${index}`}
      >
        <div class="flex justify-between flex-wrap mb-2 w-full">
          <div class="flex flex-wrap mb-2">
            <div
              class="flex flex-wrap items-center bg-custom-neutral-75 rounded mr-2 px-2 laptop:h-[32px] laptop:items-center laptop:flex-row laptop:mb-0 laptop:text-sm mobile:flex-col mobile:mb-2 mobile:text-xs mobile:h-10 mobile:justify-center mobile:items-start"
              data-cy="patientDetailServiceDate"
            >
              <span class="laptop:mr-2">Service Date</span>
              <span class="font-bold">{dayjs(patientDetail.serviceDate).format('MM/DD/YYYY')}</span>
            </div>
            <div
              class="flex flex-wrap items-center bg-custom-neutral-75 rounded mr-2 px-2 laptop:h-[32px] laptop:items-center laptop:flex-row laptop:mb-0 laptop:text-sm mobile:flex-col mobile:mb-2 mobile:text-xs mobile:h-10 mobile:justify-center mobile:items-start"
              data-cy="patientDetailServicePost"
            >
              <span class="laptop:mr-2">Charge Post Date</span>
              <span class="font-bold">{dayjs(patientDetail.servicePost).format('MM/DD/YYYY')}</span>
            </div>
            <div
              class={`${getChargeLagBackgroundColor(
                patientDetail,
              )} flex flex-wrap items-center rounded px-2 laptop:h-[32px] laptop:items-center laptop:text-sm laptop:flex-row mobile:flex-col mobile:text-xs mobile:h-10 mobile:justify-center mobile:items-start`}
              data-cy="patientDetailChargeLag"
            >
              <span class={`${getChargeLagTextColor(patientDetail)} laptop:mr-1.5`}>Charge Lag</span>
              <span class={`${getChargeLagTextColor(patientDetail)} font-bold`}>{getDaysDiff(patientDetail)} days</span>
            </div>
          </div>
          <div class="flex mb-2">
            <div class="flex items-center border border-custom-green-100 h-8 rounded px-2" data-cy="patientDetailwRVUs">
              <span class="text-xs"> wRVUs </span>
              <span class="text-custom-green-600 text-base font-bold ml-2">
                {numberFormat(patientDetail.wRVUs)}
              </span>
            </div>
            <div class="flex items-center border border-custom-green-100 h-8 rounded ml-2 px-2" data-cy="patientDetailUnits">
              <span class="text-xs"> Units </span>
              <span class="text-custom-green-600 text-base font-bold ml-2">
                {patientDetail.units}
              </span>
            </div>
          </div>
        </div>

        <div class="grid tablet:grid-cols-3 mobile:grid-cols-1 gap-2 w-full">
          <div class="flex flex-col border border-custom-neutral-75 p-4 rounded tablet:col-span-2">
            <div class="flex flex-col border-b border-custom-neutral-75 pb-2" data-cy="patientDetailPatient">
              <span class="text-xs text-custom-neutral-500">Patient</span>
              <span class="text-font laptop:text-base mobile:text-sm">{patientDetail.id}</span>
            </div>
            <div class="grid laptop:grid-cols-3 mobile:grid-cols-1 gap-2 pt-4">
              <div class="flex flex-col" data-cy="patientDetailBillingOrg">
                <span class="text-xs text-custom-neutral-500">Billing Organization</span>
                <span class="text-font laptop:text-base mobile:text-sm">{patientDetail.billingOrg}</span>
              </div>
              <div class="flex flex-col col-span-2" data-cy="patientDetailServiceGroup">
                <span class="text-xs text-custom-neutral-500">Service Group</span>
                <span class="text-font laptop:text-base mobile:text-sm">{patientDetail.serviceGroup}</span>
              </div>
              <div class="flex flex-col" data-cy="patientDetailBillingCode">
                <span class="text-xs text-custom-neutral-500">Billing Code</span>
                <span class="text-font laptop:text-base mobile:text-sm">{patientDetail.billingCode}</span>
              </div>
              <div class="flex flex-col col-span-2" data-cy="patientDetailBillingCodeDesc">
                <span class="text-xs text-custom-neutral-500">Billing Code Description</span>
                <span class="text-font laptop:text-base mobile:text-sm">{patientDetail.billingCodeDesc}</span>
              </div>
            </div>
          </div>
          <div class="flex flex-col border border-custom-neutral-75 p-4 rounded">
            <div class="flex flex-col border-b border-custom-neutral-75 pb-2" data-cy="patientDetailCPTCode">
              <span class="text-xs text-custom-neutral-500">CPT Code</span>
              <span class="text-font">{patientDetail.cptCode}</span>
            </div>
            <div class="grid laptop:grid-cols-2 tablet:grid-cols-1 mobile:grid-cols-2 gap-2 pt-4">
              <div class="flex flex-col" data-cy="patientDetailCPTMod1">
                <span class="text-xs text-custom-neutral-500">CPT Mod 1</span>
                <span class="text-font laptop:text-base mobile:text-sm">{patientDetail.cptMod1}</span>
              </div>
              <div class="flex flex-col" data-cy="patientDetailCPTMod2">
                <span class="text-xs text-custom-neutral-500">CPT Mod 2</span>
                <span class="text-font laptop:text-base mobile:text-sm">{patientDetail.cptMod2}</span>
              </div>
              <div class="flex flex-col" data-cy="patientDetailCPTMod3">
                <span class="text-xs text-custom-neutral-500">CPT Mod 3</span>
                <span class="text-font laptop:text-base mobile:text-sm">{patientDetail.cptMod3}</span>
              </div>
              <div class="flex flex-col" data-cy="patientDetailCPTMod4">
                <span class="text-xs text-custom-neutral-500">CPT Mod 4</span>
                <span class="text-font laptop:text-base mobile:text-sm">{patientDetail.cptMod4}</span>
              </div>
            </div>
          </div>
        </div>
      </Card>
    {/each}
  </div>
</div>
