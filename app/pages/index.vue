<template>
  <div>
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-3xl font-bold text-gray-900 dark:text-white">Recent Questions</h1>
      <UButton v-if="user" to="/questions/new" icon="i-heroicons-plus">Ask Question</UButton>
    </div>

    <div v-if="pending" class="space-y-4">
      <USkeleton class="h-32 w-full" v-for="i in 3" :key="i" />
    </div>

    <div v-else-if="error" class="text-red-500">
      Error loading questions: {{ error.message }}
    </div>

    <div v-else-if="questions && questions.length === 0" class="text-center py-10 text-gray-500">
      No questions yet. Be the first to ask!
    </div>

    <div v-else class="space-y-4">
      <QuestionCard v-for="q in questions" :key="q.id" :question="q" />
    </div>
  </div>
</template>

<script setup lang="ts">
const client = useSupabaseClient()
const user = useSupabaseUser()

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
</script>
