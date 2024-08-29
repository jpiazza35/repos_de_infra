import { defineConfig, loadEnv } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import { readFileSync } from "fs";
import { fileURLToPath } from "url";
import path from "path";
import http from "https";

// https://vitejs.dev/config/
export default defineConfig(({ mode }) => {
  // eslint-disable-next-line no-undef
  const env = loadEnv(mode, process.cwd(), "");
  const file = fileURLToPath(new URL("package.json", import.meta.url));
  const json = readFileSync(file, "utf8");
  const pkg = JSON.parse(json);

  return {
    plugins: [svelte()],
    define: {
      __APP_VERSION__: JSON.stringify(pkg.version),
    },
    kit: {
      csp: {
        directives: {
          "script-src": ["self"],
        },
        reportOnly: {
          "script-src": ["self"],
        },
      },
    },
    resolve: {
      alias: {
        components: path.resolve("src/components"),
        mocks: path.resolve("src/mocks"),
        models: path.resolve("src/models"),
        pages: path.resolve("src/pages"),
        shared: path.resolve("src/shared"),
        utils: path.resolve("src/utils"),
        api: path.resolve("src/api"),
        store: path.resolve("src/store"),
      },
    },
    build: {
      target: "esnext",
    },
    server: {
      headers: {
        "Strict-Transport-Security": env.VITE_HEADER_STRICT_TRA_SEC,
        "X-Content-Type-Options": env.VITE_HEADER_X_CONTENT_OPTIONS,
        "X-Frame-Options": env.VITE_HEADER_X_FRAME_CONTENT_OPTIONS,
        "Content-Security-Policy": env.VITE_HEADER_CONTENT_SEC_POLICY,
      },
      proxy:
        mode === "staging"
          ? {
              "/api": {
                target: env.HOST,
                changeOrigin: true,
                secure: false,
                agent: new http.Agent(),
              },
            }
          : {
              "/api/survey": {
                target: env.VITE_SURVEY_API_BASE_URL,
                changeOrigin: true,
                secure: false,
                agent: new http.Agent(),
              },
              "/api/user": {
                target: env.VITE_USER_API_BASE_URL,
                changeOrigin: true,
                secure: false,
                agent: new http.Agent(),
              },
              "/api/users": {
                target: env.VITE_USER_API_BASE_URL,
                changeOrigin: true,
                secure: false,
                agent: new http.Agent(),
              },
              "/api/mpt-project": {
                target: env.VITE_PROJECT_API_BASE_URL,
                changeOrigin: true,
                secure: false,
                agent: new http.Agent(),
              },
              "/api/projects": {
                target: env.VITE_PROJECT_API_BASE_URL,
                changeOrigin: true,
                secure: false,
                agent: new http.Agent(),
              },
              "/api/file": {
                target: env.VITE_INCUMBENT_API_BASE_URL,
                changeOrigin: true,
                secure: false,
                agent: new http.Agent(),
              },
              "/api/files": {
                target: env.VITE_INCUMBENT_API_BASE_URL,
                changeOrigin: true,
                secure: false,
                agent: new http.Agent(),
              },
            },
    },
  };
});
