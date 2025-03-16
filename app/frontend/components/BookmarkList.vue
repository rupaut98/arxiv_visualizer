<template>
    <div class="bookmarks-container">
      <div class="bookmarks-header">
        <h1>Your Bookmarked Papers</h1>
        <p class="subtitle">Manage your saved research papers</p>
      </div>
      
      <div v-if="loading" class="loading-state">
        <div class="loader"></div>
        <p>Loading your bookmarks...</p>
      </div>
      
      <div v-else-if="bookmarks.length === 0" class="empty-state">
        <div class="empty-icon">
          <svg xmlns="http://www.w3.org/2000/svg" width="64" height="64" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
          </svg>
        </div>
        <h2>No Bookmarks Yet</h2>
        <p>You haven't bookmarked any papers. Start exploring to find papers you want to save for later.</p>
        <router-link to="/search" class="action-button primary-button">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          Search Papers
        </router-link>
      </div>
      
      <div v-else class="bookmark-list">
        <div v-for="bookmark in bookmarks" :key="bookmark.id" class="bookmark-card">
          <div class="bookmark-header">
            <h2 class="paper-title">{{ bookmark.paper.title }}</h2>
            <button @click="removeBookmark(bookmark.id)" class="icon-button" title="Remove bookmark">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="3 6 5 6 21 6"></polyline>
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                <line x1="10" y1="11" x2="10" y2="17"></line>
                <line x1="14" y1="11" x2="14" y2="17"></line>
              </svg>
            </button>
          </div>
          
          <div class="paper-meta">
            <div class="paper-authors">
              <svg class="meta-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
              <span>{{ bookmark.paper.authors }}</span>
            </div>
            
            <div class="paper-date">
              <svg class="meta-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                <line x1="16" y1="2" x2="16" y2="6"></line>
                <line x1="8" y1="2" x2="8" y2="6"></line>
                <line x1="3" y1="10" x2="21" y2="10"></line>
              </svg>
              <span>{{ formatDate(bookmark.paper.published_date) }}</span>
            </div>
          </div>
          
          <div class="paper-abstract">
            <p>{{ truncateAbstract(bookmark.paper.abstract) }}</p>
          </div>
          
          <div v-if="bookmark.notes" class="notes-card">
            <div class="notes-header">
              <svg class="notes-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
              </svg>
              <span>Your Notes</span>
            </div>
            <p>{{ bookmark.notes }}</p>
          </div>
          
          <div class="paper-actions">
            <a :href="bookmark.paper.url" target="_blank" class="action-button arxiv-button">
              <svg class="action-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                <polyline points="15 3 21 3 21 9"></polyline>
                <line x1="10" y1="14" x2="21" y2="3"></line>
              </svg>
              arXiv Page
            </a>
            <a :href="getPdfUrl(bookmark.paper.url)" target="_blank" class="action-button pdf-button">
              <svg class="action-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
              </svg>
              View PDF
            </a>
          </div>
        </div>
      </div>
      <confirm-dialog ref="confirmDialog"></confirm-dialog>
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { useStore } from 'vuex';
  import axios from 'axios'; 
  import ConfirmDialog from './ConfirmDialog.vue';
  
  const store = useStore();
  const bookmarks = ref([]);
  const loading = ref(true);
  const confirmDialog = ref(null);
  
  onMounted(() => {
    // Debug token storage
    const token = localStorage.getItem('token');
    console.log('Token in localStorage:', token ? `${token.substring(0, 15)}...` : 'No token found');
    console.log('Authorization header:', `Bearer ${token}`.substring(0, 20) + '...');
    
    fetchBookmarks();
  });
  
  const fetchBookmarks = async () => {
    try {
      loading.value = true;
      
      // Get token from localStorage
      const token = localStorage.getItem('token');
      
      // Make request with Authorization header
      const response = await axios.get('/api/v1/bookmarks', {
        headers: {
          'Authorization': `Bearer ${token}`,
          'X-Authorization': `Bearer ${token}`, // Try an alternative format
          'HTTP_AUTHORIZATION': `Bearer ${token}`
        }
      });
      
      console.log('Bookmarks response:', response);
      bookmarks.value = response.data;
    } catch (error) {
      console.error('Error fetching bookmarks:', error.response?.data || error.message);
    } finally {
      loading.value = false;
    }
  };
  
  const removeBookmark = async (id) => {
    // Use the dialog instead of the browser confirm
    const confirmed = await confirmDialog.value.show({
      title: 'Delete Bookmark',
      message: 'Are you sure you want to remove this bookmark? This action cannot be undone.',
      confirmText: 'Delete'
    });
    
    if (confirmed) {
      try {
        // Get token from localStorage
        const token = localStorage.getItem('token');
        
        // Make sure to include the Authorization header
        await axios.delete(`/api/v1/bookmarks/${id}`, {
          headers: {
            'Authorization': `Bearer ${token}`
          }
        });
        
        bookmarks.value = bookmarks.value.filter(bookmark => bookmark.id !== id);
      } catch (error) {
        console.error('Error removing bookmark:', error);
      }
    }
  };
  
  const getPdfUrl = (absUrl) => {
    if (!absUrl) return '#';
    return absUrl.replace('/abs/', '/pdf/') + '.pdf';
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
  
  const truncateAbstract = (abstract) => {
    if (!abstract) return '';
    return abstract.length > 300 ? abstract.substring(0, 300) + '...' : abstract;
  };
  </script>
  
  <style scoped>
  .bookmarks-container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 0 var(--space-md);
  }
  
  .bookmarks-header {
    text-align: center;
    margin-bottom: var(--space-xl);
  }
  
  .bookmarks-header h1 {
    font-size: 2rem;
    margin-bottom: var(--space-xs);
    background: linear-gradient(45deg, var(--accent-primary), var(--accent-secondary));
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
  }
  
  .subtitle {
    color: var(--text-secondary);
  }
  
  /* Loading State */
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
  
  /* Empty State */
  .empty-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    padding: var(--space-xl) 0;
    color: var(--text-secondary);
  }
  
  .empty-icon {
    margin-bottom: var(--space-lg);
    color: var(--text-tertiary);
    opacity: 0.6;
  }
  
  .empty-state h2 {
    margin-bottom: var(--space-md);
    color: var(--text-primary);
  }
  
  .empty-state p {
    max-width: 500px;
    margin-bottom: var(--space-lg);
  }
  
  /* Bookmark List */
  .bookmark-list {
    display: flex;
    flex-direction: column;
    gap: var(--space-lg);
    margin-top: var(--space-lg);
  }
  
  .bookmark-card {
    background-color: var(--bg-secondary);
    border-radius: var(--radius-md);
    border: 1px solid var(--border-color);
    padding: var(--space-lg);
    transition: all var(--transition);
  }
  
  .bookmark-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
    border-color: var(--accent-primary);
  }
  
  .bookmark-header {
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    margin-bottom: var(--space-md);
  }
  
  .paper-title {
    font-size: 1.25rem;
    margin: 0;
    color: var(--text-primary);
    line-height: 1.4;
    flex: 1;
  }
  
  .icon-button {
    background: none;
    border: none;
    color: var(--text-tertiary);
    cursor: pointer;
    padding: var(--space-xs);
    border-radius: var(--radius-sm);
    transition: all var(--transition);
  }
  
  .icon-button:hover {
    background-color: rgba(255, 255, 255, 0.05);
    color: var(--error);
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
    position: relative;
  }
  
  .notes-card {
    background-color: var(--bg-tertiary);
    border-radius: var(--radius-sm);
    padding: var(--space-md);
    margin-bottom: var(--space-lg);
    font-size: 0.9rem;
  }
  
  .notes-header {
    display: flex;
    align-items: center;
    gap: var(--space-xs);
    margin-bottom: var(--space-xs);
    color: var(--accent-primary);
    font-weight: 600;
  }
  
  .notes-icon {
    color: var(--accent-primary);
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
    border: none;
    cursor: pointer;
    font-family: inherit;
  }
  
  .action-icon {
    width: 16px;
    height: 16px;
  }
  
  .primary-button {
    background-color: var(--accent-primary);
    color: white;
  }
  
  .primary-button:hover {
    background-color: #2a75e6;
  }
  
  .arxiv-button {
    background-color: rgba(76, 175, 80, 0.15);
    color: #4CAF50;
  }
  
  .arxiv-button:hover {
    background-color: rgba(76, 175, 80, 0.25);
  }
  
  .pdf-button {
    background-color: rgba(233, 30, 99, 0.15);
    color: #E91E63;
  }
  
  .pdf-button:hover {
    background-color: rgba(233, 30, 99, 0.25);
  }
  
  @media (max-width: 768px) {
    .bookmark-header {
      flex-direction: column;
      gap: var(--space-sm);
      align-items: flex-start;
    }
    
    .icon-button {
      align-self: flex-end;
      margin-top: calc(var(--space-sm) * -1);
    }
    
    .paper-meta {
      flex-direction: column;
      gap: var(--space-xs);
    }
    
    .paper-actions {
      flex-direction: column;
      gap: var(--space-sm);
    }
    
    .action-button {
      width: 100%;
      justify-content: center;
    }
  }
  </style>
  