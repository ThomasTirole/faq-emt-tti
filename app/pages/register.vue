<template>
  <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <h2 class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900 dark:text-white">
        Create a new account
      </h2>
    </div>

    <div class="mt-10 sm:mx-auto sm:w-full sm:max-w-sm">
      <form class="space-y-6" @submit.prevent="handleRegister">
        <div>
          <label for="username" class="block text-sm font-medium leading-6 text-gray-900 dark:text-gray-200">Username</label>
          <div class="mt-2">
            <UInput id="username" v-model="username" type="text" required />
          </div>
        </div>

        <div>
          <label for="email" class="block text-sm font-medium leading-6 text-gray-900 dark:text-gray-200">Email address</label>
          <div class="mt-2">
            <UInput id="email" v-model="email" type="email" required />
          </div>
        </div>

        <div>
          <label for="password" class="block text-sm font-medium leading-6 text-gray-900 dark:text-gray-200">Password</label>
          <div class="mt-2">
            <UInput id="password" v-model="password" type="password" required />
          </div>
        </div>

        <div>
          <UButton type="submit" block :loading="loading">Register</UButton>
        </div>
      </form>

      <p class="mt-10 text-center text-sm text-gray-500">
        Already a member?
        <NuxtLink to="/login" class="font-semibold leading-6 text-primary-600 hover:text-primary-500">
          Sign in
        </NuxtLink>
      </p>
    </div>
  </div>
</template>

<script setup lang="ts">
const client = useSupabaseClient()
const user = useSupabaseUser()
const router = useRouter()
const config = useRuntimeConfig()

const email = ref('')
const password = ref('')
const username = ref('')
const loading = ref(false)

watchEffect(() => {
  if (user.value) {
    router.push('/')
  }
})

const handleRegister = async () => {
  loading.value = true
  try {
    const { error } = await client.auth.signUp({
      email: email.value,
      password: password.value,
      options: {
        data: {
          username: username.value
        },
        emailRedirectTo: `${config.public.siteUrl}/confirm`
      }
    })
    if (error) throw error
    alert('Check your email for the confirmation link!')
  } catch (error: any) {
    alert(error.message)
  } finally {
    loading.value = false
  }
}
</script>
