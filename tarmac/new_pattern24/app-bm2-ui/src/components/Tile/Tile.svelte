<script>
  import { Link, Router } from 'svelte-routing'
  import { getTileIcon, setDataCy } from 'utils/tileUtils'

  export let title = 'Market Outer Analysis'
  export let type = 'physician'
  export let icon = getTileIcon('')
  export let url = '/'
</script>

{#if type === 'otherStudies'}
  <a href={url} data-cy={setDataCy('container', { type, title })} target="_blank" rel="noopener noreferrer">
    <div class="w-[220px] bg-white rounded-lg shadow-lg hover:cursor-pointer">
      <div class="flex justify-center items-center py-6 bg-primary-500 rounded-t-lg hover:bg-primary-400">
        <img alt="tile icon" src={icon} data-cy={setDataCy('icon', { icon })} />
      </div>
      <div class="p-3">
        <h5 class="text-sm font-bold tracking-tight text-primary-900" data-cy={setDataCy('title', { title })}>{title}</h5>
      </div>
    </div>
  </a>
{:else}
  <Router>
    <Link to={url} data-cy={setDataCy('container', { type, title })}>
      <div class="w-[220px] bg-white rounded-lg shadow-lg">
        <div class="flex justify-center items-center py-6 bg-primary-500 rounded-t-lg hover:bg-primary-400 hover:cursor-pointer">
          <img alt="tile icon" src={icon} data-cy={setDataCy('icon', { icon })} />
        </div>
        <div class="p-3">
          <h5 class="text-sm font-bold tracking-tight text-primary-900" data-cy={setDataCy('title', { title })}>{title}</h5>
        </div>
      </div>
    </Link>
  </Router>
{/if}
