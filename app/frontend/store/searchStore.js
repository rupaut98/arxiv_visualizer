import { defineStore } from 'pinia';

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
    setBookmarkedPapers(papers) {
      this.bookmarkedPapers = papers;
    },
    addBookmark(arxivId) {
      if (!this.bookmarkedPapers.includes(arxivId)) {
        this.bookmarkedPapers.push(arxivId);
      }
    },
    removeBookmark(arxivId) {
      this.bookmarkedPapers = this.bookmarkedPapers.filter(id => id !== arxivId);
    }
  },
  
  persist: true
});
