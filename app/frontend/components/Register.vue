<template>
  <div class="register-container">
    <h2>Create Your Account</h2>
    
    <div v-if="errors.length" class="error-list">
      <ul>
        <li v-for="(error, index) in errors" :key="index">{{ error }}</li>
      </ul>
    </div>
    
    <form @submit.prevent="handleRegister" class="register-form">
      <div class="form-group">
        <label for="username">Username</label>
        <input 
          type="text" 
          id="username" 
          v-model="username" 
          required
        >
      </div>
      
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
          minlength="6"
        >
      </div>
      
      <div class="form-actions">
        <button type="submit" class="btn-register">Create Account</button>
      </div>
    </form>
    
    <div class="login-prompt">
      Already have an account? 
      <router-link to="/login">Sign In</router-link>
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
.register-container {
  max-width: 400px;
  margin: 0 auto;
  padding: 20px;
}

.register-form {
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

.btn-register {
  width: 100%;
  padding: 10px;
  background-color: #48c774;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.error-list {
  background-color: #f8d7da;
  color: #721c24;
  padding: 10px;
  border-radius: 4px;
  margin-bottom: 15px;
}

.login-prompt {
  margin-top: 20px;
  text-align: center;
}
</style>
