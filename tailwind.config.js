// tailwind.config.js
module.exports = {
    content: [
      "./app/frontend/**/*.{vue,js,ts,jsx,tsx}",
      "./app/views/**/*.{erb,html}"
    ],
    theme: {
      extend: {
        colors: {
          // Add the color utilities you're using
          white: '#ffffff',
          transparent: 'transparent',
          gray: {
            300: '#d1d5db',
            500: '#6b7280',
            700: '#374151',
            800: '#1f2937',
            900: '#111827',
            950: '#030712'
          },
          blue: {
            500: '#3b82f6'
          },
          purple: {
            600: '#9333ea'
          },
          red: {
            500: '#ef4444'
          }
        }
      }
    },
    plugins: []
  }
  