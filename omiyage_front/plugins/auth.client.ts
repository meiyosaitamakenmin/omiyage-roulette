// アプリ起動時に認証状態を復元するプラグイン
export default defineNuxtPlugin(async () => {
  const authStore = useAuthStore()

  // クライアント側のみで実行
  // ページリロード時にセッションCookieから認証状態を復元
  await authStore.initialize()
})
