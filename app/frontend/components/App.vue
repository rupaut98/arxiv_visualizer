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
            <div class="flex justify-center items-center">
            <p class="text-gray-400 text-sm text-center">
                © 2025 <span class="text-blue-400">ArXiv Visualizer</span> - Explore research papers efficiently
            </p>
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
