<template>
    <div class="flex flex-col min-h-screen">
      <!-- Hero Section with Animation -->
      <section class="relative py-20 px-4 overflow-hidden">
        <!-- Abstract background pattern -->
        <div class="absolute inset-0 -z-10 opacity-15">
          <div class="absolute top-1/3 left-1/4 w-64 h-64 rounded-full bg-blue-500 blur-[100px]"></div>
          <div class="absolute bottom-1/3 right-1/4 w-64 h-64 rounded-full bg-purple-600 blur-[100px]"></div>
        </div>
        
        <div class="max-w-5xl mx-auto text-center relative">
          <div class="space-y-6">
            <h1 class="text-5xl md:text-6xl font-bold tracking-tight">
              <span class="text-blue-500">ArXiv</span> 
              <span class="text-purple-600">Visualizer</span>
            </h1>
            
            <p class="text-xl md:text-2xl text-gray-300 max-w-3xl mx-auto leading-relaxed">
              Discover, organize, and explore research papers with intuitive tools designed for researchers.
            </p>
            
            <!-- CTA for non-logged in users -->
            <div v-if="!isLoggedIn" class="pt-8 flex flex-col sm:flex-row justify-center gap-4">
              <router-link to="/register" class="relative group">
                <div class="absolute -inset-0.5 bg-gradient-to-r from-blue-500 to-purple-600 rounded-lg blur opacity-60 group-hover:opacity-100 transition duration-200"></div>
                <button class="relative px-8 py-4 bg-gray-900 rounded-lg text-white font-medium group-hover:-translate-y-1 transition duration-200">
                  Get Started
                </button>
              </router-link>
              
              <router-link to="/login" class="px-8 py-4 border border-gray-700 hover:border-blue-500 text-white rounded-lg transition duration-200 hover:-translate-y-1">
                Sign In
              </router-link>
            </div>
            
            <!-- CTA for logged in users -->
            <div v-else class="pt-8 flex flex-col sm:flex-row justify-center gap-4">
              <router-link to="/search" class="relative group">
                <div class="absolute -inset-0.5 bg-gradient-to-r from-blue-500 to-purple-600 rounded-lg blur opacity-60 group-hover:opacity-100 transition duration-200"></div>
                <button class="relative px-8 py-4 bg-gray-900 rounded-lg text-white font-medium group-hover:-translate-y-1 transition duration-200">
                  Start Searching
                </button>
              </router-link>
            </div>
          </div>
        </div>
      </section>
      
      <!-- Paper Stats Bar -->
      <section class="bg-gray-900/50 backdrop-blur-sm border-y border-gray-800 py-10">
        <div class="max-w-6xl mx-auto px-4">
          <div class="grid grid-cols-2 md:grid-cols-4 gap-8">
            <div class="text-center">
              <p class="text-3xl md:text-4xl font-bold bg-gradient-to-r from-blue-500 to-purple-600 inline-block text-transparent bg-clip-text">2M+</p>
              <p class="text-gray-300 text-sm mt-1">Research Papers</p>
            </div>
            <div class="text-center">
              <p class="text-3xl md:text-4xl font-bold bg-gradient-to-r from-blue-500 to-purple-600 inline-block text-transparent bg-clip-text">150+</p>
              <p class="text-gray-300 text-sm mt-1">Subject Areas</p>
            </div>
            <div class="text-center">
              <p class="text-3xl md:text-4xl font-bold bg-gradient-to-r from-blue-500 to-purple-600 inline-block text-transparent bg-clip-text">14K+</p>
              <p class="text-gray-300 text-sm mt-1">Daily Updates</p>
            </div>
            <div class="text-center">
              <p class="text-3xl md:text-4xl font-bold bg-gradient-to-r from-blue-500 to-purple-600 inline-block text-transparent bg-clip-text">30K+</p>
              <p class="text-gray-300 text-sm mt-1">Users</p>
            </div>
          </div>
        </div>
      </section>
      
      <!-- Features Section -->
      <section class="py-20 px-4">
        <div class="max-w-6xl mx-auto">
          <h2 class="text-3xl font-bold text-center mb-16 relative">
            <span class="bg-gradient-to-r from-blue-500 to-purple-600 inline-block text-transparent bg-clip-text">
              Key Features
            </span>
            <div class="h-1 w-20 bg-gradient-to-r from-blue-500 to-purple-600 absolute -bottom-4 left-1/2 transform -translate-x-1/2 rounded-full"></div>
          </h2>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
            <!-- Feature 1 -->
            <div class="bg-gray-900 bg-opacity-80 rounded-xl p-6 transition-all duration-300 hover:translate-y-[-8px] backdrop-blur-md border border-gray-800 hover:border-blue-500/50 group">
              <div class="w-14 h-14 bg-blue-500/10 rounded-lg flex items-center justify-center mb-6 group-hover:bg-blue-500/20 transition-colors duration-300">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
              </div>
              <h3 class="text-lg font-bold mb-3 text-white group-hover:text-blue-400 transition-colors duration-300">Smart Search</h3>
              <p class="text-gray-400 leading-relaxed">Find papers with advanced filters and get relevant results instantly</p>
            </div>
            
            <!-- Feature 2 -->
            <div class="bg-gray-900 bg-opacity-80 rounded-xl p-6 transition-all duration-300 hover:translate-y-[-8px] backdrop-blur-md border border-gray-800 hover:border-purple-500/50 group">
              <div class="w-14 h-14 bg-purple-500/10 rounded-lg flex items-center justify-center mb-6 group-hover:bg-purple-500/20 transition-colors duration-300">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-purple-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 5a2 2 0 012-2h10a2 2 0 012 2v16l-7-3.5L5 21V5z" />
                </svg>
              </div>
              <h3 class="text-lg font-bold mb-3 text-white group-hover:text-purple-400 transition-colors duration-300">Bookmarks</h3>
              <p class="text-gray-400 leading-relaxed">Save papers for later reference and organize your research library</p>
            </div>
            
            <!-- Feature 3 -->
            <div class="bg-gray-900 bg-opacity-80 rounded-xl p-6 transition-all duration-300 hover:translate-y-[-8px] backdrop-blur-md border border-gray-800 hover:border-blue-500/50 group">
              <div class="w-14 h-14 bg-blue-500/10 rounded-lg flex items-center justify-center mb-6 group-hover:bg-blue-500/20 transition-colors duration-300">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-7 w-7 text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 12l3-3 3 3 4-4M8 21l4-4 4 4M3 4h18M4 4h16v12a1 1 0 01-1 1H5a1 1 0 01-1-1V4z" />
                </svg>
              </div>
              <h3 class="text-lg font-bold mb-3 text-white group-hover:text-blue-400 transition-colors duration-300">Citation Network</h3>
              <p class="text-gray-400 leading-relaxed">Visualize connections between papers and discover related research</p>
            </div>
            
          </div>
        </div>
      </section>
      
      <!-- Get Started / CTA Section -->
      <section class="py-16 px-4 relative overflow-hidden">
        <div class="absolute inset-0 -z-10 opacity-20">
          <div class="absolute top-1/4 right-1/4 w-72 h-72 rounded-full bg-blue-500 blur-[120px]"></div>
          <div class="absolute bottom-1/4 left-1/4 w-72 h-72 rounded-full bg-purple-600 blur-[120px]"></div>
        </div>
        
        <div class="max-w-4xl mx-auto text-center">
          <div class="bg-gray-900 bg-opacity-80 backdrop-blur-xl rounded-2xl p-10 border border-gray-800 relative shadow-xl">
            <div class="absolute -top-px left-10 right-10 h-px bg-gradient-to-r from-transparent via-blue-500/50 to-transparent"></div>
            <div class="absolute -bottom-px left-10 right-10 h-px bg-gradient-to-r from-transparent via-purple-600/50 to-transparent"></div>
            <h2 class="text-3xl font-bold mb-4">
              <span v-if="isLoggedIn">Ready to explore?</span>
              <span v-else>Join ArXiv Visualizer</span>
            </h2>
            
            <p v-if="!isLoggedIn" class="text-gray-300 mb-8 max-w-lg mx-auto">
              Create an account to unlock all features and start organizing your research papers today.
            </p>
            
            <div class="flex flex-col sm:flex-row justify-center gap-4">
              <router-link v-if="isLoggedIn" to="/search" class="inline-flex items-center justify-center px-8 py-4 bg-gradient-to-r from-blue-500 to-purple-600 text-white font-medium rounded-lg shadow-lg hover:shadow-blue-500/20 transition duration-300 hover:-translate-y-1 hover:shadow-xl">
                <span>Start Searching</span>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                </svg>
              </router-link>
              
              <router-link v-if="isLoggedIn" to="/bookmarks" class="px-8 py-4 border border-gray-700 hover:border-blue-500 text-white rounded-lg transition duration-300 hover:-translate-y-1">
                View Bookmarks
              </router-link>
              
              <template v-else>
                <router-link to="/login" class="px-8 py-4 border border-gray-700 hover:border-blue-500 text-white rounded-lg transition duration-300 hover:-translate-y-1">
                  Sign In
                </router-link>
                
                <router-link to="/register" class="inline-flex items-center justify-center px-8 py-4 bg-gradient-to-r from-blue-500 to-purple-600 text-white font-medium rounded-lg shadow-lg hover:shadow-blue-500/20 transition duration-300 hover:-translate-y-1 hover:shadow-xl">
                  <span>Create Account</span>
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                  </svg>
                </router-link>
              </template>
            </div>
          </div>
        </div>
      </section>
    </div>
  </template>
  
  <script setup>
  import { computed } from 'vue'
  import { useStore } from 'vuex'
  
  const store = useStore()
  const isLoggedIn = computed(() => store.getters.isLoggedIn)
  </script>
  