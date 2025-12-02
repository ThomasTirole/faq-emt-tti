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

    <div v-else class="space-y-4">
      <QuestionCard v-for="q in questions" :key="q.id" :question="q" />
    </div>
  </div>
</template>

<script setup lang="ts">
const client = useSupabaseClient()
const user = useSupabaseUser()

const { data: questions, pending, error } = await useAsyncData('my-questions', async () => {
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
})
</script>
