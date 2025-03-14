import { createApp } from 'vue'
import App from '../components/App.vue' // You'll create this file

// Mount Vue app if the element exists
document.addEventListener('DOMContentLoaded', () => {
  const element = document.getElementById('app')
  if (element) {
    const app = createApp(App)
    app.mount(element)
  }
})

// Keep your existing JS code below
