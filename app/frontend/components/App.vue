<template>
  <div class="arxiv-visualizer">
    <header>
      <h1>ArXiv Visualizer</h1>
      <nav v-if="isLoggedIn">
        <router-link to="/">Home</router-link> |
        <router-link to="/bookmarks">Bookmarks</router-link> |
        <a href="#" @click.prevent="logout">Logout</a>
      </nav>
      <nav v-else>
        <router-link to="/login">Login</router-link> |
        <router-link to="/register">Register</router-link>
      </nav>
    </header>
    
    <main>
      <router-view></router-view>
    </main>
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

<style scoped>
.arxiv-visualizer {
  max-width: 1200px;
  margin: 0 auto;
  padding: 20px;
}

header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid #eee;
}

nav a {
  margin-left: 1rem;
  text-decoration: none;
  color: #3273dc;
}

nav a:hover {
  text-decoration: underline;
}

main {
  min-height: 400px;
}
</style>
