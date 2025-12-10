<template>
  <div class="space-y-4">
    <div class="border rounded-md border-gray-300 dark:border-gray-700 overflow-hidden bg-white dark:bg-gray-900 focus-within:ring-2 focus-within:ring-primary-500 focus-within:border-primary-500 transition-all duration-200">
      <!-- Toolbar -->
      <div class="flex flex-wrap items-center gap-1 p-2 border-b border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-800">
        <UTooltip text="Bold (Ctrl+B)" :shortcuts="['Ctrl', 'B']">
          <UButton
            icon="i-heroicons-bold"
            color="gray"
            variant="ghost"
            size="sm"
            @click="format('bold')"
            aria-label="Bold"
            tabindex="-1"
          />
        </UTooltip>
        
        <UTooltip text="Italic (Ctrl+I)" :shortcuts="['Ctrl', 'I']">
          <UButton
            icon="i-heroicons-italic"
            color="gray"
            variant="ghost"
            size="sm"
            @click="format('italic')"
            aria-label="Italic"
            tabindex="-1"
          />
        </UTooltip>

        <UDivider orientation="vertical" class="h-6 mx-1" />

        <UTooltip text="Quote (Ctrl+Q)" :shortcuts="['Ctrl', 'Q']">
          <UButton
            icon="i-heroicons-chat-bubble-left-right"
            color="gray"
            variant="ghost"
            size="sm"
            @click="format('quote')"
            aria-label="Quote"
            tabindex="-1"
          />
        </UTooltip>

        <UTooltip text="Code Block (Ctrl+K)" :shortcuts="['Ctrl', 'K']">
          <UButton
            icon="i-heroicons-code-bracket-square"
            color="gray"
            variant="ghost"
            size="sm"
            @click="format('code_block')"
            aria-label="Code Block"
            tabindex="-1"
          />
        </UTooltip>

        <UTooltip text="Inline Code (Ctrl+E)" :shortcuts="['Ctrl', 'E']">
          <UButton
            icon="i-heroicons-code-bracket"
            color="gray"
            variant="ghost"
            size="sm"
            @click="format('inline_code')"
            aria-label="Inline Code"
            tabindex="-1"
          />
        </UTooltip>

        <UDivider orientation="vertical" class="h-6 mx-1" />

        <UTooltip text="Numbered List (Ctrl+O)" :shortcuts="['Ctrl', 'O']">
          <UButton
            icon="i-heroicons-numbered-list" 
            color="gray"
            variant="ghost"
            size="sm"
            @click="format('ordered_list')"
            aria-label="Numbered List"
            tabindex="-1"
          />
        </UTooltip>

        <UTooltip text="Bulleted List (Ctrl+U)" :shortcuts="['Ctrl', 'U']">
          <UButton
            icon="i-heroicons-list-bullet"
            color="gray"
            variant="ghost"
            size="sm"
            @click="format('unordered_list')"
            aria-label="Bulleted List"
            tabindex="-1"
          />
        </UTooltip>
        
        <UTooltip text="Check List (Ctrl+Shift+C)" :shortcuts="['Ctrl', 'Shift', 'C']">
          <UButton
            icon="i-heroicons-clipboard-document-check"
            color="gray"
            variant="ghost"
            size="sm"
            @click="format('check_list')"
            aria-label="Check List"
            tabindex="-1"
          />
        </UTooltip>

        <div class="flex-grow"></div>
        <UButton
            :icon="showPreview ? 'i-heroicons-eye-slash' : 'i-heroicons-eye'"
            color="gray"
            variant="ghost"
            size="xs"
            @click="showPreview = !showPreview"
            :label="showPreview ? 'Masquer aperçu' : 'Afficher aperçu'"
            tabindex="-1"
        />
      </div>

      <!-- Textarea -->
      <textarea
        ref="textareaRef"
        v-model="internalValue"
        class="w-full p-3 bg-transparent border-none text-gray-900 dark:text-gray-100 placeholder-gray-400 focus:ring-0 font-mono text-sm resize-y outline-none block"
        :class="[rows ? '' : 'h-64']"
        :style="rows ? { height: 'auto' } : {}"
        :rows="rows"
        :placeholder="placeholder"
        :required="required"
        @keydown="handleKeydown"
        @input="handleInput"
      ></textarea>
    </div>

    <!-- Preview -->
    <div v-if="showPreview && internalValue" class="border rounded-md border-gray-200 dark:border-gray-700 p-4 bg-gray-50 dark:bg-gray-800">
      <h3 class="text-xs font-semibold text-gray-500 uppercase mb-2">Aperçu</h3>
      <div class="prose dark:prose-invert max-w-none">
         <MDC :value="sanitizedValue" />
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { sanitizeMarkdown } from '~/utils/markdown'

const props = defineProps<{
  modelValue: string
  placeholder?: string
  required?: boolean
  rows?: number
}>()

const emit = defineEmits(['update:modelValue'])

const internalValue = ref(props.modelValue)
const textareaRef = ref<HTMLTextAreaElement | null>(null)
const showPreview = ref(true)

watch(() => props.modelValue, (val) => {
  if (val !== internalValue.value) {
    internalValue.value = val
  }
})

const handleInput = () => {
  emit('update:modelValue', internalValue.value)
}

const sanitizedValue = computed(() => {
  return sanitizeMarkdown(internalValue.value)
})

// Formatting Logic
const format = (type: string) => {
  if (!textareaRef.value) return

  const textarea = textareaRef.value
  const start = textarea.selectionStart
  const end = textarea.selectionEnd
  const text = internalValue.value
  const selection = text.substring(start, end)
  
  let before = text.substring(0, start)
  let after = text.substring(end)
  let newSelection = selection
  let cursorOffset = 0

  switch (type) {
    case 'bold':
      newSelection = `**${selection}**`
      cursorOffset = 2
      break
    case 'italic':
      newSelection = `*${selection}*`
      cursorOffset = 1
      break
    case 'quote':
      // Basic blockquote implementation. 
      // Multi-line support: prepend > to each line.
      if (selection.includes('\n')) {
          newSelection = selection.split('\n').map(line => `> ${line}`).join('\n')
      } else {
          newSelection = `> ${selection}`
      }
      cursorOffset = 2
      break
    case 'code_block':
      newSelection = `\`\`\`\n${selection}\n\`\`\``
      cursorOffset = 4 // Position inside the backticks if empty
      if (selection) cursorOffset = newSelection.length // Jump to end if wrapping
      break
    case 'inline_code':
      newSelection = `\`${selection}\``
      cursorOffset = 1
      break
    case 'ordered_list':
      // Simple toggle implementation logic can be complex for lists, here we just prefix.
      // Ideally should check previous line number. Here starts with 1.
      newSelection = `1. ${selection}`
      cursorOffset = 3
      break
    case 'unordered_list':
      newSelection = `- ${selection}`
      cursorOffset = 2
      break
    case 'check_list':
      newSelection = `- [ ] ${selection}`
      cursorOffset = 6
      break
  }

  // Update text
  internalValue.value = before + newSelection + after
  emit('update:modelValue', internalValue.value)

  // Restore focus and update cursor
  nextTick(() => {
    textarea.focus()
    // If wrapping selection, select the wrapped text (inner) or put cursor appropriately
    // This simple logic puts cursor inside if specific offset, or at end.
    // Let's refine for "cursor goes inside format" if selection was empty.
    
    if (selection.length === 0) {
        // Cursor *inside* the tags
        const newCursorPos = start + cursorOffset
        textarea.setSelectionRange(newCursorPos, newCursorPos)
    } else {
        // Ensure the whole new block is not selected, just put cursor at the end of inserted block
        // Or keep original selection wrapped? 
        // User asked: "surround the selected text"
        // User also asked: "cursor goes inside the format, so the user can write directly" (for empty selection)
        
        // For selection present, usually we highlight the whole thing or put cursor at end.
        // Let's put cursor at end of the new selection.
        const newCursorPos = start + newSelection.length
        textarea.setSelectionRange(newCursorPos, newCursorPos)
    }
  })
}

const handleKeydown = (e: KeyboardEvent) => {
  // Check for Ctrl/Command key
  if (!e.ctrlKey && !e.metaKey) return

  let key = e.key.toLowerCase()
  if (e.shiftKey) key = 'shift+' + key // rough normalization

  // Mapping keys
  // Bold (CTRL+B)
  // Emphase (CTRL+I)
  // Quote (CTRL+Q)
  // Code-block (CTRL+K)
  // in-line code (CTRL+E)
  // numbered-list (CTRL+O)
  // Bulleted List (CTRL+U)
  // Check-list (CTRL+SHIFT+C)

  let type = ''
  
  if (key === 'b') type = 'bold'
  else if (key === 'i') type = 'italic'
  else if (key === 'q') type = 'quote'
  else if (key === 'k') type = 'code_block'
  else if (key === 'e') type = 'inline_code'
  else if (key === 'o') type = 'ordered_list'
  else if (key === 'u') type = 'unordered_list'
  else if (key === 'shift+c' || (e.shiftKey && key === 'c') || (e.shiftKey && e.code === 'KeyC')) type = 'check_list'

  if (type) {
    e.preventDefault()
    format(type)
  }
}
</script>
