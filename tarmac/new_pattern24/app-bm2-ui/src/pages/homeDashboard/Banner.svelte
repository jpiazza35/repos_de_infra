<script>
  import closeIcon from '/assets/imgs/close-icon.svg'
  import downloadIcon from '/assets/imgs/download-icon.svg'

  let showBanner = true
</script>

{#if showBanner}
  <section class="bg-black text-white p-5 flex items-center justify-between mt-1">
    <div />
    <span class="text-sm" data-cy="banner-welcome">
      Welcome to the new and improved Benchmark 2.0.
      <a
        href={'#'}
        data-modal-target="tutorial-modal"
        data-modal-toggle="tutorial-modal"
        data-cy="banner-welcome-click-here"
        class="font-bold hover:underline">Click here to see what's new!</a
      >
    </span>
    <button class="text-lg ml-4" data-modal-target="tutorial-dismiss-modal" data-modal-toggle="tutorial-dismiss-modal">
      <img alt="Close Icon" src={closeIcon} />
    </button>
  </section>
{/if}

<div
  id="tutorial-modal"
  data-modal-backdrop="static"
  tabindex="-1"
  aria-hidden="true"
  class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
  data-cy="tutorial-modal"
>
  <div class="relative p-4 w-full max-w-4xl h-full md:h-auto">
    <!-- Modal content -->
    <div class="relative bg-white shadow">
      <!-- Modal body -->
      <div class="p-6 space-y-6">
        <div class="text-base text-gray-500">Welcome to Benchmark 2.0</div>
        <div class=" border border-solid rounded p-4">
          <p class="text-base text-gray-500">You can always access this tutorial clicking the button "Tutorial" in the Benchmark 2.0 main page.</p>

          <section class="flex items-center justify-between p-7 bg-primary-500 text-white" data-cy="tutorial-container">
            <div />
            <div class="text-center" data-cy="tutorial-topheader">
              <span class="text-xl font-semibold">Benchmark 2.0</span>
              <span class="hidden md:block" data-cy="tutorial-message">Welcome , Vorem ipsum dolor sit amet, consectetur</span>
            </div>

            <span class="p-2 border-solid border-yellow-300 border-4">
              <button
                type="button"
                class="text-primary-500 bg-primary-300 font-medium rounded text-base px-3 py-2.5 cursor-default"
                data-cy="fake-tutorial-button">Tutorial</button
              >
            </span>
          </section>
        </div>

        <!-- PDF download button -->
        <div class="w-full text-right">
          <button
            type="button"
            class="text-white bg-primary-500 hover:bg-primary-600 focus:ring-4 focus:outline-none font-normal rounded text-base px-3 py-2 text-center inline-flex items-center"
            data-cy="tutorial-download-button"
          >
            <img alt="Download Icon" src={downloadIcon} />
            <span class="ml-2">Download</span>
          </button>
        </div>
      </div>
      <!-- Modal footer -->
      <div class="p-6 space-x-2 rounded-b border-t border-gray-200">
        <div class="w-full text-right">
          <button
            type="button"
            data-modal-target="tutorial-modal"
            data-cy="tutorial-close-button"
            data-modal-toggle="tutorial-modal"
            class="text-white bg-primary-500 hover:bg-primary-600 focus:ring-4 focus:outline-none font-normal rounded
             text-base px-3 py-2 text-center inline-flex items-center"
          >
            <img alt="Close Icon" src={closeIcon} />
            <span class="ml-2">Close Tutorial</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</div>

<div
  id="tutorial-dismiss-modal"
  data-modal-backdrop="static"
  tabindex="-1"
  aria-hidden="true"
  class="hidden overflow-y-auto overflow-x-hidden fixed top-0 right-0 left-0 z-50 justify-center items-center w-full md:inset-0 h-[calc(100%-1rem)] max-h-full"
>
  <div class="relative p-4 w-full max-w-2xl h-full md:h-auto">
    <div class="relative bg-white rounded shadow dark:bg-gray-700">
      <div class="flex justify-between items-center p-5 rounded-t border-b dark:border-gray-600">
        <h3 class="text-xl font-medium text-gray-900 dark:text-white" data-cy="confirm-dismiss-title">Tutorial</h3>
      </div>
      <div class="p-6 space-y-6">
        <p class="text-base leading-relaxed text-gray-500 dark:text-gray-400" data-cy="confirm-dismiss-text">
          Are you sure you want to dismiss the tutorial notification? You can always access it by clicking on the button "Tutorial" in the Benchmark
          2.0 main page.
        </p>
        <p class="text-base leading-relaxed text-gray-500 dark:text-gray-400">
          You can also download the tutorial to view later by <a
            href="your-pdf-link.pdf"
            target="blank"
            class="text-primary-600 underline dark:text-primaray-500 first-letter font-bold italic hover:text-primary-800"
            data-cy="confirm-dismiss-click">clicking here</a
          >.
        </p>
      </div>
      <div class="flex justify-end p-6 space-x-2 rounded-b border-t border-gray-200 dark:border-gray-600">
        <button
          data-modal-target="tutorial-dismiss-modal"
          data-modal-toggle="tutorial-dismiss-modal"
          data-cy="confirm-dismiss-no"
          type="button"
          class="text-white bg-primary-700 hover:bg-primary-800 focus:ring-4 focus:ring-primary-300 font-medium rounded text-sm px-5 py-2.5 text-center"
          >No</button
        >
        <button
          data-modal-target="tutorial-dismiss-modal"
          data-modal-toggle="tutorial-dismiss-modal"
          data-cy="confirm-dismiss-yes"
          type="button"
          on:click={() => (showBanner = false)}
          class="text-white bg-primary-600 hover:bg-primary-700 focus:ring-4 focus:ring-primary-300 font-medium rounded text-sm px-5 py-2.5 text-center"
          >Yes, dismiss</button
        >
      </div>
    </div>
  </div>
</div>
