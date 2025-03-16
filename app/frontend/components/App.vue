<template>
  <div class="flex flex-col min-h-screen bg-gray-950 relative overflow-x-hidden">
    <!-- Global background gradients -->
    <div class="fixed inset-0 -z-10 opacity-15 pointer-events-none">
      <div class="absolute top-0 left-1/4 w-96 h-96 rounded-full bg-blue-500 blur-[150px]"></div>
      <div class="absolute bottom-0 right-1/4 w-96 h-96 rounded-full bg-purple-600 blur-[150px]"></div>
    </div>
    
    <!-- Header -->
    <header class="sticky top-0 z-50 backdrop-blur-md bg-gray-900/80 border-b border-gray-800 shadow-lg">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center py-4">
          <!-- Logo -->
          <div>
            <router-link to="/" class="flex items-center group">
              <h1 class="text-2xl font-bold">
                <span class="bg-gradient-to-r from-blue-500 to-blue-400 inline-block text-transparent bg-clip-text transition-all duration-300 group-hover:from-blue-400 group-hover:to-blue-500">ArXiv</span> 
                <span class="bg-gradient-to-r from-purple-600 to-purple-500 inline-block text-transparent bg-clip-text transition-all duration-300 group-hover:from-purple-500 group-hover:to-purple-600">Visualizer</span>
              </h1>
            </router-link>
          </div>

          <!-- Navigation -->
          <nav class="flex items-center gap-1 sm:gap-2">
            <template v-if="isLoggedIn">
              <router-link to="/" 
                class="px-3 py-2 text-gray-300 rounded-lg transition-all duration-200 hover:bg-white/5 hover:text-white relative group"
                :class="{ 'text-white bg-white/5': $route.path === '/' }">
                <span>Home</span>
                <span class="absolute -bottom-px left-1/2 w-0 h-0.5 bg-blue-500 group-hover:w-4/5 group-hover:left-[10%] transition-all duration-300" 
                      :class="{ 'w-4/5 left-[10%]': $route.path === '/' }"></span>
              </router-link>
              
              <router-link to="/search" 
                class="px-3 py-2 text-gray-300 rounded-lg transition-all duration-200 hover:bg-white/5 hover:text-white relative group"
                :class="{ 'text-white bg-white/5': $route.path === '/search' }">
                <span>Search</span>
                <span class="absolute -bottom-px left-1/2 w-0 h-0.5 bg-purple-500 group-hover:w-4/5 group-hover:left-[10%] transition-all duration-300"
                      :class="{ 'w-4/5 left-[10%]': $route.path === '/search' }"></span>
              </router-link>
              
              <router-link to="/bookmarks" 
                class="px-3 py-2 text-gray-300 rounded-lg transition-all duration-200 hover:bg-white/5 hover:text-white relative group"
                :class="{ 'text-white bg-white/5': $route.path === '/bookmarks' }">
                <span>Bookmarks</span>
                <span class="absolute -bottom-px left-1/2 w-0 h-0.5 bg-blue-500 group-hover:w-4/5 group-hover:left-[10%] transition-all duration-300"
                      :class="{ 'w-4/5 left-[10%]': $route.path === '/bookmarks' }"></span>
              </router-link>
              
              <div 
                @click="logout" 
                class="px-3 py-2 text-gray-300 rounded-lg transition-all duration-200 hover:bg-white/5 hover:text-white relative group cursor-pointer"
                >
                <span>Logout</span>
                <span class="absolute -bottom-px left-1/2 w-0 h-0.5 bg-purple-500 group-hover:w-4/5 group-hover:left-[10%] transition-all duration-300"></span>
                </div>

            </template>
            <template v-else>
              <router-link to="/" 
                class="px-3 py-2 text-gray-300 rounded-lg transition-all duration-200 hover:bg-white/5 hover:text-white relative group"
                :class="{ 'text-white bg-white/5': $route.path === '/' }">
                <span>Home</span>
                <span class="absolute -bottom-px left-1/2 w-0 h-0.5 bg-blue-500 group-hover:w-4/5 group-hover:left-[10%] transition-all duration-300"
                      :class="{ 'w-4/5 left-[10%]': $route.path === '/' }"></span>
              </router-link>
              
              <router-link to="/login" 
                class="px-3 py-2 text-gray-300 rounded-lg transition-all duration-200 hover:bg-white/5 hover:text-white relative group"
                :class="{ 'text-white bg-white/5': $route.path === '/login' }">
                <span>Login</span>
                <span class="absolute -bottom-px left-1/2 w-0 h-0.5 bg-purple-500 group-hover:w-4/5 group-hover:left-[10%] transition-all duration-300"
                      :class="{ 'w-4/5 left-[10%]': $route.path === '/login' }"></span>
              </router-link>
              
              <router-link to="/register" 
                class="px-3 py-2 text-gray-300 rounded-lg transition-all duration-200 hover:bg-white/5 hover:text-white relative group"
                :class="{ 'text-white bg-white/5': $route.path === '/register' }">
                <span>Register</span>
                <span class="absolute -bottom-px left-1/2 w-0 h-0.5 bg-blue-500 group-hover:w-4/5 group-hover:left-[10%] transition-all duration-300"
                      :class="{ 'w-4/5 left-[10%]': $route.path === '/register' }"></span>
              </router-link>
            </template>
          </nav>
        </div>
      </div>
    </header>
    
    <!-- Main content -->
    <main class="flex-1 w-full max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
      <router-view></router-view>
    </main>
    
    <!-- Footer -->
    <footer class="mt-auto border-t border-gray-800 bg-gray-900/80 backdrop-blur-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <div class="flex flex-col sm:flex-row justify-between items-center">
          <p class="text-gray-400 text-sm">
            © 2025 <span class="text-blue-400">ArXiv Visualizer</span> - Explore research papers efficiently
          </p>
          
          <div class="flex items-center gap-4 mt-4 sm:mt-0">
            <a href="#" class="text-gray-400 hover:text-blue-400 transition-colors duration-200">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-github" viewBox="0 0 16 16">
                <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.012 8.012 0 0 0 16 8c0-4.42-3.58-8-8-8z"/>
              </svg>
            </a>
            <a href="#" class="text-gray-400 hover:text-blue-400 transition-colors duration-200">
              <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-twitter" viewBox="0 0 16 16">
                <path d="M5.026 15c6.038 0 9.341-5.003 9.341-9.334 0-.14 0-.282-.006-.422A6.685 6.685 0 0 0 16 3.542a6.658 6.658 0 0 1-1.889.518 3.301 3.301 0 0 0 1.447-1.817 6.533 6.533 0 0 1-2.087.793A3.286 3.286 0 0 0 7.875 6.03a9.325 9.325 0 0 1-6.767-3.429 3.289 3.289 0 0 0 1.018 4.382A3.323 3.323 0 0 1 .64 6.575v.045a3.288 3.288 0 0 0 2.632 3.218 3.203 3.203 0 0 1-.865.115 3.23 3.23 0 0 1-.614-.057 3.283 3.283 0 0 0 3.067 2.277A6.588 6.588 0 0 1 .78 13.58a6.32 6.32 0 0 1-.78-.045A9.344 9.344 0 0 0 5.026 15z"/>
              </svg>
            </a>
          </div>
        </div>
      </div>
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
