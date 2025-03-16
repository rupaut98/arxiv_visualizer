<template>
    <div class="max-w-5xl mx-auto px-4 py-8 relative">
      <!-- Background effects -->
      <div class="fixed inset-0 -z-10 opacity-15 pointer-events-none">
        <div class="absolute top-0 left-1/4 w-96 h-96 rounded-full bg-blue-500 blur-[150px]"></div>
        <div class="absolute bottom-0 right-1/4 w-96 h-96 rounded-full bg-purple-600 blur-[150px]"></div>
      </div>
      
      <!-- Page header -->
      <div class="text-center mb-12">
        <h1 class="text-3xl md:text-4xl font-bold mb-2 bg-gradient-to-r from-blue-500 to-purple-600 inline-block text-transparent bg-clip-text">
          Your Bookmarked Papers
        </h1>
        <p class="text-gray-300 text-lg">Manage your saved research papers</p>
      </div>
      
      <!-- Loading state -->
      <div v-if="loading" class="flex flex-col items-center justify-center py-16">
        <div class="w-12 h-12 border-3 border-t-blue-500 border-gray-700 rounded-full animate-spin mb-4"></div>
        <p class="text-gray-300">Loading your bookmarks...</p>
      </div>
      
      <!-- Empty state -->
      <div v-else-if="bookmarks.length === 0" class="flex flex-col items-center text-center py-12">
        <div class="text-gray-500 opacity-60 mb-6">
          <svg xmlns="http://www.w3.org/2000/svg" width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
          </svg>
        </div>
        <h2 class="text-2xl font-bold text-white mb-3">No Bookmarks Yet</h2>
        <p class="text-gray-300 max-w-md mb-8">You haven't bookmarked any papers. Start exploring to find papers you want to save for later.</p>
        <router-link to="/search" class="flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-blue-500 to-purple-600 text-white font-medium rounded-lg shadow-lg hover:shadow-blue-500/20 transition duration-300 hover:-translate-y-1">
          <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          Search Papers
        </router-link>
      </div>
      
      <!-- Bookmark list -->
      <div v-else class="flex flex-col space-y-6">
        <div v-for="bookmark in bookmarks" :key="bookmark.id" 
             class="bg-gray-900/80 backdrop-blur-md rounded-xl border border-gray-800 p-6 transition duration-300 hover:-translate-y-1 hover:shadow-lg hover:border-blue-500/50">
          <div class="flex justify-between items-start gap-4 mb-4">
            <h2 class="text-xl font-medium text-white leading-tight">{{ bookmark.paper.title }}</h2>
            <button @click="removeBookmark(bookmark.id)" 
                    class="p-2 rounded-lg text-gray-500 hover:text-red-400 hover:bg-red-500/10 transition-colors flex-shrink-0"
                    title="Remove bookmark">
              <svg xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="3 6 5 6 21 6"></polyline>
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                <line x1="10" y1="11" x2="10" y2="17"></line>
                <line x1="14" y1="11" x2="14" y2="17"></line>
              </svg>
            </button>
          </div>
          
          <div class="flex flex-wrap gap-4 mb-4">
            <div class="flex items-center gap-1.5 text-gray-300 text-sm">
              <svg class="w-4 h-4 text-gray-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                <circle cx="12" cy="7" r="4"></circle>
              </svg>
              <span>{{ bookmark.paper.authors }}</span>
            </div>
            
            <div class="flex items-center gap-1.5 text-gray-300 text-sm">
              <svg class="w-4 h-4 text-gray-500" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                <line x1="16" y1="2" x2="16" y2="6"></line>
                <line x1="8" y1="2" x2="8" y2="6"></line>
                <line x1="3" y1="10" x2="21" y2="10"></line>
              </svg>
              <span>{{ formatDate(bookmark.paper.published_date) }}</span>
            </div>
          </div>
          
          <div class="text-gray-300 leading-relaxed text-sm mb-6 relative">
            <p>{{ truncateAbstract(bookmark.paper.abstract) }}</p>
            <div class="absolute bottom-0 left-0 right-0 h-10 bg-gradient-to-t from-gray-900/80 to-transparent pointer-events-none"></div>
          </div>
          
          <div v-if="bookmark.notes" class="bg-gray-800/50 rounded-lg p-4 mb-6 text-sm border-l-2 border-blue-500">
            <div class="flex items-center gap-1.5 text-blue-400 font-medium mb-1.5">
              <svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"></path>
                <path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"></path>
              </svg>
              <span>Your Notes</span>
            </div>
            <p class="text-gray-300">{{ bookmark.notes }}</p>
          </div>
          
          <div class="flex flex-wrap gap-3">
            <a :href="bookmark.paper.url" target="_blank" 
               class="flex items-center gap-1.5 px-4 py-2 bg-green-500/10 text-green-400 rounded-lg hover:bg-green-500/20 transition-colors">
              <svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M18 13v6a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V8a2 2 0 0 1 2-2h6"></path>
                <polyline points="15 3 21 3 21 9"></polyline>
                <line x1="10" y1="14" x2="21" y2="3"></line>
              </svg>
              arXiv Page
            </a>
            
            <a :href="getPdfUrl(bookmark.paper.url)" target="_blank" 
               class="flex items-center gap-1.5 px-4 py-2 bg-pink-500/10 text-pink-400 rounded-lg hover:bg-pink-500/20 transition-colors">
              <svg class="w-4 h-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
  