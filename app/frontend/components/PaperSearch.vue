<template>
    <div class="paper-search-container">
      <div class="search-header">
        <h1>Search arXiv Papers</h1>
        <p class="search-subtitle">Discover and organize research papers from arXiv</p>
      </div>
      
      <div class="search-panel">
        <div class="search-form">
          <div class="search-input-wrapper">
            <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
            <input 
              type="text" 
              v-model="searchQuery" 
              placeholder="Search by title, author, or keyword..." 
              @keyup.enter="searchPapers"
              class="search-input"
            />
            <button @click="searchPapers" class="search-button">Search</button>
          </div>
        </div>
      </div>
      
      <div v-if="loading" class="loading-state">
        <div class="loader"></div>
        <p>Searching arXiv database...</p>
      </div>
      
      <div v-else-if="error" class="error-state">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="12" y1="8" x2="12" y2="12"></line>
          <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
        <p>{{ error }}</p>
        <button @click="searchPapers" class="retry-button">Try Again</button>
      </div>
      
      <div v-else-if="papers.length === 0 && searchQuery" class="no-results">
        <p>No papers found for "{{ searchQuery }}"</p>
        <p class="no-results-hint">Try different keywords or check your spelling</p>
      </div>
      
      <div v-else-if="papers.length > 0" class="results-info">
        <span>Showing results for "{{ searchQuery }}"</span>
      </div>
      
      <div v-if="papers.length > 0 && !loading" class="papers-list">
        <div v-for="paper in papers" :key="paper.arxiv_id" class="paper-card">
          <div class="paper-header">
            <h2 class="paper-title">{{ paper.title }}</h2>
            <button 
              @click="toggleBookmark(paper)" 
              :class="['bookmark-button', { 'bookmarked': isBookmarked(paper.arxiv_id) }]"
              :title="isBookmarked(paper.arxiv_id) ? 'Remove from bookmarks' : 'Add to bookmarks'"
            >
              <svg v-if="isBookmarked(paper.arxiv_id)" class="bookmark-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
              </svg>
              <svg v-else class="bookmark-icon" xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
              </svg>
            </button>
          </div>
          
          <div class="paper-meta">
            <div class="paper-authors">
              <svg class="meta-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
              <span>{{ paper.authors }}</span>
            </div>
            
            <div class="paper-date">
              <svg class="meta-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                <line x1="16" y1="2" x2="16" y2="6"></line>
                <line x1="8" y1="2" x2="8" y2="6"></line>
                <line x1="3" y1="10" x2="21" y2="10"></line>
              </svg>
              <span>{{ formatDate(paper.published_date) }}</span>
            </div>
          </div>
          
          <div class="paper-abstract">
            <p>{{ paper.abstract }}</p>
          </div>
          
          <div class="paper-actions">
            <a :href="getPdfUrl(paper.url)" target="_blank" class="action-button pdf-button">
              <svg class="action-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
              </svg>
              View PDF
            </a>
            <a :href="paper.url" target="_blank" class="action-button arxiv-button">
              <svg class="action-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                <polyline points="15 3 21 3 21 9"></polyline>
                <line x1="10" y1="14" x2="21" y2="3"></line>
              </svg>
              arXiv Page
            </a>
            <router-link :to="`/papers/${paper.arxiv_id}/citations`" class="action-button citation-button">
              <svg class="action-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <line x1="6" y1="3" x2="6" y2="15"></line>
                <circle cx="18" cy="6" r="3"></circle>
                <circle cx="6" cy="18" r="3"></circle>
                <path d="M18 9a9 9 0 0 1-9 9"></path>
              </svg>
              Citations
            </router-link>
          </div>
        </div>
      </div>
      
      <div v-if="papers.length > 0 && !loading" class="pagination">
        <button 
          :disabled="currentPage === 1" 
          @click="changePage(currentPage - 1)"
          class="pagination-button prev-button"
        >
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="15 18 9 12 15 6"></polyline>
          </svg>
          Previous
        </button>
        <div class="pagination-info">Page {{ currentPage }}</div>
        <button 
          @click="changePage(currentPage + 1)"
          class="pagination-button next-button"
        >
          Next
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="9 18 15 12 9 6"></polyline>
          </svg>
        </button>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref, computed, onMounted } from 'vue';
  import { useStore } from 'vuex';
  
  const store = useStore();
  
  const searchQuery = ref('');
  const papers = ref([]);
  const loading = ref(false);
  const error = ref(null);
  const currentPage = ref(1);
  const bookmarkedPapers = ref([]);
  
  onMounted(async () => {
    try {
      // First check authentication status
      const authResponse = await fetch('/api/v1/auth/status', {
        headers: {
          'Authorization': store.getters.isLoggedIn ? `Bearer ${store.state.token}` : ''
        }
      });
      
      const authData = await authResponse.json();
      console.log('Authentication status:', authData);
      
      if (authData.authenticated) {
        // Now fetch bookmarks if authenticated
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
      console.error('Error during component initialization:', err);
    }
  });
  
  const getPdfUrl = (absUrl) => {     
    return absUrl.replace('/abs/', '/pdf/') + '.pdf';
  };
  
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
        // Find the bookmark ID to delete
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
              'Authorization': `Bearer ${store.state.token}`
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
  </script>
  
  <style scoped>
  .paper-search-container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 0 var(--space-md);
  }
  
  .search-header {
    text-align: center;
    margin-bottom: var(--space-xl);
  }
  
  .search-header h1 {
    font-size: 2rem;
    margin-bottom: var(--space-xs);
    background: linear-gradient(45deg, var(--accent-primary), var(--accent-secondary));
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
  }
  
  .search-subtitle {
    color: var(--text-secondary);
    font-size: 1.1rem;
  }
  
  .search-panel {
    margin-bottom: var(--space-xl);
  }
  
  .search-form {
    width: 100%;
  }
  
  .search-input-wrapper {
    position: relative;
    display: flex;
    align-items: center;
  }
  
  .search-icon {
    position: absolute;
    left: var(--space-md);
    color: var(--text-tertiary);
  }
  
  .search-input {
    flex: 1;
    padding: var(--space-md) var(--space-md) var(--space-md) calc(var(--space-md) * 3);
    border-radius: var(--radius-md) 0 0 var(--radius-md);
    border: 1px solid var(--border-color);
    background-color: var(--bg-tertiary);
    color: var(--text-primary);
    font-size: 1rem;
  }
  
  .search-input:focus {
    outline: none;
    border-color: var(--accent-primary);
  }
  
  .search-button {
    background: var(--accent-primary);
    color: white;
    border: none;
    padding: var(--space-md) var(--space-lg);
    border-radius: 0 var(--radius-md) var(--radius-md) 0;
    font-size: 1rem;
    font-weight: 600;
    cursor: pointer;
    transition: background-color var(--transition);
  }
  
  .search-button:hover {
    background-color: #2a75e6;
  }
  
  .loading-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: var(--space-xl) 0;
    color: var(--text-secondary);
  }
  
  .loader {
    border: 3px solid var(--bg-tertiary);
    border-radius: 50%;
    border-top: 3px solid var(--accent-primary);
    width: 40px;
    height: 40px;
    animation: spin 1s linear infinite;
    margin-bottom: var(--space-md);
  }
  
  @keyframes spin {
    0% { transform: rotate(0deg); }
    100% { transform: rotate(360deg); }
  }
  
  .error-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: var(--space-xl) 0;
    color: var(--error);
  }
  
  .error-state svg {
    margin-bottom: var(--space-md);
  }
  
  .retry-button {
    margin-top: var(--space-md);
    padding: var(--space-sm) var(--space-md);
    background-color: var(--bg-tertiary);
    color: var(--text-primary);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-sm);
    cursor: pointer;
  }
  
  .no-results {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: var(--space-xl) 0;
    color: var(--text-secondary);
  }
  
  .no-results-hint {
    font-size: 0.9rem;
    margin-top: var(--space-xs);
    color: var(--text-tertiary);
  }
  
  .results-info {
    margin-bottom: var(--space-md);
    color: var(--text-secondary);
    font-size: 0.9rem;
  }
  
  .papers-list {
    display: flex;
    flex-direction: column;
    gap: var(--space-lg);
  }
  
  .paper-card {
    background-color: var(--bg-secondary);
    border-radius: var(--radius-md);
    border: 1px solid var(--border-color);
    padding: var(--space-lg);
    transition: all var(--transition);
  }
  
  .paper-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    border-color: var(--accent-primary);
  }
  
  .paper-header {
    display: flex;
    justify-content: space-between;
    gap: var(--space-md);
    margin-bottom: var(--space-md);
  }
  
  .paper-title {
    font-size: 1.25rem;
    margin: 0;
    color: var(--text-primary);
    line-height: 1.4;
    flex: 1;
  }
  
  .bookmark-button {
    background: none;
    border: none;
    color: var(--text-tertiary);
    cursor: pointer;
    padding: var(--space-xs);
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all var(--transition);
  }
  
  .bookmark-button:hover {
    background-color: rgba(255, 255, 255, 0.05);
    color: var(--text-primary);
  }
  
  .bookmark-button.bookmarked {
    color: #FFC107;
  }
  
  .paper-meta {
    display: flex;
    flex-wrap: wrap;
    gap: var(--space-md);
    margin-bottom: var(--space-md);
  }
  
  .paper-authors, .paper-date {
    display: flex;
    align-items: center;
    gap: var(--space-xs);
    color: var(--text-secondary);
    font-size: 0.9rem;
  }
  
  .meta-icon {
    color: var(--text-tertiary);
  }
  
  .paper-abstract {
    color: var(--text-secondary);
    line-height: 1.6;
    margin-bottom: var(--space-lg);
    font-size: 0.95rem;
    max-height: 150px;
    overflow: hidden;
    position: relative;
  }
  
  .paper-abstract::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 40px;
    background: linear-gradient(transparent, var(--bg-secondary));
  }
  
  .paper-actions {
    display: flex;
    flex-wrap: wrap;
    gap: var(--space-md);
  }
  
  .action-button {
    display: flex;
    align-items: center;
    gap: var(--space-xs);
    padding: var(--space-sm) var(--space-md);
    border-radius: var(--radius-sm);
    font-size: 0.9rem;
    font-weight: 500;
    text-decoration: none;
    transition: all var(--transition);
  }
  
  .action-icon {
    width: 16px;
    height: 16px;
  }
  
  .pdf-button {
    background-color: rgba(33, 150, 243, 0.15);
    color: #2196F3;
  }
  
  .pdf-button:hover {
    background-color: rgba(33, 150, 243, 0.25);
  }
  
  .arxiv-button {
    background-color: rgba(76, 175, 80, 0.15);
    color: #4CAF50;
  }
  
  .arxiv-button:hover {
    background-color: rgba(76, 175, 80, 0.25);
  }
  
  .citation-button {
    background-color: rgba(156, 39, 176, 0.15);
    color: #9C27B0;
  }
  
  .citation-button:hover {
    background-color: rgba(156, 39, 176, 0.25);
  }
  
  .pagination {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: var(--space-lg);
    margin-top: var(--space-xl);
    padding: var(--space-md) 0;
  }
  
  .pagination-button {
    display: flex;
    align-items: center;
    gap: var(--space-xs);
    padding: var(--space-sm) var(--space-md);
    background-color: var(--bg-tertiary);
    color: var(--text-primary);
    border: 1px solid var(--border-color);
    border-radius: var(--radius-sm);
    font-size: 0.9rem;
    cursor: pointer;
    transition: all var(--transition);
  }
  
  .pagination-button:hover:not(:disabled) {
    background-color: var(--accent-primary);
    color: white;
    border-color: var(--accent-primary);
  }
  
  .pagination-button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
  }
  
  .pagination-info {
    color: var(--text-secondary);
    font-size: 0.9rem;
  }
  
  @media (max-width: 768px) {
    .paper-header {
      flex-direction: column;
      gap: var(--space-sm);
    }
    
    .bookmark-button {
      align-self: flex-start;
    }
    
    .paper-actions {
      flex-direction: column;
      gap: var(--space-sm);
    }
    
    .action-button {
      width: 100%;
    }
    
    .pagination {
      flex-direction: column;
      gap: var(--space-md);
    }
  }
  </style>
  