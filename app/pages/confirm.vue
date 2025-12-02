<template>
  <div class="flex min-h-full flex-1 flex-col justify-center px-6 py-12 lg:px-8">
    <div class="sm:mx-auto sm:w-full sm:max-w-sm">
      <h2 class="mt-10 text-center text-2xl font-bold leading-9 tracking-tight text-gray-900 dark:text-white">
        {{ title }}
      </h2>
      <p class="mt-4 text-center text-sm text-gray-500">
        {{ message }}
      </p>
      <div class="mt-6 text-center">
        <NuxtLink to="/login" class="font-semibold leading-6 text-primary-600 hover:text-primary-500">
          Go to login
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
const user = useSupabaseUser()
const router = useRouter()
const route = useRoute()

const title = ref('Confirming your account...')
const message = ref('Please wait while we verify your email.')

watchEffect(() => {
  if (user.value) {
    title.value = 'Email Confirmed!'
    message.value = 'Your account has been confirmed. Redirecting...'
    setTimeout(() => {
      router.push('/')
    }, 2000)
  }
})

onMounted(() => {
  const error = route.query.error as string
  const errorDescription = route.query.error_description as string

  if (error) {
    title.value = 'Confirmation Failed'
    message.value = errorDescription ? decodeURIComponent(errorDescription) : 'An error occurred during confirmation.'
  }
})
</script>
