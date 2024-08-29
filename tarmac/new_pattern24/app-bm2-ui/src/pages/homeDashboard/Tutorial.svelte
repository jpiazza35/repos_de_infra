<script>
  const name = 'Fernando Ramos'
</script>

<section class="flex items-center justify-between p-7 bg-primary-500 text-white" data-cy="tutorial-container">
  <div />
  <div class="text-center" data-cy="tutorial-topheader">
    <span class="text-xl font-semibold">Benchmark 2.0</span>
    <span class="hidden md:block" data-cy="tutorial-message">Welcome {name}, Vorem ipsum dolor sit amet, consectetur</span>
  </div>

  <button
    type="button"
    class="text-primary-500 bg-primary-300 hover:bg-primary-200 focus:outline-none focus:ring-1 focus:ring-primary-300 font-medium rounded text-base px-3 py-2.5 me-2 mb-2"
    data-modal-target="tutorial-modal"
    data-modal-toggle="tutorial-modal"
    data-cy="tutorial-button">Tutorial</button
  >
</section>
