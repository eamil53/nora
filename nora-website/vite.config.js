import { resolve } from 'path';
import { defineConfig } from 'vite';

export default defineConfig({
  build: {
    rollupOptions: {
      input: {
        main: resolve(import.meta.dirname, 'index.html'),
        privacy: resolve(import.meta.dirname, 'privacy.html'),
        eula: resolve(import.meta.dirname, 'eula.html'),
        support: resolve(import.meta.dirname, 'support.html'),
        download: resolve(import.meta.dirname, 'download.html'),
      },
    },
  },
  server: {
    port: 5173,
    host: true,
  },
});
