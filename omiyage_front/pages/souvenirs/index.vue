<script setup lang="ts">
import type { Souvenir, SouvenirCategory } from '~/types'
import { CATEGORY_LABELS } from '~/types'

definePageMeta({
  middleware: 'auth'
})

const { api } = useApi()

const souvenirs = ref<Souvenir[]>([])
const isLoading = ref(true)
const error = ref<string | null>(null)

const fetchSouvenirs = async () => {
  isLoading.value = true
  error.value = null
  try {
    const response = await api<{ souvenirs: Souvenir[] }>('/api/v1/souvenirs')
    souvenirs.value = response.souvenirs
  } catch (e: any) {
    error.value = 'お土産の取得に失敗しました'
    console.error(e)
  } finally {
    isLoading.value = false
  }
}

const deleteSouvenir = async (id: number) => {
  if (!confirm('本当に削除しますか？')) return

  try {
    await api(`/api/v1/souvenirs/${id}`, { method: 'DELETE' })
    souvenirs.value = souvenirs.value.filter(s => s.id !== id)
  } catch (e: any) {
    alert('削除に失敗しました')
  }
}

const getCategoryLabel = (category: SouvenirCategory): string => {
  return CATEGORY_LABELS[category] || category
}

const formatPrice = (price: number): string => {
  return `¥${price.toLocaleString()}`
}

onMounted(fetchSouvenirs)
</script>

<template>
  <div class="container mx-auto px-4 py-8">
    <!-- ヘッダー部分 -->
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold">お土産一覧</h1>
      <NuxtLink to="/souvenirs/new" class="btn btn-primary">
        ＋ 新規登録
      </NuxtLink>
    </div>

    <!-- ローディング -->
    <div v-if="isLoading" class="flex justify-center py-12">
      <span class="loading loading-spinner loading-lg"></span>
    </div>

    <!-- エラー -->
    <div v-else-if="error" class="alert alert-error">
      <span>{{ error }}</span>
      <button class="btn btn-sm" @click="fetchSouvenirs">再試行</button>
    </div>

    <!-- 空状態 -->
    <div v-else-if="souvenirs.length === 0" class="text-center py-12">
      <p class="text-6xl mb-4">🎁</p>
      <p class="text-lg text-gray-500 mb-4">まだお土産が登録されていません</p>
      <NuxtLink to="/souvenirs/new" class="btn btn-primary">
        最初のお土産を登録する
      </NuxtLink>
    </div>

    <!-- 一覧 -->
    <div v-else class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
      <div
        v-for="souvenir in souvenirs"
        :key="souvenir.id"
        class="card bg-base-100 shadow-md hover:shadow-lg transition-shadow"
      >
        <!-- 画像 -->
        <figure class="h-48 bg-base-200">
          <img
            v-if="souvenir.image_url"
            :src="souvenir.image_url"
            :alt="souvenir.name"
            class="w-full h-full object-cover"
          />
          <span v-else class="text-6xl">🎁</span>
        </figure>

        <div class="card-body">
          <!-- 名前 -->
          <h2 class="card-title">
            {{ souvenir.name }}
            <span class="badge badge-secondary">
              {{ getCategoryLabel(souvenir.category) }}
            </span>
          </h2>

          <!-- 価格 -->
          <p class="text-xl font-bold text-primary">
            {{ formatPrice(souvenir.price) }}
          </p>

          <!-- 説明 -->
          <p v-if="souvenir.description" class="text-sm text-gray-500 line-clamp-2">
            {{ souvenir.description }}
          </p>

          <!-- アクション -->
          <div class="card-actions justify-end mt-2">
            <NuxtLink
              :to="`/souvenirs/${souvenir.id}/edit`"
              class="btn btn-sm btn-ghost"
            >
              編集
            </NuxtLink>
            <button
              class="btn btn-sm btn-error btn-outline"
              @click="deleteSouvenir(souvenir.id)"
            >
              削除
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
