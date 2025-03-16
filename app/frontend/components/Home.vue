<template>
    <div class="home">
      <section class="hero">
        <h1>Welcome to ArXiv Visualizer</h1>
        <p>Discover, organize, and explore research papers with ease</p>
      </section>
      
      <section class="features">
        <h2>Features</h2>
        <div class="feature-grid">
          <div class="feature-card">
            <div class="feature-icon">🔍</div>
            <h3>Smart Search</h3>
            <p>Find papers with advanced filters and get relevant results instantly</p>
          </div>
          
          <div class="feature-card">
            <div class="feature-icon">🔖</div>
            <h3>Bookmarks</h3>
            <p>Save papers for later reference and organize your research library</p>
          </div>
          
          <div class="feature-card">
            <div class="feature-icon">📊</div>
            <h3>Citation Network</h3>
            <p>Visualize connections between papers and discover related research</p>
          </div>
          
          <div class="feature-card">
            <div class="feature-icon">👤</div>
            <h3>Personalization</h3>
            <p>Customize your experience with personalized recommendations</p>
          </div>
        </div>
      </section>
      
      <section class="cta">
        <div v-if="isLoggedIn">
          <h2>Ready to explore?</h2>
          <div class="button-group">
            <router-link to="/search" class="btn primary">Start Searching</router-link>
            <router-link to="/bookmarks" class="btn secondary">View Bookmarks</router-link>
          </div>
        </div>
        <div v-else>
          <h2>Join ArXiv Visualizer</h2>
          <p>Create an account to unlock all features</p>
          <div class="button-group">
            <router-link to="/login" class="btn primary">Sign In</router-link>
            <router-link to="/register" class="btn secondary">Create Account</router-link>
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
  
  <style scoped>
  .home {
    display: flex;
    flex-direction: column;
    gap: var(--space-xl);
  }
  
  .hero {
    text-align: center;
    padding: var(--space-xl) 0;
  }
  
  .hero h1 {
    font-size: 2.5rem;
    margin-bottom: var(--space-md);
    background: linear-gradient(45deg, var(--accent-primary), var(--accent-secondary));
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
  }
  
  .hero p {
    font-size: 1.25rem;
    color: var(--text-secondary);
    max-width: 700px;
    margin: 0 auto;
  }
  
  .features {
    margin: var(--space-xl) 0;
  }
  
  .features h2 {
    text-align: center;
    margin-bottom: var(--space-xl);
    font-size: 1.75rem;
  }
  
  .feature-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
    gap: var(--space-lg);
    margin-bottom: var(--space-xl);
  }
  
  .feature-card {
    background-color: var(--bg-secondary);
    border-radius: var(--radius-md);
    padding: var(--space-lg);
    text-align: center;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    transition: transform var(--transition);
  }
  
  .feature-card:hover {
    transform: translateY(-5px);
  }
  
  .feature-icon {
    font-size: 2.5rem;
    margin-bottom: var(--space-md);
  }
  
  .feature-card h3 {
    margin-bottom: var(--space-sm);
  }
  
  .feature-card p {
    color: var(--text-secondary);
  }
  
  .cta {
    text-align: center;
    padding: var(--space-xl);
    background-color: var(--bg-secondary);
    border-radius: var(--radius-md);
    margin-top: var(--space-xl);
  }
  
  .cta h2 {
    margin-bottom: var(--space-md);
  }
  
  .cta p {
    margin-bottom: var(--space-lg);
    color: var(--text-secondary);
  }
  
  .button-group {
    display: flex;
    justify-content: center;
    gap: var(--space-md);
    margin-top: var(--space-lg);
  }
  
  .btn {
    display: inline-block;
    padding: 0.75rem 1.5rem;
    border-radius: var(--radius-sm);
    font-weight: 600;
    transition: all var(--transition);
  }
  
  .primary {
    background-color: var(--accent-primary);
    color: white;
  }
  
  .primary:hover {
    background-color: #2a75e6;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  }
  
  .secondary {
    background-color: var(--bg-tertiary);
    color: var(--text-primary);
    border: 1px solid var(--border-color);
  }
  
  .secondary:hover {
    border-color: var(--accent-primary);
    transform: translateY(-2px);
  }
  
  @media (max-width: 768px) {
    .button-group {
      flex-direction: column;
      align-items: center;
    }
    
    .btn {
      width: 100%;
      max-width: 300px;
      margin-bottom: var(--space-sm);
    }
  }
  </style>
  