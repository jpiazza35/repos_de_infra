import { callApi } from "./apiCalls";

export const getJobSummaries = async projectVersionId => await callApi(`projects/job-summary-table/${projectVersionId}`, "GET");

export const getJobSummariesEmployee = async projectVersionId => await callApi(`projects/job-summary-table/${projectVersionId}/employeeLevel`, "GET");

export const retrieveTableDataEmployee = async (projectVersionId, payload) =>
  await callApi(`projects/job-summary-table/${projectVersionId}/employeeLevel`, "POST", payload);

export const retrieveTableData = async (projectVersionId, payload) =>
  await callApi(`projects/job-summary-table/${projectVersionId}`, "POST", payload);
