import Dashboard from '../pages/homeDashboard/Dashboard.svelte'
import { writable } from 'svelte/store'
import { DASHBOARD_ROUTES, SECTIONS_COMPONENTS } from './tileUtils'

export const ROUTES = {
  clientPortalUrl: import.meta.env.VITE_CLIENT_PORTAL_URL || '/',
  homeDashboard: '/',
  DASHBOARD_ROUTES,
}

export const COMPONENTS = {
  homeDashboard: Dashboard,
  SECTIONS_COMPONENTS,
}

export const currentRoute = writable('/')
