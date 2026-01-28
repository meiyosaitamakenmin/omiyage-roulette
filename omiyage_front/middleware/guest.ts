export default defineNuxtRouteMiddleware(async () => {
  // サーバー側（SSR）では認証チェックをスキップ
  // ブラウザのCookieはサーバーからアクセスできないため
  if (import.meta.server) {
    return
  }

  const authStore = useAuthStore()

  await authStore.initialize()

  if (authStore.isLoggedIn) {
    return navigateTo('/souvenirs')
  }
})
