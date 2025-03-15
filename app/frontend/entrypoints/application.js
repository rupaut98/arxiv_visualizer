import { createApp } from 'vue'
import App from '../components/App.vue'
import router from '../router'
import store from '../store'

document.addEventListener('DOMContentLoaded', () => {
  const app = createApp(App)
  app.use(router)
  app.use(store)
  app.mount('#app')
  console.log('Vue app mounted') // Add this for debugging
})
