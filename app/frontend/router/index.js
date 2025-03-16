// app/frontend/router/index.js
import { createRouter, createWebHistory } from 'vue-router'
import Home from '../components/Home.vue'
import PaperSearch from '../components/PaperSearch.vue'
import PaperDetail from '../components/PaperDetail.vue'
import BookmarkList from '../components/BookmarkList.vue'
import Login from '../components/Login.vue'
import Register from '../components/Register.vue'
import store from '../store'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/search',
    name: 'PaperSearch',
    component: PaperSearch,
    meta: { requiresAuth: true }  // Add this to protect the route
  },
  
  {
    path: '/papers/:id',
    name: 'PaperDetail',
    component: PaperDetail,
    meta: { requiresAuth: true }
  },
  
  {
    path: '/bookmarks',
    name: 'Bookmarks',
    component: BookmarkList,
    meta: { requiresAuth: true }
  },
  {
    path: '/login',
    name: 'Login',
    component: Login
  },
  {
    path: '/register',
    name: 'Register',
    component: Register
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

// Navigation guard
router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    // This route requires auth, check if logged in
    if (!store.getters.isLoggedIn) {
      // Not logged in, redirect to login page
      next({ name: 'Login' })
    } else {
      next() // User is logged in, proceed
    }
  } else {
    next() // No auth required, proceed
  }
})

export default router
