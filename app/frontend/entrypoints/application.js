import { createApp } from 'vue'
import { createPinia } from 'pinia'
import piniaPluginPersistedstate from 'pinia-plugin-persistedstate'
import App from '../components/App.vue'
import router from '../router'
import store from '../store'
import '../styles/main.css'

document.addEventListener('DOMContentLoaded', () => {
  // Create and configure Pinia with persistence
  const pinia = createPinia()
  pinia.use(piniaPluginPersistedstate)
  
  // Initialize Vue app with all plugins
  const app = createApp(App)
  app.use(router)
  app.use(store) // Vuex store
  app.use(pinia) // Add Pinia
  
  app.mount('#app')
  console.log('Vue app mounted with Pinia')
})
