<template>
    <div class="auth-container">
      <div class="auth-card">
        <div class="auth-header">
          <h2>Create Account</h2>
          <p>Join ArXiv Visualizer to organize research papers</p>
        </div>
        
        <div v-if="errors.length" class="alert">
          <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="12" cy="12" r="10"></circle>
            <line x1="12" y1="8" x2="12" y2="12"></line>
            <line x1="12" y1="16" x2="12.01" y2="16"></line>
          </svg>
          <div>
            <span>Please fix the following errors:</span>
            <ul class="error-list">
              <li v-for="(error, index) in errors" :key="index">{{ error }}</li>
            </ul>
          </div>
        </div>
        
        <form @submit.prevent="handleRegister" class="auth-form">
          <div class="form-group">
            <label for="username">Username</label>
            <input 
              type="text" 
              id="username" 
              v-model="username" 
              placeholder="Choose a username"
              required
            >
          </div>
          
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
              placeholder="Create a secure password"
              required
              minlength="6"
            >
            <p class="password-hint">Password must be at least 6 characters long</p>
          </div>
          
          <div class="form-terms">
            <label class="checkbox-label">
              <input type="checkbox" required> 
              I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
            </label>
          </div>
          
          <button type="submit" class="auth-button create-button">Create Account</button>
        </form>
        
        <div class="auth-footer">
          <p>
            Already have an account? 
            <router-link to="/login">Sign In</router-link>
          </p>
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
  
  .password-hint {
    font-size: 0.8rem;
    color: var(--text-tertiary);
    margin-top: var(--space-xs);
  }
  
  .form-terms {
    margin: var(--space-sm) 0 var(--space-md);
    font-size: 0.9rem;
  }
  
  .checkbox-label {
    display: flex;
    align-items: flex-start;
    gap: var(--space-xs);
    cursor: pointer;
    color: var(--text-secondary);
  }
  
  .checkbox-label input {
    width: auto;
    margin-top: 0.2rem;
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
  
  .create-button {
    background-color: var(--success);
  }
  
  .create-button:hover {
    background-color: #3da55d;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }
  
  .alert {
    display: flex;
    align-items: flex-start;
    gap: var(--space-sm);
    padding: var(--space-md);
    margin-bottom: var(--space-md);
    background-color: rgba(241, 70, 104, 0.1);
    border-left: 3px solid var(--error);
    color: var(--error);
    border-radius: 0 var(--radius-sm) var(--radius-sm) 0;
  }
  
  .error-list {
    margin: var(--space-xs) 0 0;
    padding-left: var(--space-lg);
    font-size: 0.9rem;
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
  