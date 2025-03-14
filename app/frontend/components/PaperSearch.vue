<template>
    <div class="paper-search">
      <h2>Search ArXiv Papers</h2>
      
      <div class="search-form">
        <div class="search-input">
          <input 
            type="text" 
            v-model="searchQuery" 
            placeholder="Search for papers..." 
            @keyup.enter="searchPapers"
          >
          <button @click="searchPapers">Search</button>
        </div>
        
        <div class="filters">
          <div class="filter-group">
            <label>Search in:</label>
            <select v-model="searchField">
              <option value="all">All fields</option>
              <option value="ti">Title</option>
              <option value="au">Author</option>
              <option value="abs">Abstract</option>
            </select>
          </div>
          
          <div class="filter-group">
            <label>Sort by:</label>
            <select v-model="sortBy">
              <option value="relevance">Relevance</option>
              <option value="lastUpdatedDate">Last Updated</option>
              <option value="submittedDate">Submission Date</option>
            </select>
          </div>
          
          <div class="filter-group">
            <label>Results per page:</label>
            <select v-model="maxResults">
              <option>10</option>
              <option>25</option>
              <option>50</option>
            </select>
          </div>
        </div>
      </div>
      
      <div v-if="loading" class="loading">
        Loading papers...
      </div>
      
      <div v-else-if="papers.length > 0" class="paper-list">
        <paper-list :papers="papers" @bookmark="bookmarkPaper"></paper-list>
      </div>
      
      <div v-else-if="hasSearched" class="no-results">
        No papers found. Try adjusting your search terms.
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed } from 'vue'
  import { useRouter } from 'vue-router'
  import axios from 'axios'
  import PaperList from './PaperList.vue'
  
  const router = useRouter()
  const searchQuery = ref('')
  const searchField = ref('all')
  const sortBy = ref('relevance')
  const maxResults = ref(10)
  const papers = ref([])
  const loading = ref(false)
  const hasSearched = ref(false)
  
  const searchPapers = async () => {
    if (!searchQuery.value.trim()) return
    
    loading.value = true
    hasSearched.value = true
    
    try {
      // Format the search query based on the selected field
      let formattedQuery = searchQuery.value
      if (searchField.value !== 'all') {
        formattedQuery = `${searchField.value}:${formattedQuery}`
      }
      
      // Call your backend API which will proxy to ArXiv
      const response = await axios.get('/api/v1/papers', {
        params: {
          query: formattedQuery,
          max_results: maxResults.value,
          sort_by: sortBy.value
        }
      })
      
      papers.value = response.data
    } catch (error) {
      console.error('Error fetching papers:', error)
    } finally {
      loading.value = false
    }
  }
  
  const bookmarkPaper = (paper) => {
    // This will be implemented to save bookmarks
    axios.post('/api/v1/bookmarks', { arxiv_id: paper.arxiv_id })
      .then(() => {
        alert('Paper bookmarked successfully!')
      })
      .catch(error => {
        console.error('Error bookmarking paper:', error)
      })
  }
  </script>
  
  <style scoped>
  .paper-search {
    max-width: 1000px;
    margin: 0 auto;
  }
  
  .search-form {
    margin: 20px 0;
    padding: 15px;
    background: #f5f5f5;
    border-radius: 5px;
  }
  
  .search-input {
    display: flex;
    margin-bottom: 15px;
  }
  
  .search-input input {
    flex: 1;
    padding: 10px;
    font-size: 16px;
    border: 1px solid #ddd;
    border-radius: 4px 0 0 4px;
  }
  
  .search-input button {
    padding: 10px 20px;
    background: #3273dc;
    color: white;
    border: none;
    border-radius: 0 4px 4px 0;
    cursor: pointer;
  }
  
  .filters {
    display: flex;
    flex-wrap: wrap;
    gap: 15px;
  }
  
  .filter-group {
    display: flex;
    align-items: center;
    gap: 8px;
  }
  
  select {
    padding: 8px;
    border: 1px solid #ddd;
    border-radius: 4px;
  }
  
  .loading, .no-results {
    text-align: center;
    margin: 40px 0;
    color: #666;
  }
  </style>
  