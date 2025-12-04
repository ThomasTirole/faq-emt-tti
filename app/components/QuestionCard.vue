<template>
  <div 
    class="bg-white dark:bg-gray-800 rounded-lg p-4 hover:shadow-md transition-shadow cursor-pointer border border-gray-200 dark:border-gray-700"
    @click="navigateToQuestion"
  >
    <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4">
      <!-- Title and Answered Badge -->
      <div class="flex items-center gap-2 flex-1 min-w-0 w-full">
        <h3 class="text-base font-semibold text-gray-900 dark:text-white truncate">
          {{ question.title }}
        </h3>
        <UBadge v-if="question.is_answered" color="green" variant="soft" size="xs" class="flex-shrink-0">
          ✓ Répondue
        </UBadge>
      </div>

      <!-- Metadata Container -->
      <div class="flex flex-wrap items-center gap-4 justify-between sm:justify-end w-full sm:w-auto">
        <!-- Tags with Icon -->
        <div class="flex items-center gap-2 flex-shrink-0">
          <UIcon v-if="question.tags.length > 0" name="i-heroicons-tag" class="w-4 h-4 text-gray-400" />
          <div class="flex gap-1">
            <UBadge 
              v-for="tag in question.tags?.slice(0, 3)" 
              :key="tag" 
              color="gray" 
              variant="soft" 
              size="xs"
            >
              {{ tag }}
            </UBadge>
            <UBadge 
              v-if="question.tags && question.tags.length > 3" 
              color="gray" 
              variant="soft" 
              size="xs"
            >
              +{{ question.tags.length - 3 }}
            </UBadge>
          </div>
        </div>

        <!-- Author with Avatar, Date with Icon, and Comment Count -->
        <div class="flex items-center gap-4 text-sm text-gray-500 flex-shrink-0">
          <div class="flex items-center gap-2">
            <UAvatar 
              :src="question.profiles?.avatar_url" 
              :alt="question.profiles?.username" 
              size="xs" 
            />
            <span class="hidden sm:inline">{{ question.profiles?.username || 'Anonyme' }}</span>
          </div>
          <div class="flex items-center gap-1">
            <UIcon name="i-heroicons-calendar" class="w-4 h-4" />
            <span class="hidden sm:inline">{{ formatDate(question.created_at) }}</span>
            <span class="sm:hidden">{{ new Date(question.created_at).toLocaleDateString(undefined, { month: 'numeric', day: 'numeric' }) }}</span>
          </div>
          <div class="flex items-center gap-1">
            <UIcon name="i-heroicons-chat-bubble-left" class="w-4 h-4" />
            <span>{{ question.comment_count || 0 }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
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
