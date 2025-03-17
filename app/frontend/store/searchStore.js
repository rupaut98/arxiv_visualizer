import { defineStore } from 'pinia';

//search state storage
export const useSearchStore = defineStore('search', {
  state: () => ({
    searchQuery: '',
    papers: [],
    currentPage: 1,
    hasSearched: false,
    bookmarkedPapers: []
  }),
  
  actions: {
    setSearchQuery(query) {
      this.searchQuery = query;
    },
    setResults(results) {
      this.papers = results;
    },
    setPage(page) {
      this.currentPage = page;
    },
    setHasSearched(value) {
      this.hasSearched = value;
    },
    setBookmarkedPapers(papers) { //update bookmarked papers list
      this.bookmarkedPapers = papers;
    },
    addBookmark(arxivId) { //add paper to bookmarks
      if (!this.bookmarkedPapers.includes(arxivId)) {
        this.bookmarkedPapers.push(arxivId);
      }
    },
    removeBookmark(arxivId) { //remove paper from bookmarks
      this.bookmarkedPapers = this.bookmarkedPapers.filter(id => id !== arxivId);
    }
  },
  
  persist: true //maintain state between page reloads
});
