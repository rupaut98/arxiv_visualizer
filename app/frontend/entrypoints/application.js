import { createApp } from 'vue'
import App from '../components/App.vue'
import router from '../router'
import store from '../store'
import axios from 'axios'

// Set up axios with authentication
const token = localStorage.getItem('token')
if (token) {
  axios.defaults.headers.common['Authorization'] = `Bearer ${token}`
}

// Create and mount Vue app
document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('app')
  if (element) {
    const app = createApp(App)
    app.use(router)
    app.use(store)
    app.mount(element)
  }
})
