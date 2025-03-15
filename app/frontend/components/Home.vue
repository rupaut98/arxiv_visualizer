<template>
    <div class="welcome">
      <h1>Welcome to ArXiv Visualizer</h1>
      <div class="description">
        <p>ArXiv Visualizer is a user-friendly platform for exploring and organizing research papers from ArXiv.</p>
        <p>Features include:</p>
        <ul>
          <li>Easy search with filters</li>
          <li>Bookmark papers for later reference</li>
          <li>Visualize citation networks</li>
          <li>Personalized organization</li>
        </ul>
      </div>
      
      <div class="actions">
        <div v-if="isLoggedIn">
          <router-link to="/search" class="btn primary">Start Exploring</router-link>
          <router-link to="/bookmarks" class="btn secondary">My Bookmarks</router-link>
        </div>
        <div v-else>
          <router-link to="/login" class="btn primary">Sign In</router-link>
          <router-link to="/register" class="btn secondary">Register</router-link>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { computed } from 'vue'
  import { useStore } from 'vuex'
  
  const store = useStore()
  const isLoggedIn = computed(() => store.getters.isLoggedIn)
  </script>
  
  
  <style scoped>
  .welcome {
    text-align: center;
  }
  
  .description {
    max-width: 800px;
    margin: 0 auto;
    text-align: left;
  }
  
  .actions {
    margin-top: 2rem;
  }
  
  .btn {
    display: inline-block;
    padding: 10px 20px;
    margin: 0 10px;
    border-radius: 4px;
    text-decoration: none;
  }
  
  .primary {
    background-color: #3273dc;
    color: white;
  }
  
  .secondary {
    background-color: #f5f5f5;
    color: #333;
    border: 1px solid #ddd;
  }
  </style>
  