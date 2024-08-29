<script>
  import { Router, Route } from "svelte-routing";
  import Project from "pages/Projects/Projects.svelte";
  import VersionComp from "components/layout/version.svelte";
</script>

<div class="w-100 overflow-x-auto">
  <div class="container-fluid bg-gray-50 p-4">
    <Router>
      <Route path="/version"><VersionComp /></Route>
      <Route><Project /></Route>
    </Router>
  </div>
</div>

<style>
  .bg-gray-50 {
    background-color: #f7f7f7;
  }
</style>
