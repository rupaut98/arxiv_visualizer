import { createRouter, createWebHistory } from 'vue-router'
import PaperSearch from '../components/PaperSearch.vue'
import PaperDetail from '../components/PaperDetail.vue'
import CitationNetwork from '../components/CitationNetwork.vue'
import BookmarkList from '../components/BookmarkList.vue'
import Login from '../components/Login.vue'
import Register from '../components/Register.vue'
import store from '../store'

const routes = [
  {
    path: '/',
    name: 'Home',
    component: PaperSearch
  },
  {
    path: '/papers/:id',
    name: 'PaperDetail',
    component: PaperDetail
  },
  {
    path: '/papers/:id/citations',
    name: 'CitationNetwork',
    component: CitationNetwork
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

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!store.getters.isLoggedIn) {
      next({ name: 'Login' })
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router
