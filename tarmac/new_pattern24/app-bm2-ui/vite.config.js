import { defineConfig } from 'vite'
import { svelte } from '@sveltejs/vite-plugin-svelte'
import sveltePreprocess from 'svelte-preprocess'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    svelte({
      preprocess: sveltePreprocess({
        preserve: ['ld+json'],
        scss: {
          includePaths: ['src'],
          importer: [
            url => {
              // Redirects tilde-prefixed imports to node_modules
              if (/^~/.test(url)) return { file: `node_modules/${url.replace('~', '')}` }
              return null
            },
          ],
        },
      }),
    }),
  ],
  resolve: {
    alias: {
      api: path.resolve('src/api'),
      assets: path.resolve('assets'),
      auth: path.resolve('src/auth'),
      components: path.resolve('src/components'),
      lib: path.resolve('src/lib'),
      mock: path.resolve('src/mock'),
      pages: path.resolve('src/pages'),
      store: path.resolve('src/store'),
      utils: path.resolve('src/utils'),
    },
  },
})
