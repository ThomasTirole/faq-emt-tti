<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <nav class="bg-white dark:bg-gray-800 shadow">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex">
            <NuxtLink to="/" class="flex-shrink-0 flex items-center">
              <span class="text-xl font-bold text-gray-800 dark:text-white">Student Q&A</span>
            </NuxtLink>
          </div>
          <div class="flex items-center">
            <template v-if="user">
              <span class="text-sm text-gray-700 dark:text-gray-300 mr-4">{{ user.email }}</span>
              <UButton color="gray" variant="ghost" @click="logout">Logout</UButton>
            </template>
            <template v-else>
              <UButton to="/login" color="primary" variant="ghost" class="mr-2">Login</UButton>
              <UButton to="/register" color="primary" variant="solid">Register</UButton>
            </template>
          </div>
        </div>
      </div>
    </nav>

    <main class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8">
      <slot />
    </main>
  </div>
</template>

<script setup lang="ts">
const user = useSupabaseUser()
const client = useSupabaseClient()
const router = useRouter()

const logout = async () => {
  await client.auth.signOut()
  router.push('/login')
}
</script>
