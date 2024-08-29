<script>
  // @ts-nocheck

  export let items = [];
  export let nameProperty = "name";
  export let onSelectItem;
  export let selectedItem = "";
  export let disabled = false;
  export let isInvalidInput = false;
  let isDropdownOpen = false;

  function initTypeahead() {
    const options = {
      source: items,
      displayText: function (item) {
        return item[nameProperty];
      },
      afterSelect: function (item) {
        onSelectItem(item);
        closeDropdown();
      },
    };

    if (jQuery(".typeahead") && jQuery(".typeahead").length) jQuery(".typeahead")?.typeahead("destroy")?.typeahead(options);
    else jQuery(".typeahead")?.typeahead(options);
  }

  function handleChange() {
    checkInputLength();
    isInvalidInput = selectedItem && selectedItem.length > 100;
    if (isInvalidInput) {
      const event = new CustomEvent("typeheadLengthError", { detail: { isInvalidInput } });
      dispatchEvent(event);
    }
  }

  function checkInputLength() {
    isInvalidInput = selectedItem && selectedItem.length > 100;
    if (isInvalidInput) {
      jQuery(".typeahead")?.addClass("is-invalid");
    } else {
      jQuery(".typeahead")?.removeClass("is-invalid");
    }
  }

  function toggleDropdown() {
    if (!isDropdownOpen) {
      isDropdownOpen = !isDropdownOpen;
      removeClickOutsideListener();
    } else {
      addClickOutsideListener();
    }
  }

  function handleItemClick(item) {
    onSelectItem(item);
    closeDropdown();
  }

  function closeDropdown() {
    isDropdownOpen = false;
    removeClickOutsideListener();
  }

  function addClickOutsideListener() {
    document.addEventListener("click", handleOutsideClick);
  }

  function removeClickOutsideListener() {
    document.removeEventListener("click", handleOutsideClick);
  }

  function handleOutsideClick(event) {
    const target = event.target;
    const dropdown = document.querySelector(".dropdown-menu");
    if (!dropdown.contains(target)) {
      closeDropdown();
    }
  }

  jQuery(document).ready(function () {
    initTypeahead();
  });

  $: {
    items && initTypeahead();
    checkInputLength();
  }
</script>

<div class="form-group">
  <div class="dropdown">
    <input
      type="text"
      class="typeahead form-control"
      autocomplete="off"
      spellcheck="false"
      data-cy="typeaheadInputCy"
      bind:value={selectedItem}
      on:keyup={handleChange}
      {disabled}
      on:focus={toggleDropdown}
      on:blur={toggleDropdown}
    />
    {#if items?.length > 0 && isDropdownOpen}
      <div class="dropdown-menu show">
        <div class="dropdown-menu-inner">
          {#each items as item (item[nameProperty])}
            <div
              class="dropdown-item"
              on:click={() => handleItemClick(item)}
              on:keydown={e => {
                if (e.key === "Enter") handleItemClick(item);
              }}
            >
              <span class="item-name">{item[nameProperty]}</span>
            </div>
          {/each}
        </div>
      </div>
    {/if}
  </div>
</div>

<style>
  .form-group {
    position: relative;
  }
  .dropdown {
    position: relative;
    display: inline-block;
  }
  .dropdown-menu {
    position: absolute;
    top: 100%;
    left: 0;
    width: 100%;
    max-width: 200px;
    z-index: 1000;
    display: block;
  }
  .dropdown-menu-inner {
    max-height: 120px;
    overflow-y: auto;
  }
  .dropdown-item {
    white-space: normal;
    word-break: break-word;
    cursor: pointer;
  }
  .dropdown-item .item-name {
    display: block;
  }
</style>
