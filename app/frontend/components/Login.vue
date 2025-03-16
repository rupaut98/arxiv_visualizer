<template>
    <div class="login-container">
      <h2>Sign In to ArXiv Visualizer</h2>
      
      <div v-if="errorMessage" class="error-message">
        {{ errorMessage }}
      </div>
      
      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label for="email">Email</label>
          <input 
            type="email" 
            id="email" 
            v-model="email" 
            required
          >
        </div>
        
        <div class="form-group">
          <label for="password">Password</label>
          <input 
            type="password" 
            id="password" 
            v-model="password" 
            required
          >
        </div>
        
        <div class="form-actions">
          <button type="submit" class="btn-login">Sign In</button>
        </div>
      </form>
      
      <div class="options">
        <a href="#" class="forgot-password">Forgot Password?</a>
        <p class="register-prompt">
          First time signing in? 
          <router-link to="/register">Register Now</router-link>
        </p>
      </div>
    </div>
  </template>
  
<script setup>
import { ref } from 'vue'
import { useStore } from 'vuex'
import { useRouter } from 'vue-router'
import axios from 'axios'  // Use standard axios

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

    console.log('Token stored in localStorage?', !!localStorage.getItem('token'));
    console.log('Token starts with:', localStorage.getItem('token')?.substring(0, 10));
    
    router.push('/search');
    } else {
    throw new Error('No token received from server');
    }
} catch (error) {
    errorMessage.value = 'Login failed';
    console.error('Login error:', error);
}
}
  </script>

  
  <style scoped>
  .login-container {
    max-width: 400px;
    margin: 0 auto;
    padding: 20px;
  }
  
  .login-form {
    margin-top: 20px;
  }
  
  .form-group {
    margin-bottom: 15px;
  }
  
  label {
    display: block;
    margin-bottom: 5px;
  }
  
  input {
    width: 100%;
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
  }
  
  .form-actions {
    margin-top: 20px;
  }
  
  .btn-login {
    width: 100%;
    padding: 10px;
    background-color: #3273dc;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  
  .options {
    margin-top: 20px;
    text-align: center;
  }
  
  .forgot-password {
    display: block;
    margin-bottom: 10px;
    color: #666;
  }
  
  .error-message {
    background-color: #f8d7da;
    color: #721c24;
    padding: 10px;
    border-radius: 4px;
    margin-bottom: 15px;
  }
  
  .register-prompt {
    margin-top: 15px;
  }
  </style>
  