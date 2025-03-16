<template>
  <div class="flex flex-col min-h-screen bg-gray-950">
    <header class="sticky top-0 z-10 flex justify-between items-center px-6 py-4 bg-gray-900 shadow-md">
      <div>
        <h1 class="text-2xl font-bold m-0">
          <span class="text-blue-500">ArXiv</span> <span class="text-purple-600">Visualizer</span>
        </h1>
      </div>
      <nav class="flex gap-4">
        <template v-if="isLoggedIn">
          <router-link to="/" 
            class="px-3 py-1.5 text-gray-300 rounded transition duration-200"
            :class="{ 'text-white bg-white/5': $route.path === '/' }">
            Home
          </router-link>
          <router-link to="/search" 
            class="px-3 py-1.5 text-gray-300 rounded transition duration-200"
            :class="{ 'text-white bg-white/5': $route.path === '/search' }">
            Search
          </router-link>
          <router-link to="/bookmarks" 
            class="px-3 py-1.5 text-gray-300 rounded transition duration-200"
            :class="{ 'text-white bg-white/5': $route.path === '/bookmarks' }">
            Bookmarks
          </router-link>
          <button 
            @click="logout" 
            class="px-3 py-1.5 text-gray-300 rounded text-base bg-transparent border-0 transition duration-200 hover:text-red-500">
            Logout
          </button>
        </template>
        <template v-else>
          <router-link to="/" 
            class="px-3 py-1.5 text-gray-300 rounded transition duration-200"
            :class="{ 'text-white bg-white/5': $route.path === '/' }">
            Home
          </router-link>
          <router-link to="/login" 
            class="px-3 py-1.5 text-gray-300 rounded transition duration-200"
            :class="{ 'text-white bg-white/5': $route.path === '/login' }">
            Login
          </router-link>
          <router-link to="/register" 
            class="px-3 py-1.5 text-gray-300 rounded transition duration-200"
            :class="{ 'text-white bg-white/5': $route.path === '/register' }">
            Register
          </router-link>
        </template>
      </nav>
    </header>
    
    <main class="flex-1 w-full max-w-7xl mx-auto p-6">
      <router-view></router-view>
    </main>
    
    <footer class="py-4 text-center text-gray-500 bg-gray-900 mt-auto">
      <p>© 2025 ArXiv Visualizer - Explore research papers efficiently</p>
    </footer>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'

const store = useStore()
const router = useRouter()

const isLoggedIn = computed(() => store.getters.isLoggedIn)

const logout = () => {
  store.dispatch('logout')
  router.push('/login')
}
</script>
