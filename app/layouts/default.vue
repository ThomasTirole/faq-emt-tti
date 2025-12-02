<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-900">
    <nav class="bg-white dark:bg-gray-800 shadow-sm">
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
          <div class="flex items-center gap-8">
            <NuxtLink to="/" class="text-xl font-bold text-gray-900 dark:text-white">Pakompri</NuxtLink>
            <NuxtLink 
              v-if="user"
              to="/my-questions" 
              class="flex items-center text-gray-700 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white"
            >
              Mes Questions
            </NuxtLink>
          </div>
          <div class="flex items-center gap-3">
            <!-- Theme Switcher -->
            <UButton
              :icon="isDark ? 'i-heroicons-moon' : 'i-heroicons-sun'"
              color="gray"
              variant="ghost"
              @click="toggleTheme"
              aria-label="Changer le thème"
            />
            
            <template v-if="user">
              <UButton to="/profile" color="gray" variant="ghost" icon="i-heroicons-user-circle" class="mr-2">Profil</UButton>
              <UButton color="gray" variant="ghost" @click="logout">Déconnexion</UButton>
            </template>
            <template v-else>
              <UButton to="/login" color="primary" variant="ghost" class="mr-2">Connexion</UButton>
              <UButton to="/register" color="primary" variant="solid">Inscription</UButton>
            </template>
          </div>
        </div>
      </div>
    </nav>
    <main class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
      <slot />
    </main>
  </div>
</template>

<script setup lang="ts">
const client = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()
const colorMode = useColorMode()

const isDark = computed(() => colorMode.value === 'dark')

const toggleTheme = () => {
  colorMode.preference = colorMode.value === 'dark' ? 'light' : 'dark'
}

const logout = async () => {
  await client.auth.signOut()
  router.push('/login')
}
</script>
