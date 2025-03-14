<template>
    <div class="paper-list">
      <div v-for="paper in papers" :key="paper.arxiv_id" class="paper-card">
        <h3>{{ paper.title }}</h3>
        <div class="paper-meta">
          <span class="authors">{{ paper.authors }}</span>
          <span class="date">{{ formatDate(paper.published_date) }}</span>
        </div>
        <p class="abstract">{{ truncateAbstract(paper.abstract) }}</p>
        <div class="paper-actions">
          <button @click="viewPaper(paper)" class="view-btn">View Details</button>
          <button @click="$emit('bookmark', paper)" class="bookmark-btn">
            Bookmark
          </button>
          <a :href="paper.url" target="_blank" class="arxiv-link">View on ArXiv</a>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { defineProps, defineEmits } from 'vue'
  import { useRouter } from 'vue-router'
  
  const props = defineProps({
    papers: {
      type: Array,
      required: true
    }
  })
  
  const emit = defineEmits(['bookmark'])
  const router = useRouter()
  
  const formatDate = (dateString) => {
    if (!dateString) return ''
    const date = new Date(dateString)
    return date.toLocaleDateString()
  }
  
  const truncateAbstract = (abstract) => {
    if (!abstract) return ''
    return abstract.length > 300 ? abstract.substring(0, 300) + '...' : abstract
  }
  
  const viewPaper = (paper) => {
    router.push(`/papers/${paper.arxiv_id}`)
  }
  </script>
  
  <style scoped>
  .paper-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
  }
  
  .paper-card {
    padding: 20px;
    border: 1px solid #eee;
    border-radius: 5px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
    transition: transform 0.2s;
  }
  
  .paper-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
  
  h3 {
    margin-top: 0;
    color: #333;
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
    gap: 10px;
    margin-top: 15px;
  }
  
  button, .arxiv-link {
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
  
  .bookmark-btn {
    background: #48c774;
    color: white;
  }
  
  .arxiv-link {
    background: #f5f5f5;
    color: #333;
  }
  </style>
  