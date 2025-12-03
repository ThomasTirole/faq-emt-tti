<template>
  <div class="max-w-2xl mx-auto">
    <h1 class="text-3xl font-bold text-gray-900 dark:text-white mb-6">Mon profil</h1>

    <div v-if="!user" class="text-center py-10">
      <p class="text-gray-600 dark:text-gray-400 mb-4">Veuillez vous connecter pour voir votre profil.</p>
      <UButton to="/login">Connexion</UButton>
    </div>

    <div v-else-if="loading" class="space-y-4">
      <USkeleton class="h-32 w-32 rounded-full" />
      <USkeleton class="h-10 w-full" />
    </div>

    <div v-else class="bg-white dark:bg-gray-800 rounded-lg p-6 shadow">
      <form @submit.prevent="saveProfile" class="space-y-6">
        <!-- Avatar Upload -->
        <div class="flex items-center gap-6">
          <div class="relative">
            <UAvatar 
              :src="avatarPreview || profile?.avatar_url" 
              :alt="profile?.username" 
              size="3xl"
            />
            <label 
              for="avatar-upload" 
              class="absolute bottom-0 right-0 bg-primary-500 text-white rounded-full p-2 cursor-pointer hover:bg-primary-600"
            >
              <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor">
                <path d="M13.586 3.586a2 2 0 112.828 2.828l-.793.793-2.828-2.828.793-.793zM11.379 5.793L3 14.172V17h2.828l8.38-8.379-2.83-2.828z" />
              </svg>
            </label>
            <input 
              id="avatar-upload" 
              type="file" 
              accept="image/*" 
              class="hidden" 
              @change="handleAvatarUpload"
            />
          </div>
          <div class="flex-1">
            <p class="text-sm text-gray-600 dark:text-gray-400 mb-2">Photo de profil</p>
            <p class="text-xs text-gray-500">Taille max: 2MB. Recommandé: 256x256px</p>
          </div>
        </div>

        <!-- Username -->
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">Nom d'utilisateur</label>
          <UInput v-model="username" placeholder="Entrez votre nom d'utilisateur" required />
        </div>

        <!-- Email (readonly) -->
        <div>
          <label class="block text-sm font-medium text-gray-700 dark:text-gray-200 mb-2">Email</label>
          <UInput :model-value="user.email" disabled />
        </div>

        <!-- Save Button -->
        <div class="flex justify-end gap-4">
          <UButton to="/" color="gray" variant="ghost">Annuler</UButton>
          <UButton type="submit" :loading="saving">Enregistrer</UButton>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
const client = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()

const username = ref('')
const avatarPreview = ref('')
const avatarFile = ref<File | null>(null)
const loading = ref(true)
const saving = ref(false)

// Fetch user profile
const { data: profile, refresh: refreshProfile } = await useAsyncData('user-profile', async () => {
  if (!user.value) return null
  const { data } = await client
    .from('profiles')
    .select('*')
    .eq('id', user.value.id)
    .single()
  
  if (data) {
    username.value = data.username || ''
  }
  loading.value = false
  return data
}, { server: false })

// Refresh data when component is mounted (handles client-side navigation)
onMounted(() => {
  if (user.value) {
    refreshProfile()
  }
})

const handleAvatarUpload = (event: Event) => {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  
  if (!file) return
  
  // Check file size (2MB max)
  if (file.size > 2 * 1024 * 1024) {
    useToast().add({
      title: 'Erreur',
      description: 'La taille du fichier doit être inférieure à 2MB',
      color: 'red'
    })
    return
  }
  
  // Check file type
  if (!file.type.startsWith('image/')) {
    useToast().add({
      title: 'Erreur',
      description: 'Veuillez télécharger un fichier image',
      color: 'red'
    })
    return
  }
  
  avatarFile.value = file
  
  // Create preview
  const reader = new FileReader()
  reader.onload = (e) => {
    avatarPreview.value = e.target?.result as string
  }
  reader.readAsDataURL(file)
}

const saveProfile = async () => {
  if (!user.value) return
  
  saving.value = true
  try {
    let avatarUrl = profile.value?.avatar_url
    
    // Upload avatar if changed
    if (avatarFile.value) {
      const fileExt = avatarFile.value.name.split('.').pop()
      const fileName = `${Date.now()}.${fileExt}`
      const filePath = `${user.value.id}/${fileName}`
      
      const { error: uploadError } = await client.storage
        .from('avatars')
        .upload(filePath, avatarFile.value, { upsert: true })
      
      if (uploadError) throw uploadError
      
      const { data: { publicUrl } } = client.storage
        .from('avatars')
        .getPublicUrl(filePath)
      
      avatarUrl = publicUrl
    }
    
    // Update profile
    const { error } = await client
      .from('profiles')
      .update({
        username: username.value,
        avatar_url: avatarUrl
      })
      .eq('id', user.value.id)
    
    if (error) throw error
    
    // Refresh questions data to show updated username
    await refreshNuxtData('questions')
    await refreshNuxtData('my-questions')
    
    useToast().add({
      title: 'Succès',
      description: 'Profil mis à jour avec succès !',
      color: 'green'
    })
    router.push('/')
  } catch (error: any) {
    useToast().add({
      title: 'Erreur',
      description: error.message,
      color: 'red'
    })
  } finally {
    saving.value = false
  }
}
</script>
