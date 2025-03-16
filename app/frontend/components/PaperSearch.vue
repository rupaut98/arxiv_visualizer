<template>
    <div class="max-w-4xl mx-auto px-4">
      <div class="text-center mb-12">
        <h1 class="text-3xl font-bold mb-2 bg-gradient-to-r from-blue-500 to-purple-600 inline-block text-transparent bg-clip-text">
          Search arXiv Papers
        </h1>
        <p class="text-gray-300 text-lg">Discover and organize research papers from arXiv</p>
      </div>
      
      <div class="mb-12">
        <div class="w-full">
          <div class="relative flex items-center">
            <svg class="absolute left-4 text-gray-500 w-5 h-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <circle cx="11" cy="11" r="8"></circle>
              <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
            </svg>
            <input 
              type="text" 
              v-model="searchQuery" 
              placeholder="Search by title, author, or keyword..." 
              @keyup.enter="searchPapers"
              class="flex-1 py-4 pl-12 pr-4 rounded-l-lg border border-gray-700 bg-gray-800 text-white focus:outline-none focus:border-blue-500 focus:ring-1 focus:ring-blue-500/30 transition-colors"
            />
            <button 
              @click="searchPapers" 
              class="bg-gradient-to-r from-blue-500 to-purple-600 text-white font-semibold py-4 px-6 rounded-r-lg transition duration-200 hover:shadow-lg hover:shadow-blue-500/20 hover:-translate-y-0.5"
            >
              Search
            </button>
          </div>
        </div>
      </div>
      
      <div v-if="loading" class="flex flex-col items-center justify-center py-16 text-gray-300">
        <div class="w-10 h-10 border-3 border-gray-700 border-t-blue-500 rounded-full animate-spin mb-4"></div>
        <p>Searching arXiv database...</p>
      </div>
      
      <div v-else-if="error" class="flex flex-col items-center text-center py-16 text-red-500">
        <svg xmlns="http://www.w3.org/2000/svg" class="w-12 h-12 mb-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <circle cx="12" cy="12" r="10"></circle>
          <line x1="12" y1="8" x2="12" y2="12"></line>
          <line x1="12" y1="16" x2="12.01" y2="16"></line>
        </svg>
        <p>{{ error }}</p>
        <button 
          @click="searchPapers" 
          class="mt-4 px-4 py-2 bg-gray-800 text-white border border-gray-700 rounded-lg hover:bg-gray-700 transition-colors"
        >
          Try Again
        </button>
      </div>
      

      <div v-else-if="papers.length === 0 && searchQuery && hasSearched" class="flex flex-col items-center text-center py-16 text-gray-300">
        <p>No papers found for "{{ searchQuery }}"</p>
        <p class="text-sm text-gray-500 mt-1">Try different keywords or check your spelling</p>
      </div>
      

      <div v-else-if="papers.length > 0" class="mb-4 text-gray-300 text-sm">
        <span>Showing results for "{{ searchQuery }}"</span>
      </div>
      

      <div v-if="papers.length > 0 && !loading" class="flex flex-col space-y-6">
        <div 
          v-for="paper in papers" 
          :key="paper.arxiv_id" 
          class="bg-gray-900 bg-opacity-80 backdrop-blur-md rounded-xl border border-gray-800 p-6 transition duration-300 hover:-translate-y-1 hover:shadow-lg hover:border-blue-500/50"
        >
        <div class="flex justify-between items-start gap-4 mb-4">
            <h2 class="text-xl font-medium text-white leading-tight">{{ paper.title }}</h2>
            <button 
                @click="toggleBookmark(paper)" 
                :class="[
                'p-1.5 rounded-lg transition-colors flex-shrink-0 h-8 w-8 flex items-center justify-center', 
                isBookmarked(paper.arxiv_id) 
                    ? 'text-yellow-400 hover:bg-yellow-500/10' 
                    : 'text-gray-500 hover:text-white hover:bg-white/5'
                ]"
                :title="isBookmarked(paper.arxiv_id) ? 'Remove from bookmarks' : 'Add to bookmarks'"
            >
              <svg 
                class="w-5 h-5" 
                xmlns="http://www.w3.org/2000/svg" 
                viewBox="0 0 24 24" 
                :fill="isBookmarked(paper.arxiv_id) ? 'currentColor' : 'none'" 
                stroke="currentColor" 
                stroke-width="2" 
                stroke-linecap="round" 
                stroke-linejoin="round"
              >
                <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
              </svg>
            </button>
          </div>
          
          <div class="flex flex-wrap gap-4 mb-4">
            <div class="flex items-center gap-1 text-gray-300 text-sm">
              <svg class="w-4 h-4 text-gray-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
              <span>{{ paper.authors }}</span>
            </div>
            
            <div class="flex items-center gap-1 text-gray-300 text-sm">
              <svg class="w-4 h-4 text-gray-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                <line x1="16" y1="2" x2="16" y2="6"></line>
                <line x1="8" y1="2" x2="8" y2="6"></line>
                <line x1="3" y1="10" x2="21" y2="10"></line>
              </svg>
              <span>{{ formatDate(paper.published_date) }}</span>
            </div>
          </div>
          
          <div class="text-gray-300 leading-relaxed text-sm mb-6 max-h-36 overflow-hidden relative">
            <p>{{ paper.abstract }}</p>
            <div class="absolute bottom-0 left-0 right-0 h-10 bg-gradient-to-t from-gray-900 to-transparent"></div>
          </div>
          
          <div class="flex flex-wrap gap-3">
            <a 
              :href="getPdfUrl(paper.url)" 
              target="_blank" 
              class="flex items-center gap-1 px-4 py-2 bg-blue-500/10 text-blue-400 rounded-lg hover:bg-blue-500/20 transition-colors"
            >
              <svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
                <polyline points="14 2 14 8 20 8"></polyline>
              </svg>
              View PDF
            </a>
            
            <a 
              :href="paper.url" 
              target="_blank" 
              class="flex items-center gap-1 px-4 py-2 bg-green-500/10 text-green-400 rounded-lg hover:bg-green-500/20 transition-colors"
            >
              <svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                <polyline points="15 3 21 3 21 9"></polyline>
                <line x1="10" y1="14" x2="21" y2="3"></line>
              </svg>
              arXiv Page
            </a>
            
            <router-link 
              :to="`/papers/${paper.arxiv_id}/citations`" 
              class="flex items-center gap-1 px-4 py-2 bg-purple-500/10 text-purple-400 rounded-lg hover:bg-purple-500/20 transition-colors"
            >
              <svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
      

      <div v-if="papers.length > 0 && !loading" class="flex justify-center items-center gap-8 mt-12 py-4">
        <button 
          :disabled="currentPage === 1" 
          @click="changePage(currentPage - 1)"
          :class="[
            'flex items-center gap-1 px-4 py-2 border rounded-lg transition-colors',
            currentPage === 1 
              ? 'bg-gray-800/50 text-gray-500 border-gray-800 cursor-not-allowed' 
              : 'bg-gray-800 text-white border-gray-700 hover:bg-gray-700 hover:border-gray-600'
          ]"
        >
          <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <polyline points="15 18 9 12 15 6"></polyline>
          </svg>
          Previous
        </button>
        
        <div class="text-gray-300 text-sm">Page {{ currentPage }}</div>
        
        <button 
          @click="changePage(currentPage + 1)"
          class="flex items-center gap-1 px-4 py-2 bg-gray-800 text-white border border-gray-700 rounded-lg hover:bg-gray-700 hover:border-gray-600 transition-colors"
        >
          Next
          <svg class="w-5 h-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
  const hasSearched = ref(false);
  
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
    hasSearched.value = true;
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
  