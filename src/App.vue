<template>
  <div class="min-h-screen font-sans bg-white dark:bg-heygen-dark-bg transition-colors duration-200">
    <header class="bg-white dark:bg-heygen-dark-surface shadow">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 flex justify-between items-center">
        <h1 class="text-3xl font-bold text-heygen-dark dark:text-white">Heygen Voice Explorer</h1>
        <ThemeToggle />
      </div>
    </header>
    <main>
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <VoiceExplorer />
      </div>
    </main>
  </div>
</template>

<script>
import VoiceExplorer from './components/VoiceExplorer.vue'
import ThemeToggle from './components/ThemeToggle.vue'

export default {
  name: 'App',
  components: {
    VoiceExplorer,
    ThemeToggle
  }
}
</script>

<style>
body {
  @apply transition-colors duration-200;
}
</style> 