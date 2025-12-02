<template>
  <div>
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Recent Questions</h1>
      <UButton v-if="user" to="/questions/new" icon="i-heroicons-plus">Ask Question</UButton>
    </div>

    <!-- Search and Filter -->
    <div class="mb-6 space-y-4">
      <UInput 
        v-model="searchQuery" 
        icon="i-heroicons-magnifying-glass"
        placeholder="Search questions by title or description..." 
        size="lg"
      />
      
      <div class="flex gap-4 items-center flex-wrap">
        <USelectMenu 
          v-model="statusFilter" 
          :options="statusOptions"
          placeholder="Filter by status"
        />
        
        <div v-if="allTags.length > 0" class="flex gap-2 items-center flex-wrap">
          <span class="text-sm text-gray-600 dark:text-gray-400">Tags:</span>
          <UBadge 
            v-for="tag in allTags" 
            :key="tag"
            :color="selectedTags.includes(tag) ? 'primary' : 'gray'"
            :variant="selectedTags.includes(tag) ? 'solid' : 'soft'"
            class="cursor-pointer"
            @click="toggleTag(tag)"
          >
            {{ tag }}
          </UBadge>
        </div>
      </div>
    </div>

    <div v-if="pending" class="space-y-4">
      <USkeleton class="h-32 w-full" v-for="i in 3" :key="i" />
    </div>

    <div v-else-if="error" class="text-red-500">
      Error loading questions: {{ error.message }}
    </div>

    <div v-else-if="filteredQuestions && filteredQuestions.length === 0" class="text-center py-10 text-gray-500">
      {{ questions && questions.length > 0 ? 'No questions match your filters.' : 'No questions yet. Be the first to ask!' }}
    </div>

    <div v-else class="space-y-4">
      <QuestionCard v-for="q in paginatedQuestions" :key="q.id" :question="q" />
      
      <!-- Pagination -->
      <div v-if="filteredQuestions.length > perPage" class="flex justify-center mt-6">
        <UPagination 
          v-model="currentPage" 
          :total="filteredQuestions.length" 
          :page-count="perPage"
          show-last
          show-first
        />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const client = useSupabaseClient()
const user = useSupabaseUser()

const searchQuery = ref('')
const statusFilter = ref('all')
const selectedTags = ref<string[]>([])
const currentPage = ref(1)
const perPage = 20

const statusOptions = [
  { label: 'All Questions', value: 'all' },
  { label: 'Answered', value: 'answered' },
  { label: 'Unanswered', value: 'unanswered' }
]

const { data: questions, pending, error } = await useAsyncData('questions', async () => {
  const { data } = await client
    .from('questions')
    .select(`
      *,
      profiles (username, avatar_url)
    `)
    .order('created_at', { ascending: false })
  return data
})

// Extract all unique tags
const allTags = computed(() => {
  if (!questions.value) return []
  const tags = new Set<string>()
  questions.value.forEach(q => {
    if (q.tags) {
      q.tags.forEach((tag: string) => tags.add(tag))
    }
  })
  return Array.from(tags).sort()
})

// Filter questions based on search and filters
const filteredQuestions = computed(() => {
  if (!questions.value) return []
  
  return questions.value.filter(q => {
    // Search filter
    if (searchQuery.value) {
      const query = searchQuery.value.toLowerCase()
      const matchesTitle = q.title.toLowerCase().includes(query)
      const matchesDescription = q.description.toLowerCase().includes(query)
      if (!matchesTitle && !matchesDescription) return false
    }
    
    // Status filter
    if (statusFilter.value === 'answered' && !q.is_answered) return false
    if (statusFilter.value === 'unanswered' && q.is_answered) return false
    
    // Tag filter
    if (selectedTags.value.length > 0) {
      const hasSelectedTag = selectedTags.value.some(tag => q.tags?.includes(tag))
      if (!hasSelectedTag) return false
    }
    
    return true
  })
})

// Pagination
const totalPages = computed(() => Math.ceil(filteredQuestions.value.length / perPage))

const paginatedQuestions = computed(() => {
  const start = (currentPage.value - 1) * perPage
  const end = start + perPage
  return filteredQuestions.value.slice(start, end)
})

// Reset to page 1 when filters change
watch([searchQuery, statusFilter, selectedTags], () => {
  currentPage.value = 1
})

const toggleTag = (tag: string) => {
  const index = selectedTags.value.indexOf(tag)
  if (index > -1) {
    selectedTags.value.splice(index, 1)
  } else {
    selectedTags.value.push(tag)
  }
}
</script>
