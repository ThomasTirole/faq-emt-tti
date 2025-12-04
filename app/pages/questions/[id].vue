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
    <UButton to="/" color="gray" variant="ghost" icon="i-heroicons-arrow-left" class="mb-4">Retour aux questions</UButton>
    
    <div class="bg-white dark:bg-gray-800 shadow rounded-lg p-6">
      <div class="flex flex-col sm:flex-row justify-between items-start gap-4 mb-4">
        <div class="flex flex-col gap-2 w-full sm:w-auto flex-1 min-w-0">
          <div class="flex items-start gap-3 flex-wrap">
            <h1 class="text-2xl font-bold text-gray-900 dark:text-white break-words">{{ question.title }}</h1>
            <UBadge v-if="question.is_answered" color="green" variant="soft" class="mt-1">
              ✓ Répondu
            </UBadge>
          </div>
        </div>
        <div class="flex flex-wrap gap-2 items-center w-full sm:w-auto justify-between sm:justify-end">
          <div class="flex items-center gap-1 text-sm text-gray-500 mr-2">
            <UIcon name="i-heroicons-calendar" class="w-4 h-4" />
            <span>{{ formatDate(question.created_at) }}</span>
          </div>
          <div class="flex gap-2">
            <UButton 
              v-if="canToggleAnswered"
              :color="question.is_answered ? 'gray' : 'green'" 
              variant="ghost" 
              size="sm"
              :icon="question.is_answered ? 'i-heroicons-x-mark' : 'i-heroicons-check'"
              @click="toggleAnswered"
              :loading="toggling"
            >
              <span class="hidden sm:inline">{{ question.is_answered ? 'Marquer comme non répondu' : 'Marquer comme répondu' }}</span>
              <span class="sm:hidden">{{ question.is_answered ? 'Non répondu' : 'Répondu' }}</span>
            </UButton>
            <UButton 
              v-if="canDelete"
              color="red" 
              variant="ghost" 
              size="sm"
              icon="i-heroicons-trash"
              @click="deleteQuestion"
              :loading="deleting"
            >
              <span class="hidden sm:inline">Supprimer</span>
            </UButton>
          </div>
        </div>
      </div>

      <!-- Separator -->
      <UDivider class="my-6 w-full border-t-2 border-gray-500 dark:border-gray-300" />


      <!-- Author with Avatar -->
      <div class="flex items-center gap-2 mb-6">
        <UAvatar 
          :src="question.profiles?.avatar_url" 
          :alt="question.profiles?.username" 
          size="sm" 
        />
        <span class="text-sm font-medium text-gray-700 dark:text-gray-300">{{ question.profiles?.username || 'Anonymous' }}</span>
      </div>

      <div class="prose dark:prose-invert max-w-none mb-6">
        <MDC :value="sanitizedDescription" />
      </div>
    
      <!-- Separator -->
      <UDivider class="my-6 w-full border-t border-gray-300 dark:border-gray-600" />

      <!-- Tags with Icon -->
      <div class="flex items-center gap-2">
        <UIcon v-if="question.tags.length > 0" name="i-heroicons-tag" class="w-5 h-5 text-gray-400" />
        <div class="flex gap-2">
          <UBadge v-for="tag in question.tags" :key="tag" color="primary" variant="soft">
            {{ tag }}
          </UBadge>
        </div>
      </div>
    </div>

    <!-- Comments Section -->
    <CommentSection :question-id="question.id" />
    
    <!-- Delete Confirmation Dialog -->
    <ConfirmDialog 
      v-model="showDeleteDialog"
      title="Supprimer la question"
      message="Êtes-vous sûr de vouloir supprimer cette question ? Cela supprimera également tous les commentaires."
      confirm-text="Supprimer"
      confirm-color="red"
      @confirm="confirmDelete"
    />
  </div>
</template>

<script setup lang="ts">
const route = useRoute()
const router = useRouter()
const client = useSupabaseClient()
const user = useSupabaseUser()
import { sanitizeMarkdown } from '~/utils/markdown'

const deleting = ref(false)
const toggling = ref(false)
const showDeleteDialog = ref(false)

const { data: question, pending, error, refresh } = await useAsyncData(`question-${route.params.id}`, async () => {
  const { data } = await client
    .from('questions')
    .select(`
      *,
      profiles (username, avatar_url, is_admin)
    `)
    .eq('id', route.params.id)
    .single()
  return data
}, { server: false })

const sanitizedDescription = computed(() => {
  return sanitizeMarkdown(question.value?.description || '')
})

// Fetch current user's profile to check admin status
const { data: userProfile, refresh: refreshUserProfile } = await useAsyncData('current-user-profile', async () => {
  if (!user.value) return null
  const { data } = await client
    .from('profiles')
    .select('is_admin')
    .eq('id', user.value.id)
    .single()
  return data
}, { server: false })

// Refresh data when component is mounted (handles client-side navigation)
onMounted(() => {
  refresh()
  if (user.value) {
    refreshUserProfile()
  }
})

// Check if user can delete (owner or admin)
const canDelete = computed(() => {
  if (!user.value || !question.value) return false
  const isOwner = user.value.id === question.value.user_id
  const isAdmin = userProfile.value?.is_admin || false
  return isOwner || isAdmin
})

// Check if user can toggle answered status (same as delete)
const canToggleAnswered = computed(() => canDelete.value)

const toggleAnswered = async () => {
  if (!question.value) return

  toggling.value = true
  try {
    const { error } = await client
      .from('questions')
      .update({ is_answered: !question.value.is_answered })
      .eq('id', route.params.id)

    if (error) throw error

    // Update local data
    question.value.is_answered = !question.value.is_answered
    
    // Refresh the questions list data to update the main list
    await refreshNuxtData('questions')
  } catch (error: any) {
    alert(error.message)
  } finally {
    toggling.value = false
  }
}

const deleteQuestion = () => {
  showDeleteDialog.value = true
}

const confirmDelete = async () => {

  deleting.value = true
  try {
    const { error } = await client
      .from('questions')
      .delete()
      .eq('id', route.params.id)

    if (error) throw error

    // Refresh the questions list data before navigating
    await refreshNuxtData('questions')
    
    useToast().add({
      title: 'Question deleted',
      description: 'The question has been deleted successfully.',
      color: 'green'
    })
    router.push('/')
  } catch (error: any) {
    useToast().add({
      title: 'Error',
      description: error.message,
      color: 'red'
    })
  } finally {
    deleting.value = false
  }
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString()
}
</script>
