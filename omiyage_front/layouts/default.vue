<script setup lang="ts">
const authStore = useAuthStore()

const handleLogout = async () => {
  await authStore.logout()
}
</script>

<template>
  <div class="min-h-screen bg-base-200">
    <!-- ヘッダー -->
    <header class="navbar bg-base-100 shadow-lg sticky top-0 z-50">
      <div class="flex-1">
        <NuxtLink to="/souvenirs" class="btn btn-ghost text-xl">
          🎁 お土産ルーレット
        </NuxtLink>
      </div>
      <div class="flex-none gap-2">
        <NuxtLink to="/roulette" class="btn btn-primary btn-sm">
          🎲 ルーレット
        </NuxtLink>
        <div class="dropdown dropdown-end">
          <label tabindex="0" class="btn btn-ghost btn-circle avatar placeholder">
            <div class="bg-neutral text-neutral-content rounded-full w-10">
              <span class="text-sm">{{ authStore.user?.name?.charAt(0) || '?' }}</span>
            </div>
          </label>
          <ul tabindex="0" class="mt-3 z-[1] p-2 shadow menu menu-sm dropdown-content bg-base-100 rounded-box w-52">
            <li class="menu-title">
              <span>{{ authStore.user?.name }}</span>
            </li>
            <li><a @click="handleLogout">ログアウト</a></li>
          </ul>
        </div>
      </div>
    </header>

    <!-- メインコンテンツ -->
    <main>
      <slot />
    </main>
  </div>
</template>
