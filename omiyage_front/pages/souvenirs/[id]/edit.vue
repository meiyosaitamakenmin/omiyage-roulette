<script setup lang="ts">
import type { Souvenir, SouvenirCategory } from '~/types'
import { CATEGORY_LABELS } from '~/types'

definePageMeta({
  middleware: 'auth'
})

const { api } = useApi()
const router = useRouter()
const route = useRoute()

const souvenirId = computed(() => route.params.id as string)

const form = reactive({
  name: '',
  price: 0,
  category: 'food' as SouvenirCategory,
  description: '',
  image_url: '',
})
const errors = ref<string[]>([])
const isLoading = ref(true)
const isSubmitting = ref(false)

const categories = Object.entries(CATEGORY_LABELS).map(([value, label]) => ({
  value,
  label,
}))

const fetchSouvenir = async () => {
  try {
    const response = await api<{ souvenir: Souvenir }>(`/api/v1/souvenirs/${souvenirId.value}`)
    const s = response.souvenir
    form.name = s.name
    form.price = s.price
    form.category = s.category
    form.description = s.description || ''
    form.image_url = s.image_url || ''
  } catch (e) {
    errors.value = ['お土産の取得に失敗しました']
  } finally {
    isLoading.value = false
  }
}

const handleSubmit = async () => {
  errors.value = []
  isSubmitting.value = true

  try {
    await api(`/api/v1/souvenirs/${souvenirId.value}`, {
      method: 'PUT',
      body: JSON.stringify({ souvenir: form }),
    })
    router.push('/souvenirs')
  } catch (e: any) {
    errors.value = e.data?.errors || ['更新に失敗しました']
  } finally {
    isSubmitting.value = false
  }
}

onMounted(fetchSouvenir)
</script>

<template>
  <div class="container mx-auto px-4 py-8 max-w-lg">
    <h1 class="text-2xl font-bold mb-6">お土産を編集</h1>

    <!-- ローディング -->
    <div v-if="isLoading" class="flex justify-center py-12">
      <span class="loading loading-spinner loading-lg"></span>
    </div>

    <template v-else>
      <!-- エラー表示 -->
      <div v-if="errors.length" class="alert alert-error mb-4">
        <ul class="list-disc list-inside">
          <li v-for="error in errors" :key="error">{{ error }}</li>
        </ul>
      </div>

      <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
          <form @submit.prevent="handleSubmit">
            <!-- 名前 -->
            <div class="form-control mb-4">
              <label class="label">
                <span class="label-text">名前 <span class="text-error">*</span></span>
              </label>
              <input
                v-model="form.name"
                type="text"
                class="input input-bordered w-full"
                required
                maxlength="100"
              />
            </div>

            <!-- 価格 -->
            <div class="form-control mb-4">
              <label class="label">
                <span class="label-text">価格 <span class="text-error">*</span></span>
              </label>
              <div class="join">
                <span class="join-item btn btn-disabled">¥</span>
                <input
                  v-model.number="form.price"
                  type="number"
                  min="1"
                  max="1000000"
                  class="input input-bordered join-item w-full"
                  required
                />
              </div>
            </div>

            <!-- カテゴリ -->
            <div class="form-control mb-4">
              <label class="label">
                <span class="label-text">カテゴリ <span class="text-error">*</span></span>
              </label>
              <select v-model="form.category" class="select select-bordered w-full">
                <option v-for="cat in categories" :key="cat.value" :value="cat.value">
                  {{ cat.label }}
                </option>
              </select>
            </div>

            <!-- 説明 -->
            <div class="form-control mb-4">
              <label class="label">
                <span class="label-text">説明（任意）</span>
              </label>
              <textarea
                v-model="form.description"
                class="textarea textarea-bordered w-full"
                rows="3"
              ></textarea>
            </div>

            <!-- 画像URL -->
            <div class="form-control mb-6">
              <label class="label">
                <span class="label-text">画像URL（任意）</span>
              </label>
              <input
                v-model="form.image_url"
                type="url"
                class="input input-bordered w-full"
              />
            </div>

            <!-- ボタン -->
            <div class="flex gap-2">
              <button
                type="submit"
                class="btn btn-primary flex-1"
                :disabled="isSubmitting"
              >
                <span v-if="isSubmitting" class="loading loading-spinner loading-sm"></span>
                <span v-else>更新する</span>
              </button>
              <NuxtLink to="/souvenirs" class="btn btn-ghost">
                キャンセル
              </NuxtLink>
            </div>
          </form>
        </div>
      </div>
    </template>
  </div>
</template>
