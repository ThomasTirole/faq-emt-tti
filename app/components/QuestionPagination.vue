<template>
  <div v-if="total > perPage" class="flex justify-center mt-6">
    <UPagination 
      :model-value="currentPage" 
      @update:model-value="$emit('update:currentPage', $event)"
      :total="total"
      :page-count="perPage"
      show-last
      show-first
    />
  </div>
</template>

<script setup lang="ts">
defineProps<{
  currentPage: number
  total: number
  perPage: number
}>()

defineEmits<{
  'update:currentPage': [value: number]
}>()
</script>
