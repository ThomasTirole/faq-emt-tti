<template>
  <div v-if="pending" class="space-y-4">
    <USkeleton class="h-8 w-3/4" />
    <USkeleton class="h-4 w-1/2" />
    <USkeleton class="h-32 w-full" />
  </div>

  <div v-else-if="error || !question" class="text-red-500">
    Error loading question: {{ error?.message || 'Question not found' }}
  </div>

  <div v-else>
    <UButton to="/" color="gray" variant="ghost" icon="i-heroicons-arrow-left" class="mb-4">Back to Questions</UButton>
    
    <div class="bg-white dark:bg-gray-800 shadow rounded-lg p-6">
      <div class="flex justify-between items-start mb-4">
        <h1 class="text-2xl font-bold text-gray-900 dark:text-white">{{ question.title }}</h1>
        <div class="flex gap-2">
          <span class="text-sm text-gray-500">{{ formatDate(question.created_at) }}</span>
          <UButton 
            v-if="canDelete"
            color="red" 
            variant="ghost" 
            size="sm"
            icon="i-heroicons-trash"
            @click="deleteQuestion"
            :loading="deleting"
          >
            Delete
          </UButton>
        </div>
      </div>

      <div class="flex items-center gap-2 mb-6">
        <UAvatar :alt="question.profiles?.username" size="xs" />
        <span class="text-sm font-medium text-gray-700 dark:text-gray-300">{{ question.profiles?.username || 'Anonymous' }}</span>
      </div>

      <div class="prose dark:prose-invert max-w-none mb-6">
        <MDC :value="question.description" />
      </div>

      <div class="flex gap-2">
        <UBadge v-for="tag in question.tags" :key="tag" color="gray" variant="soft">
          {{ tag }}
        </UBadge>
      </div>
    </div>

    <!-- Comments Section -->
    <CommentSection :question-id="question.id" />
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const router = useRouter()
const client = useSupabaseClient()
const user = useSupabaseUser()

const deleting = ref(false)

const { data: question, pending, error } = await useAsyncData(`question-${route.params.id}`, async () => {
  const { data } = await client
    .from('questions')
    .select(`
      *,
      profiles (username, avatar_url, is_admin)
    `)
    .eq('id', route.params.id)
    .single()
  return data
})

// Fetch current user's profile to check admin status
const { data: userProfile } = await useAsyncData('current-user-profile', async () => {
  if (!user.value) return null
  const { data } = await client
    .from('profiles')
    .select('is_admin')
    .eq('id', user.value.id)
    .single()
  return data
})

// Check if user can delete (owner or admin)
const canDelete = computed(() => {
  if (!user.value || !question.value) return false
  const isOwner = user.value.id === question.value.user_id
  const isAdmin = userProfile.value?.is_admin || false
  return isOwner || isAdmin
})

const deleteQuestion = async () => {
  if (!confirm('Are you sure you want to delete this question? This will also delete all comments.')) return

  deleting.value = true
  try {
    const { error } = await client
      .from('questions')
      .delete()
      .eq('id', route.params.id)

    if (error) throw error

    router.push('/')
  } catch (error: any) {
    alert(error.message)
  } finally {
    deleting.value = false
  }
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString()
}
</script>
