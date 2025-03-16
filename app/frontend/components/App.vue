<template>
  <div class="arxiv-visualizer">
    <header>
      <div class="logo">
        <h1>ArXiv Visualizer</h1>
      </div>
      <nav>
        <template v-if="isLoggedIn">
          <router-link to="/" class="nav-link">Home</router-link>
          <router-link to="/search" class="nav-link">Search</router-link>
          <router-link to="/bookmarks" class="nav-link">Bookmarks</router-link>
          <button @click="logout" class="nav-link logout-button">Logout</button>
        </template>
        <template v-else>
          <router-link to="/" class="nav-link">Home</router-link>
          <router-link to="/login" class="nav-link">Login</router-link>
          <router-link to="/register" class="nav-link">Register</router-link>
        </template>
      </nav>
    </header>
    
    <main>
      <router-view></router-view>
    </main>
    
    <footer>
      <p>© 2025 ArXiv Visualizer - Explore research papers efficiently</p>
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

<style>
/* Global CSS Variables */
:root {
  /* Dark theme colors */
  --bg-primary: #121212;
  --bg-secondary: #1e1e1e;
  --bg-tertiary: #2d2d2d;
  --text-primary: #ffffff;
  --text-secondary: #b3b3b3;
  --text-tertiary: #8c8c8c;
  --accent-primary: #3a86ff;
  --accent-secondary: #8338ec;
  --success: #48c774;
  --error: #f14668;
  --border-color: #333333;
  --card-bg: #1e1e1e;
  
  /* Spacing */
  --space-xs: 0.25rem;
  --space-sm: 0.5rem;
  --space-md: 1rem;
  --space-lg: 1.5rem;
  --space-xl: 2rem;
  
  /* Radius and effects */
  --radius-sm: 4px;
  --radius-md: 8px;
  --transition: 0.2s ease;
}

/* Basic reset and global styles */
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}

body {
  background-color: var(--bg-primary);
  color: var(--text-primary);
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, 
    Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
  line-height: 1.6;
}

a {
  color: var(--accent-primary);
  text-decoration: none;
  transition: color var(--transition);
}

button {
  cursor: pointer;
  font-family: inherit;
}

h1, h2, h3 {
  line-height: 1.3;
}

input, textarea, select {
  background-color: var(--bg-tertiary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-sm);
  color: var(--text-primary);
  padding: 0.75rem 1rem;
  width: 100%;
  transition: border-color var(--transition);
}

input:focus, textarea:focus, select:focus {
  border-color: var(--accent-primary);
  outline: none;
}
</style>

<style scoped>
.arxiv-visualizer {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
}

header {
  background-color: var(--bg-secondary);
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: var(--space-md) var(--space-xl);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
  position: sticky;
  top: 0;
  z-index: 10;
}

.logo h1 {
  font-size: 1.5rem;
  background: linear-gradient(45deg, var(--accent-primary), var(--accent-secondary));
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  margin: 0;
}

nav {
  display: flex;
  gap: var(--space-md);
}

.nav-link {
  color: var(--text-secondary);
  padding: var(--space-xs) var(--space-sm);
  border-radius: var(--radius-sm);
  transition: all var(--transition);
}

.nav-link:hover, .router-link-active {
  color: var(--text-primary);
  background-color: rgba(255, 255, 255, 0.05);
}

.logout-button {
  background: none;
  border: none;
  color: var(--text-secondary);
  font-size: 1rem;
  padding: var(--space-xs) var(--space-sm);
}

.logout-button:hover {
  color: var(--error);
}

main {
  flex: 1;
  max-width: 1200px;
  width: 100%;
  margin: 0 auto;
  padding: var(--space-xl);
}

footer {
  background-color: var(--bg-secondary);
  color: var(--text-tertiary);
  text-align: center;
  padding: var(--space-md);
  margin-top: auto;
}

@media (max-width: 768px) {
  header {
    flex-direction: column;
    gap: var(--space-md);
    padding: var(--space-md);
  }
  
  nav {
    width: 100%;
    justify-content: center;
  }
}
</style>
