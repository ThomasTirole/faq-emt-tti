<template>
  <div>
    <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-6">My Questions</h1>

    <div v-if="!user" class="text-center py-10">
      <p class="text-gray-600 dark:text-gray-400 mb-4">Please login to view your questions.</p>
      <UButton to="/login">Login</UButton>
    </div>

    <div v-else-if="pending" class="space-y-4">
      <USkeleton class="h-32 w-full" v-for="i in 3" :key="i" />
    </div>

    <div v-else-if="error" class="text-red-500">
      Error loading questions: {{ error.message }}
    </div>

    <div v-else-if="questions && questions.length === 0" class="text-center py-10 text-gray-500">
      You haven't asked any questions yet.
      <UButton to="/questions/new" class="mt-4">Ask Your First Question</UButton>
    </div>

    <div v-else>
      <!-- Filters -->
      <QuestionFilters 
        v-model:search-query="searchQuery"
        v-model:status-filter="statusFilter"
        v-model:selected-tags="selectedTags"
        :all-tags="allTags"
      />

      <!-- Questions List -->
      <div v-if="filteredQuestions.length === 0" class="text-center py-10 text-gray-500">
        No questions match your filters.
      </div>

      <div v-else class="space-y-4">
        <QuestionCard v-for="q in paginatedQuestions" :key="q.id" :question="q" />
        
        <!-- Pagination -->
        <QuestionPagination 
          v-model:current-page="currentPage"
          :total="filteredQuestions.length"
          :per-page="perPage"
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

const { data: questions, pending, error, refresh } = await useAsyncData('my-questions', async () => {
  if (!user.value) return []
  
  const { data } = await client
    .from('questions')
    .select(`
      *,
      profiles (username, avatar_url)
    `)
    .eq('user_id', user.value.id)
    .order('created_at', { ascending: false })
  return data
}, { server: false })

// Refresh data when component is mounted (handles client-side navigation)
onMounted(() => {
  if (user.value) {
    refresh()
  }
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

// Filter questions
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
</script>
