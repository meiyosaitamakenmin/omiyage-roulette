<script setup lang="ts">
import confetti from 'canvas-confetti'
import type { Souvenir, SouvenirCategory } from '~/types'
import { CATEGORY_LABELS } from '~/types'

definePageMeta({
  middleware: 'auth'
})

const { api } = useApi()

const budget = ref<number>(3000)
const category = ref<string>('')
const isSpinning = ref(false)
const result = ref<Souvenir | null>(null)
const showModal = ref(false)
const noResult = ref(false)

// ダミーデータ（演出用）
const dummyItems = [
  { name: '???', price: '???' },
  { name: 'もみじ饅頭', price: '¥1,200' },
  { name: '八ツ橋', price: '¥800' },
  { name: '白い恋人', price: '¥1,500' },
  { name: '赤福', price: '¥1,000' },
  { name: 'ちんすこう', price: '¥600' },
  { name: '萩の月', price: '¥1,800' },
]
const currentDummy = ref(dummyItems[0])

const categories = [
  { value: '', label: '指定なし' },
  ...Object.entries(CATEGORY_LABELS).map(([value, label]) => ({ value, label }))
]

const startRoulette = async () => {
  isSpinning.value = true
  noResult.value = false
  result.value = null

  // ダミー表示のアニメーション
  let count = 0
  const interval = setInterval(() => {
    currentDummy.value = dummyItems[count % dummyItems.length]
    count++
  }, 80)

  // API呼び出し
  try {
    const params = new URLSearchParams({ budget: budget.value.toString() })
    if (category.value) params.append('category', category.value)

    const response = await api<{ souvenir: Souvenir | null; message?: string }>(
      `/api/v1/souvenirs/random?${params}`
    )

    // 演出のため少し待つ（2〜3秒）
    await new Promise(resolve => setTimeout(resolve, 2500))

    clearInterval(interval)
    isSpinning.value = false

    if (response.souvenir) {
      result.value = response.souvenir
      showModal.value = true

      // 紙吹雪エフェクト
      confetti({
        particleCount: 150,
        spread: 80,
        origin: { y: 0.6 }
      })

      // 追加の紙吹雪
      setTimeout(() => {
        confetti({
          particleCount: 50,
          angle: 60,
          spread: 55,
          origin: { x: 0 }
        })
        confetti({
          particleCount: 50,
          angle: 120,
          spread: 55,
          origin: { x: 1 }
        })
      }, 250)
    } else {
      noResult.value = true
    }
  } catch (error) {
    clearInterval(interval)
    isSpinning.value = false
    noResult.value = true
  }
}

const closeModal = () => {
  showModal.value = false
  result.value = null
}

const tryAgain = () => {
  closeModal()
  startRoulette()
}

const getCategoryLabel = (cat: SouvenirCategory) => {
  return CATEGORY_LABELS[cat] || cat
}

const formatPrice = (price: number) => {
  return `¥${price.toLocaleString()}`
}
</script>

<template>
  <div class="min-h-screen bg-gradient-to-br from-primary/5 via-base-100 to-secondary/5">
    <div class="container mx-auto px-4 py-8 max-w-md">
      <!-- タイトル -->
      <div class="text-center mb-8">
        <h1 class="text-4xl font-bold mb-2">🎰</h1>
        <h2 class="text-2xl font-bold">お土産ルーレット</h2>
        <p class="text-gray-500 mt-2">予算とカテゴリを選んでSTART！</p>
      </div>

      <!-- 入力フォーム -->
      <div class="card bg-base-100 shadow-xl">
        <div class="card-body">
          <!-- 予算 -->
          <div class="form-control mb-4">
            <label class="label">
              <span class="label-text font-bold text-lg">💰 予算（上限）</span>
            </label>
            <div class="join">
              <span class="join-item btn btn-disabled">¥</span>
              <input
                v-model.number="budget"
                type="number"
                min="100"
                max="1000000"
                step="100"
                class="input input-bordered join-item w-full text-lg"
                :disabled="isSpinning"
              />
            </div>
            <label class="label">
              <span class="label-text-alt">100円〜1,000,000円</span>
            </label>
          </div>

          <!-- カテゴリ -->
          <div class="form-control mb-6">
            <label class="label">
              <span class="label-text font-bold text-lg">📦 カテゴリ</span>
            </label>
            <select
              v-model="category"
              class="select select-bordered w-full text-lg"
              :disabled="isSpinning"
            >
              <option v-for="cat in categories" :key="cat.value" :value="cat.value">
                {{ cat.label }}
              </option>
            </select>
          </div>

          <!-- ルーレット表示エリア -->
          <div
            v-if="isSpinning"
            class="bg-gradient-to-r from-primary/10 to-secondary/10 rounded-2xl p-8 text-center mb-6 animate-pulse"
          >
            <div class="text-6xl mb-4 animate-bounce">🎁</div>
            <div class="text-3xl font-bold text-primary mb-2">{{ currentDummy.name }}</div>
            <div class="text-xl text-gray-500">{{ currentDummy.price }}</div>
          </div>

          <!-- 該当なし表示 -->
          <div
            v-if="noResult && !isSpinning"
            class="alert alert-warning mb-6"
          >
            <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
            </svg>
            <div>
              <h3 class="font-bold">見つかりませんでした</h3>
              <div class="text-sm">条件を変更して再度お試しください</div>
            </div>
          </div>

          <!-- START ボタン -->
          <button
            class="btn btn-primary btn-lg w-full text-xl h-16"
            :class="{ 'animate-pulse': isSpinning }"
            :disabled="isSpinning || budget < 100"
            @click="startRoulette"
          >
            <span v-if="isSpinning" class="loading loading-spinner loading-md"></span>
            <span v-else>🎲 START</span>
          </button>
        </div>
      </div>

      <!-- 一覧へのリンク -->
      <div class="text-center mt-6">
        <NuxtLink to="/souvenirs" class="link link-primary">
          ← お土産一覧に戻る
        </NuxtLink>
      </div>
    </div>

    <!-- 結果モーダル -->
    <Teleport to="body">
      <div v-if="showModal" class="result-modal-overlay">
        <!-- 暗い背景レイヤー -->
        <div class="result-modal-backdrop" @click="closeModal"></div>

        <!-- モーダルコンテンツ（明るく表示） -->
        <div class="result-modal-content">
          <h3 class="font-bold text-3xl text-center mb-6">🎉 決定！</h3>

          <div v-if="result" class="text-center">
            <!-- 画像 -->
            <div class="w-40 h-40 mx-auto mb-4 bg-base-200 rounded-2xl flex items-center justify-center overflow-hidden">
              <img
                v-if="result.image_url"
                :src="result.image_url"
                :alt="result.name"
                class="w-full h-full object-cover"
              />
              <span v-else class="text-7xl">🎁</span>
            </div>

            <!-- 名前 -->
            <h4 class="text-2xl font-bold mb-3">{{ result.name }}</h4>

            <!-- 価格・カテゴリ -->
            <div class="flex justify-center gap-3 mb-4">
              <span class="badge badge-lg badge-primary text-lg px-4 py-3">
                {{ formatPrice(result.price) }}
              </span>
              <span class="badge badge-lg badge-secondary text-lg px-4 py-3">
                {{ getCategoryLabel(result.category) }}
              </span>
            </div>

            <!-- 説明 -->
            <p v-if="result.description" class="text-gray-600 mb-6 text-sm">
              {{ result.description }}
            </p>
          </div>

          <div class="flex justify-center gap-3 mt-6">
            <button class="btn btn-primary btn-lg" @click="tryAgain">
              🎲 もう一度
            </button>
            <button class="btn btn-ghost btn-lg" @click="closeModal">
              閉じる
            </button>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<style scoped>
/* モーダルオーバーレイ - 親コンテナ */
.result-modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1rem;
}

/* 暗い背景レイヤー */
.result-modal-backdrop {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.7);
  z-index: 1;
  animation: fadeIn 0.3s ease-out;
}

/* モーダルコンテンツ - 明るく目立つように */
.result-modal-content {
  position: relative;
  z-index: 2;
  background-color: #ffffff !important;
  color: #1f2937 !important;
  border-radius: 1rem;
  padding: 2rem;
  max-width: 28rem;
  width: 100%;
  max-height: 90vh;
  overflow-y: auto;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.8);
  animation: modalSlideIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* フェードインアニメーション */
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

/* スライド＆バウンスイン アニメーション */
@keyframes modalSlideIn {
  from {
    opacity: 0;
    transform: translateY(-50px) scale(0.9);
  }
  to {
    opacity: 1;
    transform: translateY(0) scale(1);
  }
}
</style>
