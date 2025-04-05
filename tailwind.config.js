module.exports = {
  content: ['./public/**/*.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  darkMode: 'class',
  theme: {
    extend: {
      colors: {
        'heygen-primary': '#4F46E5',
        'heygen-secondary': '#10B981',
        'heygen-dark': '#1F2937',
        'heygen-light': '#F3F4F6',
        'heygen-dark-bg': '#111827',
        'heygen-dark-surface': '#1F2937',
        'heygen-dark-hover': '#374151',
      },
    },
  },
  plugins: [],
} 