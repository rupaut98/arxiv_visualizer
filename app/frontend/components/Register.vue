<template>
    <div class="flex justify-center items-center min-h-screen px-4 py-12 relative overflow-hidden">
      <!-- Abstract background pattern -->
      <div class="absolute inset-0 -z-10 opacity-15">
        <div class="absolute top-1/3 right-1/4 w-64 h-64 rounded-full bg-purple-600 blur-[100px]"></div>
        <div class="absolute bottom-1/3 left-1/4 w-64 h-64 rounded-full bg-blue-500 blur-[100px]"></div>
      </div>
      
      <div class="w-full max-w-md relative">
        
        <div class="bg-gray-900 bg-opacity-80 backdrop-blur-xl rounded-xl border border-gray-800 shadow-2xl p-8">
          <div class="text-center mb-8">
            <h2 class="text-2xl font-bold mb-2">
              <span class="bg-gradient-to-r from-purple-600 to-blue-500 inline-block text-transparent bg-clip-text">
                Create Account
              </span>
            </h2>
            <p class="text-gray-300">Join ArXiv Visualizer to organize research papers</p>
          </div>
          
          <div v-if="errors.length" class="flex gap-3 p-4 mb-6 bg-red-500/10 border-l-4 border-red-500 text-red-500 rounded-r">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="mt-0.5">
              <circle cx="12" cy="12" r="10"></circle>
              <line x1="12" y1="8" x2="12" y2="12"></line>
              <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            <div>
              <span>Please fix the following errors:</span>
              <ul class="list-disc ml-6 mt-1 text-sm">
                <li v-for="(error, index) in errors" :key="index">{{ error }}</li>
              </ul>
            </div>
          </div>
          
          <form @submit.prevent="handleRegister" class="space-y-5">
            <div class="group">
              <label for="username" class="block text-sm text-gray-300 mb-1.5 group-focus-within:text-blue-400 transition-colors duration-200">Username</label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500 group-focus-within:text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                  </svg>
                </div>
                <input 
                  type="text" 
                  id="username" 
                  v-model="username" 
                  placeholder="Choose a username"
                  class="w-full pl-10 p-3 bg-gray-800/80 border border-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500 text-white transition duration-200"
                  required
                >
              </div>
            </div>
            
            <div class="group">
              <label for="email" class="block text-sm text-gray-300 mb-1.5 group-focus-within:text-blue-400 transition-colors duration-200">Email</label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500 group-focus-within:text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                </div>
                <input 
                  type="email" 
                  id="email" 
                  v-model="email" 
                  placeholder="your@email.com"
                  class="w-full pl-10 p-3 bg-gray-800/80 border border-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500 text-white transition duration-200"
                  required
                >
              </div>
            </div>
            
            <div class="group">
              <label for="password" class="block text-sm text-gray-300 mb-1.5 group-focus-within:text-blue-400 transition-colors duration-200">Password</label>
              <div class="relative">
                <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-500 group-focus-within:text-blue-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                  </svg>
                </div>
                <input 
                  type="password" 
                  id="password" 
                  v-model="password" 
                  placeholder="Create a secure password"
                  class="w-full pl-10 p-3 bg-gray-800/80 border border-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500 text-white transition duration-200"
                  required
                  minlength="6"
                >
              </div>
              <p class="text-xs text-gray-500 mt-1.5 ml-1">Password must be at least 6 characters long</p>
            </div>
            
            <div class="mt-3">
              <label class="flex items-start gap-2 text-sm text-gray-300 cursor-pointer group">
                <div class="relative flex items-center mt-1">
                  <input type="checkbox" required class="peer sr-only" />
                  <div class="w-4 h-4 border border-gray-600 rounded peer-checked:bg-purple-600 peer-checked:border-purple-600 transition-all"></div>
                  <svg class="absolute w-3 h-3 text-white left-0.5 top-0.5 opacity-0 peer-checked:opacity-100 pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path>
                  </svg>
                </div>
                <span>
                  I agree to the 
                  <a href="#" class="text-blue-400 hover:text-blue-300 hover:underline transition duration-200">Terms of Service</a> 
                  and 
                  <a href="#" class="text-blue-400 hover:text-blue-300 hover:underline transition duration-200">Privacy Policy</a>
                </span>
              </label>
            </div>
            
            <div class="pt-3">
              <button 
                type="submit" 
                class="w-full py-3 px-4 bg-gradient-to-r from-purple-600 to-blue-500 text-white font-medium rounded-lg transition duration-300 hover:-translate-y-1 hover:shadow-lg hover:shadow-purple-500/20 flex items-center justify-center"
              >
                <span>Create Account</span>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                </svg>
              </button>
            </div>
          </form>
          
          <div class="mt-8 text-center text-gray-300 text-sm">
            <p>
              Already have an account? 
              <router-link to="/login" class="text-blue-400 font-semibold hover:text-blue-300 hover:underline transition duration-200">Sign In</router-link>
            </p>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue'
  import { useStore } from 'vuex'
  import { useRouter } from 'vue-router'
  
  const username = ref('')
  const email = ref('')
  const password = ref('')
  const errors = ref([])
  const store = useStore()
  const router = useRouter()
  
  const handleRegister = async () => {
    errors.value = []
    
    try {
      await store.dispatch('register', {
        username: username.value,
        email: email.value,
        password: password.value
      })
      router.push('/search')
    } catch (error) {
      if (error.response && error.response.data.errors) {
        errors.value = error.response.data.errors
      } else {
        errors.value = ['Registration failed. Please try again.']
      }
      console.error('Registration error:', error)
    }
  }
  </script>
  