<template>
  <div>
    <p>Processing authentication...</p>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'

const router = useRouter()

onMounted(async () => {
  const vueAuth = inject('vueAuth')
  

  if (vueAuth) {
    try {
      // Complete the authentication process
      await vueAuth.handleRedirect()
      console.log('Authentication successful!')
      // Redirect to a protected page or home
      router.push('/')
    } catch (error) {
      console.error('Authentication failed:', error)
    }
  } else {
    console.error('vueAuth is not available')
  }
})
</script>
