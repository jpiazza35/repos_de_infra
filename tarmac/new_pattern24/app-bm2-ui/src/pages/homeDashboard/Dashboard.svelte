<script>
  import Tile from 'components/Tile/Tile.svelte'
  import Tutorial from './Tutorial.svelte'
  import Banner from './Banner.svelte'
  import { ALL_TILES } from 'utils/tileUtils'
  const { physician, advancedPracticeProvider, otherStudies } = ALL_TILES
</script>

<Tutorial />
<Banner />
<div class="flex sm:flex-row flex-col w-full" data-cy="tutorial-container">
  <section class="float-end w-full lg:w-3/5 bg-primary-200 min-h-56 py-10" aria-label="Physician" data-cy="physician-section">
    <h2 class="sm:float-right float-none 2xl:mr-32 sm:mr-16 ml-auto mr-auto xl:w-[700px] lg:w-[480px] w-[240px] text-2xl text-primary-500">
      Physician
    </h2>
    <div
      class="sm:float-right float-none 2xl:mr-32 sm:mr-16 ml-auto mr-auto xl:w-[700px] lg:w-[480px] w-[240px] grid xl:grid-cols-3 lg:grid-cols-2 grid-cols-1 gap-4"
    >
      <!-- grid-cols-1 md:grid-cols-2 xl:grid-cols-3 -->
      {#each physician as { title, icon, url }}
        <Tile {title} {icon} {url} type={'physician'} />
      {/each}
    </div>
  </section>

  <section class="lg:w-2/5 w-full bg-primary-300 min-h-56 py-10" aria-label="Advanced Practice Provider" data-cy="advanced-practice-provider-section">
    <h2 class="text-2xl 2xl:ml-32 sm:ml-16 ml-auto mr-auto text-center sm:text-left text-primary-500">Advanced Practice Provider</h2>
    <div class="grid 2xl:ml-32 sm:ml-16 ml-auto mr-auto grid-cols-1 xl:grid-cols-2 gap-4 lg:w-[480px] w-[240px]">
      {#each advancedPracticeProvider as { title, icon, url }}
        <Tile {title} {icon} {url} type={'advancedPracticeProvider'} />
      {/each}
    </div>
  </section>
</div>

<div class="flex sm:flex-row flex-col w-full">
  <section class="float-end w-full lg:w-3/5 bg-primary-100 py-10" aria-label="Others" data-cy="other-studies-section">
    <div
      class="sm:float-right float-none 2xl:mr-32 sm:mr-16 ml-auto mr-auto xl:w-[700px] lg:w-[480px] w-[240px] grid xl:grid-cols-3 lg:grid-cols-2 grid-cols-1 gap-4"
    >
      <h2 class="text-2xl whitespace-nowrap text-primary-500 inline sm:hidden">Other Studies</h2>
      {#each otherStudies as { title, icon, url }}
        <Tile {title} {icon} {url} type={'otherStudies'} />
      {/each}
      <div class="sm:grid grid-cols-1 sm:grid-cols-3 lg:grid-cols-5 gap-4 hidden">
        <h2 class="text-2xl whitespace-nowrap text-primary-500 inline">Other Studies</h2>
      </div>
    </div>
  </section>
  <section class="w-full lg:w-2/5 bg-primary-100" aria-label="clean" />
</div>
