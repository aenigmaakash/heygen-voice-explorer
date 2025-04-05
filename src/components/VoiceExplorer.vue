<template>
  <div>
    <!-- Filters and Search -->
    <div class="mb-8 bg-white dark:bg-heygen-dark-surface rounded-lg shadow p-6 transition-colors duration-200">
      <div class="flex flex-col md:flex-row md:items-center md:justify-between gap-4">
        <div class="w-full md:w-1/3">
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Search by name..."
            class="w-full px-4 py-2 rounded-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-heygen-primary transition-colors duration-200"
          />
        </div>
        <div class="flex flex-wrap gap-4">
          <select
            v-model="languageFilter"
            class="px-4 py-2 rounded-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-heygen-primary transition-colors duration-200"
          >
            <option value="">All Languages</option>
            <option v-for="language in uniqueLanguages" :key="language" :value="language">
              {{ language }}
            </option>
          </select>
          <select
            v-model="genderFilter"
            class="px-4 py-2 rounded-md border border-gray-300 dark:border-gray-600 bg-white dark:bg-gray-700 text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-heygen-primary transition-colors duration-200"
          >
            <option value="">All Genders</option>
            <option v-for="gender in uniqueGenders" :key="gender" :value="gender">
              {{ gender }}
            </option>
          </select>
          <div class="flex items-center gap-2">
            <input
              type="checkbox"
              id="emotionSupport"
              v-model="emotionSupportFilter"
              class="h-4 w-4 text-heygen-primary focus:ring-heygen-primary border-gray-300 dark:border-gray-600 rounded"
            />
            <label for="emotionSupport" class="text-sm text-gray-700 dark:text-gray-200 transition-colors duration-200">Emotion Support</label>
          </div>
        </div>
      </div>
    </div>

    <!-- Initial Loading State -->
    <div v-if="initialLoading" class="text-center py-12">
      <div class="inline-block animate-spin rounded-full h-12 w-12 border-4 border-heygen-primary border-t-transparent"></div>
      <p class="mt-4 text-heygen-dark dark:text-gray-200 transition-colors duration-200">Loading voices...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="bg-red-100 dark:bg-red-900 border border-red-400 dark:border-red-600 text-red-700 dark:text-red-200 px-4 py-3 rounded relative transition-colors duration-200" role="alert">
      <strong class="font-bold">Error!</strong>
      <span class="block sm:inline"> {{ error }}</span>
      <button @click="retryFetch" class="mt-2 bg-red-200 hover:bg-red-300 dark:bg-red-800 dark:hover:bg-red-700 text-red-800 dark:text-red-200 font-bold py-1 px-4 rounded transition-colors duration-200">
        Retry
      </button>
    </div>

    <!-- Results Display -->
    <div v-else ref="tableContainer" class="overflow-x-auto transition-colors duration-200">
      <!-- Results Count -->
      <div class="flex justify-between items-center mb-4">
        <p class="text-gray-600 dark:text-gray-300 transition-colors duration-200">
          Showing {{ displayedVoices.length }} of {{ totalFilteredCount }} {{ totalFilteredCount === 1 ? 'voice' : 'voices' }}
        </p>
        <div v-if="loadingMore" class="text-sm text-gray-600 dark:text-gray-300 flex items-center transition-colors duration-200">
          <div class="mr-2 w-4 h-4 border-2 border-heygen-primary border-t-transparent rounded-full animate-spin"></div>
          Loading more...
        </div>
      </div>

      <!-- Table View -->
      <table class="min-w-full bg-white dark:bg-heygen-dark-surface border border-gray-200 dark:border-gray-700 shadow-sm rounded-lg overflow-hidden transition-colors duration-200">
        <thead class="bg-gray-50 dark:bg-gray-800 transition-colors duration-200">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider transition-colors duration-200">Name</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider transition-colors duration-200">Language</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider transition-colors duration-200">Gender</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider transition-colors duration-200">Features</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider transition-colors duration-200">Preview</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider transition-colors duration-200">ID</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200 dark:divide-gray-700 transition-colors duration-200">
          <tr v-for="voice in displayedVoices" :key="voice.voice_id" class="hover:bg-gray-50 dark:hover:bg-heygen-dark-hover transition-colors duration-200">
            <td class="px-6 py-4 whitespace-nowrap text-sm font-medium text-gray-900 dark:text-gray-100 transition-colors duration-200">{{ voice.name }}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300 transition-colors duration-200">{{ voice.language }}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300 capitalize transition-colors duration-200">{{ voice.gender }}</td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300 transition-colors duration-200">
              <div class="flex flex-wrap gap-1">
                <span v-if="voice.emotion_support" class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-green-100 text-green-800 dark:bg-green-800 dark:text-green-100 transition-colors duration-200">
                  Emotion
                </span>
                <span v-if="voice.support_interactive_avatar" class="inline-flex items-center px-2 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-800 dark:text-blue-100 transition-colors duration-200">
                  Avatar
                </span>
              </div>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300 transition-colors duration-200">
              <button 
                @click="playPreview(voice)" 
                class="text-heygen-primary dark:text-blue-400 hover:text-heygen-secondary dark:hover:text-blue-300 focus:outline-none transition-colors duration-200"
                :disabled="voice.isLoading"
              >
                <span v-if="voice.isLoading" class="inline-block w-5 h-5 border-2 border-current border-t-transparent rounded-full animate-spin"></span>
                <span v-else-if="voice.isPlaying">
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zM7 8a1 1 0 012 0v4a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v4a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd" />
                  </svg>
                </span>
                <span v-else>
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM9.555 7.168A1 1 0 008 8v4a1 1 0 001.555.832l3-2a1 1 0 000-1.664l-3-2z" clip-rule="evenodd" />
                  </svg>
                </span>
              </button>
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-300 font-mono transition-colors duration-200">{{ voice.voice_id }}</td>
          </tr>
        </tbody>
      </table>

      <!-- No Results -->
      <div v-if="displayedVoices.length === 0" class="text-center py-12">
        <p class="text-gray-500 dark:text-gray-400 transition-colors duration-200">No voices match your filters. Try adjusting your search criteria.</p>
      </div>

      <!-- Loading More Indicator -->
      <div v-if="loadingMore" class="text-center py-8">
        <div class="inline-block w-8 h-8 border-4 border-heygen-primary border-t-transparent rounded-full animate-spin"></div>
        <p class="mt-2 text-gray-600 dark:text-gray-300 transition-colors duration-200">Loading more voices...</p>
      </div>

      <!-- Scroll Detector - invisible element to detect when user scrolls to bottom -->
      <div v-if="hasMoreToLoad" ref="scrollDetector" class="h-10 mt-4"></div>
    </div>

    <!-- Hidden audio elements -->
    <div class="hidden">
      <audio 
        ref="audioPlayer"
        @ended="onAudioEnded"
        @error="onAudioError"
      ></audio>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'VoiceExplorer',
  data() {
    return {
      initialLoading: true,
      loadingMore: false,
      allVoicesLoaded: false,
      error: null,
      allVoices: [], // All voices from API response
      voices: [], // Loaded voices (subset of allVoices)
      currentPage: 1,
      searchQuery: '',
      languageFilter: '',
      genderFilter: '',
      emotionSupportFilter: false,
      currentlyPlayingId: null,
      observer: null,
      // Get the API URL based on environment
      apiUrl: process.env.NODE_ENV === 'production' 
        ? '/api/voices'  // In production, use the server proxy
        : '/api/voices'  // In development, also use the proxy
    };
  },
  computed: {
    uniqueLanguages() {
      const languages = this.allVoices.map(voice => voice.language);
      return [...new Set(languages)].sort();
    },
    uniqueGenders() {
      const genders = this.allVoices.map(voice => voice.gender.toLowerCase());
      return [...new Set(genders)].sort();
    },
    filteredVoices() {
      return this.voices.filter(voice => {
        // Search by name
        const nameMatch = this.searchQuery === '' || 
          voice.name.toLowerCase().includes(this.searchQuery.toLowerCase());
        
        // Filter by language
        const languageMatch = this.languageFilter === '' || 
          voice.language === this.languageFilter;
        
        // Filter by gender (case insensitive)
        const genderMatch = this.genderFilter === '' || 
          voice.gender.toLowerCase() === this.genderFilter.toLowerCase();
        
        // Filter by emotion support
        const emotionMatch = !this.emotionSupportFilter || voice.emotion_support;
        
        return nameMatch && languageMatch && genderMatch && emotionMatch;
      });
    },
    totalFilteredCount() {
      // Calculate total count of voices that match filters
      return this.allVoices.filter(voice => {
        const nameMatch = this.searchQuery === '' || 
          voice.name.toLowerCase().includes(this.searchQuery.toLowerCase());
        const languageMatch = this.languageFilter === '' || 
          voice.language === this.languageFilter;
        const genderMatch = this.genderFilter === '' || 
          voice.gender.toLowerCase() === this.genderFilter.toLowerCase();
        const emotionMatch = !this.emotionSupportFilter || voice.emotion_support;
        
        return nameMatch && languageMatch && genderMatch && emotionMatch;
      }).length;
    },
    displayedVoices() {
      return this.filteredVoices.map(voice => ({
        ...voice,
        isPlaying: this.currentlyPlayingId === voice.voice_id,
        isLoading: false
      }));
    },
    hasMoreToLoad() {
      // Check if there are more voices to load based on filters
      return !this.allVoicesLoaded;
    }
  },
  watch: {
    // Reset and reload when filters change
    searchQuery() {
      this.resetAndApplyFilters();
    },
    languageFilter() {
      this.resetAndApplyFilters();
    },
    genderFilter() {
      this.resetAndApplyFilters();
    },
    emotionSupportFilter() {
      this.resetAndApplyFilters();
    }
  },
  created() {
    this.fetchVoices();
  },
  mounted() {
    this.setupInfiniteScroll();
  },
  updated() {
    this.setupInfiniteScroll();
  },
  beforeUnmount() {
    if (this.observer) {
      this.observer.disconnect();
    }
    
    if (this.$refs.audioPlayer) {
      this.$refs.audioPlayer.pause();
    }
  },
  methods: {
    async fetchVoices() {
      this.initialLoading = true;
      this.error = null;
      
      try {
        // Call the API through our server proxy
        const response = await axios.get(this.apiUrl);
        
        if (response.data && response.data.data && response.data.data.voices) {
          // Store all voices for filtering
          this.allVoices = response.data.data.voices;
          
          // Load initial batch
          this.loadInitialBatch();
        } else {
          throw new Error('Invalid API response format');
        }
      } catch (err) {
        console.error('Error fetching voices:', err);
        this.error = 'Failed to load voices: ' + (err.message || 'Unknown error');
        this.initialLoading = false;
      }
    },
    
    loadInitialBatch() {
      // Load initial 100 voices
      const initialBatchSize = 100;
      const initialVoices = this.getNextBatch(0, initialBatchSize);
      this.voices = initialVoices;
      this.initialLoading = false;
      
      // Check if all voices are loaded
      this.checkIfAllLoaded();
    },
    
    loadMoreVoices() {
      if (this.loadingMore || this.allVoicesLoaded) return;
      
      this.loadingMore = true;
      
      // Get the next batch of voices (20) with a small delay
      setTimeout(() => {
        const batchSize = 20;
        const nextVoices = this.getNextBatch(this.voices.length, batchSize);
        
        // Add new voices to the displayed list
        this.voices = [...this.voices, ...nextVoices];
        this.loadingMore = false;
        
        // Check if we've loaded all voices
        this.checkIfAllLoaded();
      }, 300);
    },
    
    getNextBatch(startIndex, batchSize) {
      // Filter all voices based on current filters to get the correct total
      const filteredAllVoices = this.allVoices.filter(voice => {
        const nameMatch = this.searchQuery === '' || 
          voice.name.toLowerCase().includes(this.searchQuery.toLowerCase());
        const languageMatch = this.languageFilter === '' || 
          voice.language === this.languageFilter;
        const genderMatch = this.genderFilter === '' || 
          voice.gender.toLowerCase() === this.genderFilter.toLowerCase();
        const emotionMatch = !this.emotionSupportFilter || voice.emotion_support;
        
        return nameMatch && languageMatch && genderMatch && emotionMatch;
      });
      
      // Return the next batch from the filtered results
      return filteredAllVoices.slice(startIndex, startIndex + batchSize);
    },
    
    checkIfAllLoaded() {
      // Check if we've loaded all voices that match the current filters
      this.allVoicesLoaded = this.voices.length >= this.totalFilteredCount;
    },
    
    resetAndApplyFilters() {
      // Reset to first batch when filters change
      this.voices = this.getNextBatch(0, 100);
      this.allVoicesLoaded = false;
      this.currentPage = 1;
      
      // Check if all voices are loaded after applying filters
      this.checkIfAllLoaded();
    },
    
    setupInfiniteScroll() {
      // Clean up previous observer if it exists
      if (this.observer) {
        this.observer.disconnect();
      }
      
      // Only setup observer if there are more items to load
      if (!this.hasMoreToLoad || this.loadingMore) return;
      
      // Create intersection observer for infinite scrolling
      this.observer = new IntersectionObserver((entries) => {
        if (entries[0].isIntersecting && this.hasMoreToLoad && !this.loadingMore) {
          this.loadMoreVoices();
        }
      }, {
        rootMargin: '0px 0px 200px 0px' // Trigger when within 200px of the bottom
      });
      
      // Observe the scroll detector element
      if (this.$refs.scrollDetector) {
        this.observer.observe(this.$refs.scrollDetector);
      }
    },
    
    playPreview(voice) {
      if (voice.isLoading) return;
      
      // If this voice is already playing, pause it
      if (this.currentlyPlayingId === voice.voice_id) {
        this.$refs.audioPlayer.pause();
        this.currentlyPlayingId = null;
        return;
      }
      
      // Update the UI to show loading state
      voice.isLoading = true;
      
      // Stop any currently playing audio
      if (this.currentlyPlayingId) {
        this.$refs.audioPlayer.pause();
      }
      
      // Play the new audio
      this.$refs.audioPlayer.src = voice.preview_audio;
      this.$refs.audioPlayer.load();
      
      // Play when loaded
      this.$refs.audioPlayer.oncanplaythrough = () => {
        voice.isLoading = false;
        this.currentlyPlayingId = voice.voice_id;
        this.$refs.audioPlayer.play().catch(error => {
          console.error('Error playing audio:', error);
          this.currentlyPlayingId = null;
        });
      };
      
      // Handle load error
      this.$refs.audioPlayer.onerror = () => {
        voice.isLoading = false;
        this.currentlyPlayingId = null;
        alert('Failed to load audio preview for this voice.');
      };
    },
    
    onAudioEnded() {
      this.currentlyPlayingId = null;
    },
    
    onAudioError() {
      this.currentlyPlayingId = null;
    },
    
    retryFetch() {
      this.voices = [];
      this.allVoices = [];
      this.allVoicesLoaded = false;
      this.fetchVoices();
    }
  }
};
</script>

<style>
/* Make sure the table doesn't extend outside the container */
table {
  width: 100%;
  border-collapse: collapse;
}

/* Fixed layout makes columns have consistent width */
@media (min-width: 768px) {
  table {
    table-layout: fixed;
  }
}

/* Ensure proper vertical alignment in table cells */
td {
  vertical-align: middle;
}

/* Prevent text overflow in table cells */
td, th {
  overflow: hidden;
  text-overflow: ellipsis;
}

/* Style for play button hover */
button:hover:not([disabled]) {
  transform: scale(1.1);
  transition: transform 0.2s;
}

/* Dark mode styles for option elements that don't inherit parent styles */
.dark select option {
  background-color: #374151;
  color: #f3f4f6;
}
</style> 