<!-- components/ConfirmDialog.vue -->
<template>
    <div v-if="visible" class="modal-overlay" @click="cancel">
      <div class="modal-container" @click.stop>
        <div class="modal-header">
          <h3>{{ title }}</h3>
          <button @click="cancel" class="close-button">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>
        <div class="modal-body">
          <p>{{ message }}</p>
        </div>
        <div class="modal-footer">
          <button @click="cancel" class="modal-button cancel-button">Cancel</button>
          <button @click="confirm" class="modal-button confirm-button">{{ confirmText }}</button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  const visible = ref(false);
  const title = ref('Confirm Action');
  const message = ref('Are you sure you want to proceed?');
  const confirmText = ref('Confirm');
  let resolvePromise = null;
  
  const show = (options = {}) => {
    title.value = options.title || 'Confirm Action';
    message.value = options.message || 'Are you sure you want to proceed?';
    confirmText.value = options.confirmText || 'Confirm';
    visible.value = true;
    
    return new Promise(resolve => {
      resolvePromise = resolve;
    });
  };
  
  const confirm = () => {
    visible.value = false;
    if (resolvePromise) resolvePromise(true);
  };
  
  const cancel = () => {
    visible.value = false;
    if (resolvePromise) resolvePromise(false);
  };
  
  defineExpose({ show });
  </script>
  
  <style scoped>
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.7);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 100;
    animation: fadeIn 0.2s ease;
  }
  
  .modal-container {
    background-color: var(--bg-secondary);
    border-radius: var(--radius-md);
    width: 90%;
    max-width: 450px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    overflow: hidden;
    animation: slideIn 0.2s ease;
  }
  
  .modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: var(--space-md) var(--space-lg);
    border-bottom: 1px solid var(--border-color);
  }
  
  .modal-header h3 {
    margin: 0;
    color: var(--text-primary);
  }
  
  .close-button {
    background: none;
    border: none;
    color: var(--text-tertiary);
    cursor: pointer;
    padding: var(--space-xs);
    border-radius: var(--radius-sm);
    display: flex;
    align-items: center;
    justify-content: center;
  }
  
  .close-button:hover {
    color: var(--text-primary);
    background-color: rgba(255, 255, 255, 0.05);
  }
  
  .modal-body {
    padding: var(--space-lg);
    color: var(--text-secondary);
  }
  
  .modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: var(--space-md);
    padding: var(--space-md) var(--space-lg);
    border-top: 1px solid var(--border-color);
  }
  
  .modal-button {
    padding: var(--space-sm) var(--space-lg);
    border-radius: var(--radius-sm);
    font-size: 0.95rem;
    cursor: pointer;
    border: none;
    font-family: inherit;
  }
  
  .cancel-button {
    background-color: var(--bg-tertiary);
    color: var(--text-primary);
  }
  
  .confirm-button {
    background-color: var(--error);
    color: white;
  }
  
  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }
  
  @keyframes slideIn {
    from { transform: translateY(-20px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
  }
  </style>
  