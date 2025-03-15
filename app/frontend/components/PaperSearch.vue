<template>
    <div class="paper-search-container">
      <h1>Search arXiv Papers</h1>
      
      <div class="search-form">
        <input 
          type="text" 
          v-model="searchQuery" 
          placeholder="Search for papers..." 
          @keyup.enter="searchPapers"
        />
        <button @click="searchPapers" class="search-button">Search</button>
      </div>
      
      <div v-if="loading" class="loading">
        <p>Loading papers...</p>
      </div>
      
      <div v-else-if="error" class="error">
        <p>{{ error }}</p>
      </div>
      
      <div v-else class="papers-list">
        <div v-for="paper in papers" :key="paper.arxiv_id" class="paper-card">
          <div class="paper-header">
            <h2 class="paper-title">{{ paper.title }}</h2>
            <button 
              @click="toggleBookmark(paper)" 
              :class="['bookmark-button', { 'bookmarked': isBookmarked(paper.arxiv_id) }]"
            >
              {{ isBookmarked(paper.arxiv_id) ? 'Bookmarked' : 'Bookmark' }}
            </button>
          </div>
          
          <p class="paper-authors">{{ paper.authors }}</p>
          <p class="paper-date">Published: {{ formatDate(paper.published_date) }}</p>
          
          <div class="paper-abstract">
            <p>{{ paper.abstract }}</p>
          </div>
          
          <div class="paper-actions">
            <router-link :to="`/papers/${paper.arxiv_id}`" class="view-details">
              View Details
            </router-link>
            <router-link :to="`/papers/${paper.arxiv_id}/citations`" class="view-citations">
              View Citations
            </router-link>
          </div>
        </div>
      </div>
      
      <div v-if="papers.length > 0 && !loading" class="pagination">
        <button 
          :disabled="currentPage === 1" 
          @click="changePage(currentPage - 1)"
          class="pagination-button"
        >
          Previous
        </button>
        <span>Page {{ currentPage }}</span>
        <button 
          @click="changePage(currentPage + 1)"
          class="pagination-button"
        >
          Next
        </button>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, computed, onMounted } from 'vue';
  import { useStore } from 'vuex';
  
  export default {
    name: 'PaperSearch',
    
    setup() {
      const store = useStore();
      
      const searchQuery = ref('');
      const papers = ref([]);
      const loading = ref(false);
      const error = ref(null);
      const currentPage = ref(1);
      const bookmarkedPapers = ref([]);
      
      // Fetch bookmarked papers on component mount
      onMounted(async () => {
        try {
          if (store.getters.isLoggedIn) {
            const response = await fetch('/api/v1/bookmarks', {
              headers: {
                'Authorization': `Bearer ${store.state.token}`
              }
            });
            
            if (!response.ok) throw new Error('Failed to fetch bookmarks');
            
            const data = await response.json();
            bookmarkedPapers.value = data.map(bookmark => bookmark.paper.arxiv_id);
          }
        } catch (err) {
          console.error('Error fetching bookmarks:', err);
        }
      });
      
      const searchPapers = async () => {
        if (!searchQuery.value.trim()) return;
        
        loading.value = true;
        error.value = null;
        
        try {
          // Use the dedicated search endpoint
          const response = await fetch(`/api/v1/papers/search?query=${encodeURIComponent(searchQuery.value)}&page=${currentPage.value}`, {
            headers: {
              'Authorization': store.getters.isLoggedIn ? `Bearer ${store.state.token}` : ''
            }
          });
          
          if (!response.ok) throw new Error('Failed to fetch papers');
          
          const data = await response.json();
          papers.value = data.papers || [];
        } catch (err) {
          error.value = 'Error searching for papers. Please try again.';
          console.error('Error searching papers:', err);
        } finally {
          loading.value = false;
        }
      };
      
      const changePage = (newPage) => {
        if (newPage < 1) return;
        
        currentPage.value = newPage;
        searchPapers();
      };
      
      const formatDate = (dateString) => {
        if (!dateString) return 'Unknown date';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', { 
          year: 'numeric', 
          month: 'long', 
          day: 'numeric' 
        });
      };
      
      const isBookmarked = (arxivId) => {
        return bookmarkedPapers.value.includes(arxivId);
      };
      
      const toggleBookmark = async (paper) => {
        if (!store.getters.isLoggedIn) {
          alert('Please log in to bookmark papers');
          return;
        }
        
        try {
          if (isBookmarked(paper.arxiv_id)) {
            // Find the bookmark ID
            const response = await fetch('/api/v1/bookmarks', {
              headers: {
                'Authorization': `Bearer ${store.state.token}`
              }
            });
            
            if (!response.ok) throw new Error('Failed to fetch bookmarks');
            
            const bookmarks = await response.json();
            const bookmark = bookmarks.find(b => b.paper.arxiv_id === paper.arxiv_id);
            
            if (bookmark) {
              // Delete the bookmark
              const deleteResponse = await fetch(`/api/v1/bookmarks/${bookmark.id}`, {
                method: 'DELETE',
                headers: {
                  'Authorization': `Bearer ${store.state.token}`,
                  'Content-Type': 'application/json'
                }
              });
              
              if (!deleteResponse.ok) throw new Error('Failed to remove bookmark');
              
              // Update local state
              bookmarkedPapers.value = bookmarkedPapers.value.filter(id => id !== paper.arxiv_id);
            }
          } else {
            // Add new bookmark
            const response = await fetch('/api/v1/bookmarks', {
              method: 'POST',
              headers: {
                'Authorization': `Bearer ${store.state.token}`,
                'Content-Type': 'application/json'
              },
              body: JSON.stringify({
                arxiv_id: paper.arxiv_id,
                notes: ''
              })
            });
            
            if (!response.ok) throw new Error('Failed to add bookmark');
            
            // Update local state
            bookmarkedPapers.value.push(paper.arxiv_id);
          }
        } catch (err) {
          console.error('Error toggling bookmark:', err);
          alert('Failed to update bookmark. Please try again.');
        }
      };
      
      return {
        searchQuery,
        papers,
        loading,
        error,
        currentPage,
        searchPapers,
        changePage,
        formatDate,
        isBookmarked,
        toggleBookmark
      };
    }
  }
  </script>
  
  <style scoped>
  .paper-search-container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 2rem;
  }
  
  h1 {
    margin-bottom: 2rem;
    color: #2c3e50;
  }
  
  .search-form {
    display: flex;
    margin-bottom: 2rem;
  }
  
  input {
    flex: 1;
    padding: 0.75rem;
    font-size: 1rem;
    border: 1px solid #ddd;
    border-radius: 4px 0 0 4px;
  }
  
  .search-button {
    padding: 0.75rem 1.5rem;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 0 4px 4px 0;
    cursor: pointer;
    font-weight: bold;
  }
  
  .loading, .error {
    text-align: center;
    padding: 2rem;
  }
  
  .papers-list {
    display: grid;
    gap: 1.5rem;
  }
  
  .paper-card {
    border: 1px solid #e0e0e0;
    border-radius: 8px;
    padding: 1.5rem;
    box-shadow: 0 2px 4px rgba(0,0,0,0.05);
    background-color: white;
    width: 100%;
    box-sizing: border-box;
  }
  
  .paper-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: 0.5rem;
  }
  
  .paper-title {
    font-size: 1.25rem;
    margin: 0 1rem 0.5rem 0;
    color: #2c3e50;
    flex: 1;
  }
  
  .paper-authors {
    font-size: 0.9rem;
    color: #666;
    margin-bottom: 0.5rem;
  }
  
  .paper-date {
    font-size: 0.8rem;
    color: #888;
    margin-bottom: 1rem;
  }
  
  .paper-abstract {
    margin-bottom: 1.5rem;
    line-height: 1.6;
    color: #333;
    /* Allow the abstract to show completely */
    white-space: pre-wrap;
    word-break: break-word;
  }
  
  .paper-actions {
    display: flex;
    gap: 1rem;
  }
  
  .view-details, .view-citations {
    padding: 0.5rem 1rem;
    background-color: #2196F3;
    color: white;
    text-decoration: none;
    border-radius: 4px;
    font-size: 0.9rem;
  }
  
  .view-citations {
    background-color: #9C27B0;
  }
  
  .bookmark-button {
    padding: 0.5rem 1rem;
    background-color: #f0f0f0;
    border: 1px solid #ddd;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.9rem;
  }
  
  .bookmark-button.bookmarked {
    background-color: #FFC107;
    color: #333;
  }
  
  .pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-top: 2rem;
    gap: 1rem;
  }
  
  .pagination-button {
    padding: 0.5rem 1rem;
    background-color: #2196F3;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
  }
  
  .pagination-button:disabled {
    background-color: #ccc;
    cursor: not-allowed;
  }
  </style>
  