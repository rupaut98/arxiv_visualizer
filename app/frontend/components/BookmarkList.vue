<template>
    <div class="bookmarks-container">
      <h2>Your Bookmarked Papers</h2>
      
      <div v-if="loading" class="loading">
        Loading your bookmarks...
      </div>
      
      <div v-else-if="bookmarks.length === 0" class="no-bookmarks">
        <p>You don't have any bookmarked papers yet.</p>
        <router-link to="/search" class="search-link">Search for papers</router-link>
      </div>
      
      <div v-else class="bookmark-list">
        <div v-for="bookmark in bookmarks" :key="bookmark.id" class="bookmark-card">
          <div class="bookmark-header">
            <h3>{{ bookmark.paper.title }}</h3>
            <button @click="removeBookmark(bookmark.id)" class="remove-btn">
              Remove
            </button>
          </div>
          
          <div class="paper-meta">
            <span class="authors">{{ bookmark.paper.authors }}</span>
            <span class="date">{{ formatDate(bookmark.paper.published_date) }}</span>
          </div>
          
          <p class="abstract">{{ truncateAbstract(bookmark.paper.abstract) }}</p>
          
          <div class="paper-actions">
            <router-link :to="`/papers/${bookmark.paper.arxiv_id}`" class="view-btn">
              View Details
            </router-link>
            <a :href="bookmark.paper.url" target="_blank" class="arxiv-link">
              View on ArXiv
            </a>
            <div v-if="bookmark.notes" class="notes">
              <strong>Notes:</strong> {{ bookmark.notes }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue'
  import axios from 'axios'
  
  const bookmarks = ref([])
  const loading = ref(true)
  
  onMounted(() => {
    fetchBookmarks()
  })
  
  const fetchBookmarks = async () => {
    try {
      const response = await axios.get('/api/v1/bookmarks')
      bookmarks.value = response.data
    } catch (error) {
      console.error('Error fetching bookmarks:', error)
    } finally {
      loading.value = false
    }
  }
  
  const removeBookmark = async (id) => {
    if (confirm('Are you sure you want to remove this bookmark?')) {
      try {
        await axios.delete(`/api/v1/bookmarks/${id}`)
        // Remove the bookmark from the list
        bookmarks.value = bookmarks.value.filter(bookmark => bookmark.id !== id)
      } catch (error) {
        console.error('Error removing bookmark:', error)
      }
    }
  }
  
  const formatDate = (dateString) => {
    if (!dateString) return ''
    const date = new Date(dateString)
    return date.toLocaleDateString()
  }
  
  const truncateAbstract = (abstract) => {
    if (!abstract) return ''
    return abstract.length > 300 ? abstract.substring(0, 300) + '...' : abstract
  }
  </script>
  
  <style scoped>
  .bookmarks-container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 20px;
  }
  
  .bookmark-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
    margin-top: 20px;
  }
  
  .bookmark-card {
    padding: 20px;
    border: 1px solid #eee;
    border-radius: 5px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    transition: transform 0.2s;
  }
  
  .bookmark-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  .bookmark-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
  }
  
  .bookmark-header h3 {
    margin-top: 0;
    margin-right: 15px;
  }
  
  .paper-meta {
    display: flex;
    justify-content: space-between;
    margin: 8px 0;
    font-size: 14px;
    color: #666;
  }
  
  .abstract {
    line-height: 1.5;
    color: #444;
  }
  
  .paper-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
    margin-top: 15px;
  }
  
  .view-btn, .arxiv-link, .remove-btn {
    padding: 8px 12px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
    text-decoration: none;
    text-align: center;
  }
  
  .view-btn {
    background: #3273dc;
    color: white;
  }
  
  .arxiv-link {
    background: #f5f5f5;
    color: #333;
  }
  
  .remove-btn {
    background: #ff3860;
    color: white;
  }
  
  .notes {
    flex-basis: 100%;
    margin-top: 10px;
    font-size: 14px;
    padding: 10px;
    background: #f9f9f9;
    border-radius: 4px;
  }
  
  .no-bookmarks {
    text-align: center;
    margin: 40px 0;
  }
  
  .search-link {
    display: inline-block;
    margin-top: 10px;
    padding: 8px 16px;
    background: #3273dc;
    color: white;
    text-decoration: none;
    border-radius: 4px;
  }
  
  .loading {
    text-align: center;
    margin: 40px 0;
    color: #666;
  }
  </style>
  