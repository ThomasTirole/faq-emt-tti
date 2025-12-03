<template>
  <div class="mb-6 space-y-4">
    <UInput 
      :model-value="searchQuery" 
      @update:model-value="$emit('update:searchQuery', $event)"
      icon="i-heroicons-magnifying-glass"
      placeholder="Rechercher des questions par titre ou description..." 
      size="lg"
    />
    
    <div class="flex gap-4 items-center flex-wrap">
      <USelectMenu 
        :model-value="statusFilter" 
        @update:model-value="$emit('update:statusFilter', $event)"
        :options="statusOptions"
        value-attribute="value"
        option-attribute="label"
        placeholder="Filtrer par statut"
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
</template>

<script setup lang="ts">
const props = defineProps<{
  searchQuery: string
  statusFilter: string
  selectedTags: string[]
  allTags: string[]
}>()

const emit = defineEmits<{
  'update:searchQuery': [value: string]
  'update:statusFilter': [value: string]
  'update:selectedTags': [value: string[]]
}>()

const statusOptions = [
  { label: 'Toutes les questions', value: 'all' },
  { label: 'Répondues', value: 'answered' },
  { label: 'Non répondues', value: 'unanswered' }
]

const toggleTag = (tag: string) => {
  const newTags = [...props.selectedTags]
  const index = newTags.indexOf(tag)
  if (index > -1) {
    newTags.splice(index, 1)
  } else {
    newTags.push(tag)
  }
  emit('update:selectedTags', newTags)
}
</script>
