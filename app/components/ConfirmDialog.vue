<template>
  <UModal v-model="isOpen">
    <UCard>
      <template #header>
        <h3 class="text-lg font-semibold">{{ title }}</h3>
      </template>

      <p class="text-gray-700 dark:text-gray-300">{{ message }}</p>

      <template #footer>
        <div class="flex justify-end gap-3">
          <UButton color="gray" variant="ghost" @click="cancel">
            Cancel
          </UButton>
          <UButton :color="confirmColor" @click="confirm">
            {{ confirmText }}
          </UButton>
        </div>
      </template>
    </UCard>
  </UModal>
</template>

<script setup lang="ts">
const props = withDefaults(defineProps<{
  title?: string
  message: string
  confirmText?: string
  confirmColor?: string
}>(), {
  title: 'Confirm',
  confirmText: 'Confirm',
  confirmColor: 'primary'
})

const emit = defineEmits<{
  confirm: []
  cancel: []
}>()

const isOpen = defineModel<boolean>({ required: true })

const confirm = () => {
  emit('confirm')
  isOpen.value = false
}

const cancel = () => {
  emit('cancel')
  isOpen.value = false
}
</script>
