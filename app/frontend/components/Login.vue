<template>
    <div class="flex justify-center items-center min-h-screen px-4 py-12 relative overflow-hidden">
      <!-- Abstract background pattern -->
      <div class="absolute inset-0 -z-10 opacity-15">
        <div class="absolute top-1/3 left-1/4 w-64 h-64 rounded-full bg-blue-500 blur-[100px]"></div>
        <div class="absolute bottom-1/3 right-1/4 w-64 h-64 rounded-full bg-purple-600 blur-[100px]"></div>
      </div>
      
      <div class="w-full max-w-md relative">
        
        <div class="bg-gray-900 bg-opacity-80 backdrop-blur-xl rounded-xl border border-gray-800 shadow-2xl p-8">
          <div class="text-center mb-8">
            <h2 class="text-2xl font-bold mb-2">
              <span class="bg-gradient-to-r from-blue-500 to-purple-600 inline-block text-transparent bg-clip-text">
                Sign In
              </span>
            </h2>
            <p class="text-gray-300">Welcome back to ArXiv Visualizer</p>
          </div>
          <div v-if="errorMessage" class="flex items-center gap-3 p-4 mb-6 bg-red-500/10 border-l-4 border-red-500 text-red-500 rounded-r">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="12" cy="12" r="10"></circle>
              <line x1="12" y1="8" x2="12" y2="12"></line>
              <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
            <span>{{ errorMessage }}</span>
          </div>
          
          <form @submit.prevent="handleLogin" class="space-y-5">
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
                  placeholder="Enter your password"
                  class="w-full pl-10 p-3 bg-gray-800/80 border border-gray-700 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500/50 focus:border-blue-500 text-white transition duration-200"
                  required
                >
              </div>
            </div>
            
            <div class="flex justify-between items-center text-sm mt-4">
              <label class="flex items-center gap-2 text-gray-300 cursor-pointer group">
                <div class="relative flex items-center">
                  <input type="checkbox" class="peer sr-only" />
                  <div class="w-4 h-4 border border-gray-600 rounded peer-checked:bg-blue-500 peer-checked:border-blue-500 transition-all"></div>
                  <svg class="absolute w-3 h-3 text-white left-0.5 top-0.5 opacity-0 peer-checked:opacity-100 pointer-events-none" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"></path>
                  </svg>
                </div>
                <span>Remember me</span>
              </label>
              <a href="#" class="text-blue-400 hover:text-blue-300 hover:underline transition duration-200">Forgot Password?</a>
            </div>
            
            <div class="pt-2">
              <button 
                type="submit" 
                class="w-full py-3 px-4 bg-gradient-to-r from-blue-500 to-purple-600 text-white font-medium rounded-lg transition duration-300 hover:-translate-y-1 hover:shadow-lg hover:shadow-blue-500/20 flex items-center justify-center"
              >
                <span>Sign In</span>
                <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 5l7 7m0 0l-7 7m7-7H3" />
                </svg>
              </button>
            </div>
          </form>
          
          <div class="mt-8 text-center text-gray-300 text-sm">
            <p>
              Don't have an account? 
              <router-link to="/register" class="text-blue-400 font-semibold hover:text-blue-300 hover:underline transition duration-200">Create Account</router-link>
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
  import axios from 'axios'
  
  const email = ref('')
  const password = ref('')
  const errorMessage = ref('')
  const store = useStore()
  const router = useRouter()
    
  const handleLogin = async () => {
    try {
      const response = await axios.post('/api/v1/login', {
        auth: {
          email: email.value,
          password: password.value
        }
      });
      
      if (response.data && response.data.token) {
        const token = response.data.token;
        localStorage.setItem('token', token);
        
        // Set auth header for future requests
        axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
        
        store.commit('auth_success', { 
          token, 
          user: response.data.user 
        });
        
        router.push('/search');
      } else {
        throw new Error('No token received from server');
      }
    } catch (error) {
      errorMessage.value = 'Login failed. Please check your credentials.';
      console.error('Login error:', error);
    }
  }
  </script>
  