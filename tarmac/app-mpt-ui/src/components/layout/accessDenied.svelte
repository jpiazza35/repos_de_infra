<script>
  import { AuthLogout } from "../../auth/authHelper";
</script>

<html lang="en">
  <head>
    <title>Access Denied</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="stylesheet" href="style.css" />
    <link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css" />
  </head>
  <body>
    <div class="w3-display-middle">
      <h1 class="w3-jumbo w3-animate-top w3-center">Access Denied</h1>
      <hr class="w3-border-white w3-animate-left" style="margin:auto;width:50%" />
      <h3 class="w3-center w3-animate-right">You don't have permission to access the Market Pricing Tool.</h3>
      <div class="w3-center"><button on:click={AuthLogout}>Click here to try again</button></div>
    </div>
  </body>
</html>
