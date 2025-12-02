<template>
  <div class="max-w-3xl mx-auto">
    <h1 class="text-2xl font-bold mb-6 text-gray-900 dark:text-white">Ask a Question</h1>
    
    <form @submit.prevent="submitQuestion" class="space-y-6">
      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">Title</label>
        <UInput v-model="title" placeholder="What's your question?" required />
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">Description (Markdown)</label>
        <UTextarea v-model="description" :rows="10" placeholder="Describe your problem..." required />
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">Tags (comma separated, max 5)</label>
        <UInput v-model="tagsInput" placeholder="html, css, flexbox" />
      </div>

      <div class="flex justify-end gap-4">
        <UButton to="/" color="gray" variant="ghost">Cancel</UButton>
        <UButton type="submit" :loading="loading">Post Question</UButton>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
const client = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()

const title = ref('')
const description = ref('')
const tagsInput = ref('')
const loading = ref(false)

// Redirect if not logged in
watchEffect(() => {
  if (!user.value) {
    router.push('/login')
  }
})

const submitQuestion = async () => {
  if (!user.value) return

  loading.value = true
  const tags = tagsInput.value.split(',').map(t => t.trim()).filter(t => t).slice(0, 5)

  try {
    const { error } = await client
      .from('questions')
      .insert({
        title: title.value,
        description: description.value,
        user_id: user.value.id,
        tags: tags
      })

    if (error) throw error
    
    // Refresh the questions list data before navigating
    await refreshNuxtData('questions')
    router.push('/')
  } catch (error: any) {
    alert(error.message)
  } finally {
    loading.value = false
  }
}
</script>
