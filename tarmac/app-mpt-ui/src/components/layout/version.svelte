<script>
  import { getUserServiceBuild, getIncumbentServiceBuild, getProjectServiceBuild, getSurveyServiceBuild } from "api/apiCalls";

  let userVersion = 0;
  let incumbentVersion = 0;
  let projectVersion = 0;
  let surveyVersion = 0;

  getUserServiceBuild().then(data => {
    userVersion = data.data;
  });

  getIncumbentServiceBuild().then(data => {
    incumbentVersion = data.data;
  });

  getProjectServiceBuild().then(data => {
    projectVersion = data.data;
  });

  getSurveyServiceBuild().then(data => {
    surveyVersion = data.data;
  });

  const VITE_VERSION_NUMBER = import.meta.env.VITE_BUILD_NUMBER;
</script>

<h3>Build Number:</h3>
<table cellpadding="1" cellspacing="1">
  <tr>
    <td width="200px">Web</td>
    <td>{VITE_VERSION_NUMBER}</td>
  </tr>
  <tr>
    <td>User</td>
    <td>{userVersion}</td>
  </tr>
  <tr>
    <td>Survey</td>
    <td>{surveyVersion}</td>
  </tr>
  <tr>
    <td>Incumbent</td>
    <td>{incumbentVersion}</td>
  </tr>
  <tr>
    <td>Project</td>
    <td>{projectVersion}</td>
  </tr>
</table>

<style>
  table {
    font-family: Arial, Helvetica, sans-serif;
    border-collapse: collapse;
    width: 100%;
  }

  table td {
    border: 1px solid #ddd;
    padding: 8px;
  }

  table tr:nth-child(even) {
    background-color: #f2f2f2;
  }

  table tr:hover {
    background-color: #ddd;
  }
</style>
