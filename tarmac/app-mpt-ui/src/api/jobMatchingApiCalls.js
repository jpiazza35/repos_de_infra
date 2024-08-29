import jobMatchings from "../mocks/JobMatching/job-matchings.json";

export const getJobMatchings = async () => {
  return await jobMatchings.gridData;
};

export const getSearchStandards = async text => {
  return await jobMatchings.searchStandards.filter(
    standard =>
      standard.jobCode.toLowerCase().includes(text.toLowerCase()) ||
      standard.jobTitle.toLowerCase().includes(text.toLowerCase()) ||
      standard.jobDescription.toLowerCase().includes(text.toLowerCase()),
  );
};
