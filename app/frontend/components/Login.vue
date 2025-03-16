<template>
    <div class="auth-container">
      <div class="auth-card">
        <div class="auth-header">
          <h2>Sign In</h2>
          <p>Welcome back to ArXiv Visualizer</p>
        </div>
        
        <div v-if="errorMessage" class="alert">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="12" y1="8" x2="12" y2="12"></line>
            <line x1="12" y1="16" x2="12.01" y2="16"></line>
          </svg>
          <span>{{ errorMessage }}</span>
        </div>
        
        <form @submit.prevent="handleLogin" class="auth-form">
          <div class="form-group">
            <label for="email">Email</label>
            <input 
              type="email" 
              id="email" 
              v-model="email" 
              placeholder="your@email.com"
              required
            >
          </div>
          
          <div class="form-group">
            <label for="password">Password</label>
            <input 
              type="password" 
              id="password" 
              v-model="password" 
              placeholder="Enter your password"
              required
            >
          </div>
          
          <div class="form-options">
            <label class="checkbox-label">
              <input type="checkbox"> Remember me
            </label>
            <a href="#" class="forgot-password">Forgot Password?</a>
          </div>
          
          <button type="submit" class="auth-button">Sign In</button>
        </form>
        
        <div class="auth-footer">
          <p>
            Don't have an account? 
            <router-link to="/register">Create Account</router-link>
          </p>
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
  
  <style scoped>
  .auth-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 80vh;
  }
  
  .auth-card {
    background-color: var(--bg-secondary);
    border-radius: var(--radius-md);
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    width: 100%;
    max-width: 400px;
    padding: var(--space-xl);
  }
  
  .auth-header {
    text-align: center;
    margin-bottom: var(--space-lg);
  }
  
  .auth-header h2 {
    font-size: 1.75rem;
    margin-bottom: var(--space-xs);
  }
  
  .auth-header p {
    color: var(--text-secondary);
  }
  
  .auth-form {
    display: flex;
    flex-direction: column;
    gap: var(--space-md);
  }
  
  .form-group {
    margin-bottom: var(--space-md);
  }
  
  label {
    display: block;
    margin-bottom: var(--space-xs);
    color: var(--text-secondary);
    font-size: 0.9rem;
  }
  
  input {
    background-color: var(--bg-tertiary);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-sm);
    color: var(--text-primary);
    font-size: 1rem;
    padding: 0.75rem 1rem;
    width: 100%;
    transition: all var(--transition);
  }
  
  input:focus {
    border-color: var(--accent-primary);
    box-shadow: 0 0 0 2px rgba(58, 134, 255, 0.2);
  }
  
  .form-options {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin: var(--space-sm) 0 var(--space-md);
    font-size: 0.9rem;
  }
  
  .checkbox-label {
    display: flex;
    align-items: center;
    gap: var(--space-xs);
    cursor: pointer;
    color: var(--text-secondary);
  }
  
  .forgot-password {
    color: var(--accent-primary);
    font-size: 0.9rem;
  }
  
  .auth-button {
    background-color: var(--accent-primary);
    color: white;
    border: none;
    border-radius: var(--radius-sm);
    font-size: 1rem;
    font-weight: 600;
    padding: 0.75rem 1rem;
    width: 100%;
    cursor: pointer;
    transition: all var(--transition);
  }
  
  .auth-button:hover {
    background-color: #2a75e6;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }
  
  .alert {
    display: flex;
    align-items: center;
    gap: var(--space-sm);
    padding: var(--space-md);
    margin-bottom: var(--space-md);
    background-color: rgba(241, 70, 104, 0.1);
    border-left: 3px solid var(--error);
    color: var(--error);
    border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
  }
  
  .auth-footer {
    margin-top: var(--space-lg);
    text-align: center;
    color: var(--text-secondary);
    font-size: 0.9rem;
  }
  
  .auth-footer a {
    color: var(--accent-primary);
    font-weight: 600;
  }
  
  .auth-footer a:hover {
    text-decoration: underline;
  }
  </style>
  