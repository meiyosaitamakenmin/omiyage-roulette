<script setup lang="ts">
definePageMeta({
  middleware: 'auth'
})

// ログイン済みならお土産一覧へリダイレクト
navigateTo('/souvenirs')
</script>

<template>
  <div class="min-h-screen flex items-center justify-center">
    <span class="loading loading-spinner loading-lg"></span>
  </div>
</template>
