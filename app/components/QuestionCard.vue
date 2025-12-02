<template>
  <UCard class="mb-4 hover:shadow-md transition-shadow cursor-pointer" @click="navigateToQuestion">
    <template #header>
      <div class="flex justify-between items-start">
        <div class="flex items-center gap-2">
          <h3 class="text-lg font-semibold text-gray-900 dark:text-white">{{ question.title }}</h3>
          <UBadge v-if="question.is_answered" color="green" variant="soft" size="xs">
            ✓ Answered
          </UBadge>
        </div>
        <span class="text-xs text-gray-500">{{ formatDate(question.created_at) }}</span>
      </div>
    </template>
    
    <p class="text-gray-600 dark:text-gray-300 line-clamp-3">
      {{ question.description }}
    </p>
    
    <template #footer>
      <div class="flex justify-between items-center">
        <div class="flex gap-2">
          <UBadge v-for="tag in question.tags" :key="tag" color="gray" variant="soft" size="xs">
            {{ tag }}
          </UBadge>
        </div>
        <span class="text-sm text-gray-500">by {{ question.profiles?.username || 'Anonymous' }}</span>
      </div>
    </template>
  </UCard>
</template>

<script setup lang="ts">
const props = defineProps<{
  question: any
}>()

const router = useRouter()

const navigateToQuestion = () => {
  router.push(`/questions/${props.question.id}`)
}

const formatDate = (dateString: string) => {
  return new Date(dateString).toLocaleDateString()
}
</script>
