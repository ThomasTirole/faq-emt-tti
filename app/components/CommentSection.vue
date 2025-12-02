<template>
  <div class="mt-8">
    <h2 class="text-xl font-bold text-gray-900 dark:text-white mb-4">Comments</h2>

    <!-- Comment Form -->
    <div v-if="user" class="mb-6">
      <form @submit.prevent="submitComment" class="space-y-4">
        <UTextarea 
          v-model="newComment" 
          :rows="3" 
          placeholder="Add a comment..." 
          required 
        />
        <UButton type="submit" :loading="submitting">Post Comment</UButton>
      </form>
    </div>
    <div v-else class="mb-6 p-4 bg-gray-100 dark:bg-gray-800 rounded">
      <p class="text-sm text-gray-600 dark:text-gray-400">
        Please <NuxtLink to="/login" class="text-primary-600 hover:underline">login</NuxtLink> to comment.
      </p>
    </div>

    <!-- Comments List -->
    <div v-if="pending" class="space-y-4">
      <USkeleton class="h-20 w-full" v-for="i in 2" :key="i" />
    </div>

    <div v-else-if="comments && comments.length === 0" class="text-center py-6 text-gray-500">
      No comments yet. Be the first to comment!
    </div>

    <div v-else class="space-y-4">
      <div 
        v-for="comment in comments" 
        :key="comment.id"
        class="bg-gray-50 dark:bg-gray-800 rounded-lg p-4"
      >
        <div class="flex justify-between items-start mb-2">
          <div class="flex items-center gap-2">
            <UAvatar 
              :src="comment.profiles?.avatar_url" 
              :alt="comment.profiles?.username" 
              size="xs" 
            />
            <span class="text-sm font-medium text-gray-700 dark:text-gray-300">
              {{ comment.profiles?.username || 'Anonymous' }}
            </span>
            <span class="text-xs text-gray-500">{{ formatDate(comment.created_at) }}</span>
          </div>
          <UButton 
            v-if="user && user.id === comment.user_id"
            color="red" 
            variant="ghost" 
            size="xs"
            icon="i-heroicons-trash"
            @click="deleteComment(comment.id)"
            :loading="deletingCommentId === comment.id"
          />
        </div>
        <div class="prose dark:prose-invert prose-sm max-w-none">
          <MDC :value="comment.content" />
        </div>
      </div>
    </div>
    
    <!-- Delete Comment Confirmation Dialog -->
    <ConfirmDialog 
      v-model="showDeleteCommentDialog"
      title="Delete Comment"
      message="Are you sure you want to delete this comment?"
      confirm-text="Delete"
      confirm-color="red"
      @confirm="confirmDeleteComment"
    />
  </div>
</template>

<script setup lang="ts">
const props = defineProps<{
  questionId: number
}>()

const client = useSupabaseClient()
const user = useSupabaseUser()

const newComment = ref('')
const submitting = ref(false)
const deletingCommentId = ref<number | null>(null)
const showDeleteCommentDialog = ref(false)
const commentToDelete = ref<number | null>(null)

// Fetch comments
const { data: comments, pending, refresh } = await useAsyncData(
  `comments-${props.questionId}`,
  async () => {
    const { data } = await client
      .from('comments')
      .select(`
        *,
        profiles (username, avatar_url)
      `)
      .eq('question_id', props.questionId)
      .order('created_at', { ascending: true })
    return data
  }
)

const submitComment = async () => {
  if (!user.value || !newComment.value.trim()) return

  submitting.value = true
  try {
    const { error } = await client
      .from('comments')
      .insert({
        question_id: props.questionId,
        user_id: user.value.id,
        content: newComment.value.trim()
      })

    if (error) throw error

    newComment.value = ''
    await refresh()
  } catch (error: any) {
    useToast().add({
      title: 'Error',
      description: error.message,
      color: 'red'
    })
  } finally {
    submitting.value = false
  }
}

const deleteComment = (commentId: number) => {
  commentToDelete.value = commentId
  showDeleteCommentDialog.value = true
}

const confirmDeleteComment = async () => {
  if (!commentToDelete.value) return

  deletingCommentId.value = commentToDelete.value
  try {
    const { error } = await client
      .from('comments')
      .delete()
      .eq('id', commentToDelete.value)

    if (error) throw error

    await refresh()
  } catch (error: any) {
    useToast().add({
      title: 'Error',
      description: error.message,
      color: 'red'
    })
  } finally {
    deletingCommentId.value = null
  }
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleString()
}
</script>
