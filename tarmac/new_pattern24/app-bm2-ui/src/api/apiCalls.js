import { get } from 'svelte/store'
import { token } from 'store/auth'
import header from 'mock/header.json'

const baseURL = window.location.host?.includes('localhost') ? 'http://localhost:10000' : `${window.location.origin}/survey`

export const getDashboardHeader = async () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      Promise.resolve(header)
        .then(data => resolve(data))
        .catch(error => reject(error))
    }, 1000)
  })
}

export const getCompensationSummary = async () => {
  // return await fetch(`${baseURL}/compensation-summary`).then(r => r.json())
  // TODO: remove delay example
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      callApi(`/compensation-summary`)
        .then(response => {
          return response.json()
        })
        .then(data => resolve(data))
        .catch(error => reject(error))
    }, 1000)
  })
}

export const getFteAllocation = async () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      callApi(`/fte-allocation`)
        .then(response => {
          return response.json()
        })
        .then(data => resolve(data))
        .catch(error => reject(error))
    }, 1000)
  })
}

export const getPayCategory = async () => {
  return new Promise((resolve, reject) => {
    setTimeout(() => {
      callApi(`/pay-category`)
        .then(response => {
          return response.json()
        })
        .then(data => resolve(data))
        .catch(error => reject(error))
    }, 1000)
  })
}

/**
 * Calls the API with the given URL and access token and returns the response.
 * @param {string} url
 * @returns {Promise<Response>}
 */
const callApi = url => {
  return fetch(`${baseURL}${url}`, {
    headers: { Authorization: `Bearer ${get(token)}` },
  })
}
