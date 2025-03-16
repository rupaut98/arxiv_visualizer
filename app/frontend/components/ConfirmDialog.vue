
<template>
    <div v-if="visible" 
         class="fixed inset-0 bg-black/70 backdrop-blur-sm flex justify-center items-center z-50"
         @click="cancel">
      <div class="w-11/12 max-w-md bg-gray-900/90 backdrop-blur-md rounded-xl border border-gray-800 shadow-2xl overflow-hidden transform transition-all duration-300 scale-100 opacity-100"
           :class="{ 'scale-95 opacity-0': closing }"
           @click.stop>
        
        <!-- Dialog header -->
        <div class="flex justify-between items-center p-5 border-b border-gray-800">
          <h3 class="text-xl font-medium bg-gradient-to-r from-blue-500 to-purple-600 inline-block text-transparent bg-clip-text">
            {{ title }}
          </h3>
          <button @click="cancel" 
                  class="p-1.5 rounded-lg text-gray-500 hover:text-white hover:bg-white/5 transition-colors focus:outline-none">
            <svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="18" y1="6" x2="6" y2="18"></line>
              <line x1="6" y1="6" x2="18" y2="18"></line>
            </svg>
          </button>
        </div>
        
        <!-- Dialog body -->
        <div class="p-6 text-gray-300">
          <div class="flex gap-4 items-start">
            <div class="flex-shrink-0">
              <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 text-red-500/80" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="1.5">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
              </svg>
            </div>
            <p class="text-lg">{{ message }}</p>
          </div>
        </div>
        
        <!-- Dialog footer -->
        <div class="flex justify-end gap-3 px-6 py-4 border-t border-gray-800 bg-gray-900/50">
          <button @click="cancel" 
                  class="px-4 py-2 rounded-lg bg-gray-800 text-white hover:bg-gray-700 transition-colors focus:outline-none focus:ring-2 focus:ring-gray-700/50 focus:ring-offset-2 focus:ring-offset-gray-900">
            Cancel
          </button>
          <button @click="confirm" 
                  class="px-5 py-2 rounded-lg bg-gradient-to-r from-red-500 to-red-600 text-white shadow-md hover:shadow-lg hover:shadow-red-500/20 hover:-translate-y-0.5 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-red-500/50 focus:ring-offset-2 focus:ring-offset-gray-900">
            {{ confirmText }}
          </button>
        </div>
      </div>
    </div>
  </template>
  
  <script setup>
  import { ref } from 'vue';
  
  const visible = ref(false);
  const closing = ref(false);
  const title = ref('Confirm Action');
  const message = ref('Are you sure you want to proceed?');
  const confirmText = ref('Confirm');
  let resolvePromise = null;
  
  const show = (options = {}) => {
    title.value = options.title || 'Confirm Action';
    message.value = options.message || 'Are you sure you want to proceed?';
    confirmText.value = options.confirmText || 'Confirm';
    closing.value = false;
    visible.value = true;
    
    return new Promise(resolve => {
      resolvePromise = resolve;
    });
  };
  
  const confirm = () => {
    close(true);
  };
  
  const cancel = () => {
    close(false);
  };
  
  const close = (result) => {
    closing.value = true;
    setTimeout(() => {
      visible.value = false;
      closing.value = false;
      if (resolvePromise) resolvePromise(result);
    }, 200);
  };
  
  defineExpose({ show });
  </script>
  
  <style>
  @keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
  }
  
  @keyframes slideIn {
    from { transform: translateY(-20px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
  }
  
  .animate-fadeIn {
    animation: fadeIn 0.2s ease-out forwards;
  }
  
  .animate-slideIn {
    animation: slideIn 0.3s ease-out forwards;
  }
  </style>
  