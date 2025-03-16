import { createApp } from 'vue'
import App from '../components/App.vue'
import router from '../router'
import store from '../store'
import '../styles/main.css'


document.addEventListener('DOMContentLoaded', () => {
  const app = createApp(App)
  app.use(router)
  app.use(store)
  app.mount('#app')
  console.log('Vue app mounted')
})
