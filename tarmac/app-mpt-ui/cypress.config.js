import { defineConfig } from "cypress";
import fs from "fs";

export default defineConfig({
  projectId: "4u1bf9",
  viewportWidth: 1920,
  viewportHeight: 1175,
  e2e: {
    setupNodeEvents(on, config) {
      on("task", {
        listDownloads() {
          const downloadDir = config.downloadsFolder || "cypress/downloads";
          const files = fs.readdirSync(downloadDir);
          return files;
        },
      });
    },
    specPattern: "cypress/e2e/**/*.js",
    testIsolation: false,
    baseUrl: "http://localhost:5173/",

    env: {
      azureb2c_url: "https://auth.dev.cliniciannexus.com/",
      azureb2c_admin_username: "mpuatp1@cliniciannexusb2cdev.onmicrosoft.com",
      azureb2c_admin_password: "k78dhqCkVxDWLzM9",
      azureb2c_client_username: "mpuatp1@cliniciannexusb2cdev.onmicrosoft.com",
      azureb2c_client_password: "k78dhqCkVxDWLzM9",
      azureb2c_scope: "https://api.dev.cliniciannexus.com/cn-generic-api/api.access",
      azureb2c_api_url: "688818c9-34fd-4789-9a6a-1544d58f5ea8/b2c_1a_cn_ropc/oauth2/v2.0/token",
      azureb2c_client_id: "bc243b8f-1aae-4490-9819-ee940bcf8743",
      // possible values b2c, okta
      cypress_auth_type: "okta",

      auth0_admin_username: "mpuatp1@cliniciannexusb2cdev.onmicrosoft.com",
      auth0_admin_password: "k78dhqCkVxDWLzM9",
      auth0_audience: "https://mpt.dev.cliniciannexus.com",
      auth0_domain: "dev-2nsl2cauo135yhdi.us.auth0.com",
      auth0_client_id: "Ro3msWUmu4HOk6RmhMWQTsrrzoLsr4Av",
      auth0_client_secret: "g57uPAdtoy9NdGkvSFcyZV3bz1vFT_VleBxlN75gvW8l-b3sploXYoRojCSc30Lj",

      auth0_ui_client_id: "a0729XH2HGHLIytxLCBzuj8L7vF0q9TR",
      auth0_ui_client_secret: "VIfb-sJpHcLntUoV2-5-luTbX2hOoa5AD8FCEMT2Q7KyWhd4dOnQvv2L6ypfwOXX",

      api_url_prefix: "api/",
    },
    retries: {
      runMode: 1,
    },
  },
  chromeWebSecurity: false,
});
