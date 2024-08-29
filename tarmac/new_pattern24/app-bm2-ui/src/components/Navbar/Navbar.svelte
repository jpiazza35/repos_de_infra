<script>
  import { ROUTES } from '../../utils/routes'
  import logo from 'assets/imgs/logo.svg'
  import hamburger from 'assets/imgs/navbar/hamburguer.svg'
  import robot from 'assets/imgs/navbar/robot.svg'
  import dropdown from 'assets/imgs/navbar/dropdown.svg'
  import editProfile from 'assets/imgs/navbar/edit-profile.svg'
  import notificationSettings from 'assets/imgs/navbar/notification-settings.svg'
  import logout from 'assets/imgs/navbar/logout.svg'
  import accountSettings from 'assets/imgs/navbar/account-settings.svg'

  document.addEventListener('DOMContentLoaded', event => {
    const toggleButton = document.querySelector('[data-cy="button-open-sidebar"]')
    const sidebar = document.getElementById('logo-sidebar')

    toggleButton.addEventListener('click', () => {
      sidebar.classList.toggle('translate-x-full')
      sidebar.classList.toggle('translate-x-0')
    })
  })
</script>

<nav class="fixed top-0 z-50 w-full bg-white border-b border-primary-200 dark:bg-primary-800 dark:border-primary-700" data-cy="landing-navbar">
  <div class="px-3 py-3 lg:px-5 lg:pl-3">
    <div class="flex items-center justify-between">
      <div class="flex items-center justify-start rtl:justify-end">
        <button
          data-drawer-target="logo-sidebar"
          data-drawer-toggle="logo-sidebar"
          aria-controls="logo-sidebar"
          type="button"
          class="border-red inline-flex items-center p-2 text-sm text-primary-500 rounded-lg sm:hidden hover:bg-primary-100 focus:outline-none focus:ring-2 focus:ring-primary-200"
          data-cy="button-open-sidebar"
        >
          <span class="sr-only">Open sidebar</span>
          <span class="w-6"><img alt="hamburguer icon" src={hamburger} /></span>
        </button>
        <a href={ROUTES.homeDashboard} class="flex ms-2 md:me-24 w-48" data-cy="logo-sulivan">
          <img alt="Sulivan Logo" src={logo} />
        </a>
      </div>
      <div class="flex items-center" data-cy="client-portal-container">
        <div class="flex items-center ms-3">
          <div class="hidden md:block text-2xl mr-4 text-primary-500 whitespace-nowrap" data-cy="client-portal-text">
            <a href={ROUTES.clientPortalUrl} data-cy={'client-portal-link'}> Client Portal </a>
          </div>
          <button
            type="button"
            class="text-white bg-primary-500 hover:bg-primary-600 focus:ring-4 focus:outline-none font-normal rounded-md text-base px-5 py-2.5 text-center inline-flex items-center me-2"
            data-cy="button-emulate"
          >
            <img alt="Emulate Icon" src={robot} />
            <span class="ml-2">Emulate</span>
          </button>

          <div class="ml-2">
            <button
              type="button"
              class="flex flex-row items-center text-sm bg-transparent rounded-lg"
              aria-expanded="false"
              data-dropdown-toggle="dropdown-user"
              data-cy="button-dropdown-user"
            >
              <span class="sr-only">Open user menu</span>
              <div
                class="relative inline-flex items-center justify-center w-8 h-8 overflow-hidden bg-primary-400 rounded-md mr-1 hover:ring-2 hover:ring-primary-200"
              >
                <span class="font-medium text-primary-100" data-cy="profile-username">JS</span>
              </div>
              <img class="w-[14px] h-[14px]" alt="User Options" src={dropdown} />
            </button>
          </div>
          <div class="z-50 hidden my-4 text-base list-none bg-white divide-y divide-primary-100 rounded shadow" id="dropdown-user">
            <div class="flex items-center px-4 py-1">
              <div
                class="relative inline-flex items-center justify-center w-12 h-12 overflow-hidden bg-primary-400 rounded-md"
                data-cy="profile-picture"
              >
                <span class="font-medium text-primary-100">JS</span>
              </div>

              <div class="px-4 py-3" role="none" data-cy="profile-userinfo">
                <p class="text-xl text-primary-900 dark:text-white" role="none" data-cy="profile-name">John Snow</p>
                <p class="text-sm font-medium text-primary-900 truncate dark:text-primary-300" role="none" data-cy="profile-email">
                  john.snow@cliniciannexus.com
                </p>
              </div>
            </div>

            <ul class="py-1" role="none">
              <li>
                <a href={'#'} class="flex px-4 py-2 text-sm text-primary-700 hover:bg-primary-100" role="menuitem" data-cy="profile-account-settings">
                  <span class="mx-2">
                    <img alt="Account Settings Icon" src={accountSettings} />
                  </span>
                  <span>Account settings</span></a
                >
              </li>
              <li>
                <a href={'#'} class="flex px-4 py-2 text-sm text-primary-700 hover:bg-primary-100" role="menuitem" data-cy="profile-account-edit">
                  <span class="mx-2">
                    <img alt="Edit my profile Icon" src={editProfile} />
                  </span>
                  <span>Edit my profile</span></a
                >
              </li>
              <li>
                <a
                  href={'#'}
                  class="flex px-4 py-2 text-sm text-primary-700 hover:bg-primary-100"
                  role="menuitem"
                  data-cy="profile-notification-settings"
                >
                  <span class="mx-2">
                    <img alt="Notification Settings Icon" src={notificationSettings} />
                  </span>
                  <span>Notification settings</span></a
                >
              </li>
              <li>
                <a href={'#'} class="flex px-4 py-2 text-sm text-primary-700 hover:bg-primary-100" role="menuitem" data-cy="profile-logout">
                  <span class="mx-2">
                    <img alt="Logout Icon" src={logout} />
                  </span>
                  <span>Log out</span></a
                >
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</nav>

<aside id="logo-sidebar" class="fixed inset-y-0 left-0 transform -translate-x-full sm:relative sm:translate-x-0 transition duration-200 ease-in-out">
  <!-- Sidebar content goes here -->
</aside>
