import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    vue(),
    tailwindcss()
  ],
  resolve: {
    dedupe: ['vue']
  },
  optimizeDeps: {
    include: ['vuex', 'vue-router', 'axios']
  }
})
