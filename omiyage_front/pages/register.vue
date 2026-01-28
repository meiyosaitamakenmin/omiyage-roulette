<script setup lang="ts">
definePageMeta({
  layout: false,
  middleware: 'guest'
})

const authStore = useAuthStore()
const router = useRouter()

const form = reactive({
  name: '',
  email: '',
  password: '',
  passwordConfirmation: '',
})
const errors = ref<string[]>([])
const isSubmitting = ref(false)

const handleSubmit = async () => {
  errors.value = []
  isSubmitting.value = true

  const result = await authStore.register(
    form.name,
    form.email,
    form.password,
    form.passwordConfirmation
  )

  if (result.success) {
    router.push('/souvenirs')
  } else {
    errors.value = result.errors || []
  }

  isSubmitting.value = false
}
</script>

<template>
  <div class="min-h-screen bg-base-200 flex items-center justify-center p-4">
    <div class="card w-full max-w-md bg-base-100 shadow-xl">
      <div class="card-body">
        <h1 class="text-3xl font-bold text-center mb-2">🎁</h1>
        <h2 class="card-title text-2xl justify-center mb-4">新規登録</h2>

        <!-- エラー表示 -->
        <div v-if="errors.length" class="alert alert-error mb-4">
          <svg xmlns="http://www.w3.org/2000/svg" class="stroke-current shrink-0 h-6 w-6" fill="none" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
          </svg>
          <ul class="list-disc list-inside">
            <li v-for="error in errors" :key="error">{{ error }}</li>
          </ul>
        </div>

        <form @submit.prevent="handleSubmit">
          <div class="form-control mb-4">
            <label class="label">
              <span class="label-text">名前</span>
            </label>
            <input
              v-model="form.name"
              type="text"
              placeholder="山田 太郎"
              class="input input-bordered w-full"
              required
              autocomplete="name"
            />
          </div>

          <div class="form-control mb-4">
            <label class="label">
              <span class="label-text">メールアドレス</span>
            </label>
            <input
              v-model="form.email"
              type="email"
              placeholder="example@email.com"
              class="input input-bordered w-full"
              required
              autocomplete="email"
            />
          </div>

          <div class="form-control mb-4">
            <label class="label">
              <span class="label-text">パスワード（6文字以上）</span>
            </label>
            <input
              v-model="form.password"
              type="password"
              placeholder="••••••••"
              class="input input-bordered w-full"
              required
              minlength="6"
              autocomplete="new-password"
            />
          </div>

          <div class="form-control mb-6">
            <label class="label">
              <span class="label-text">パスワード（確認）</span>
            </label>
            <input
              v-model="form.passwordConfirmation"
              type="password"
              placeholder="••••••••"
              class="input input-bordered w-full"
              required
              minlength="6"
              autocomplete="new-password"
            />
          </div>

          <button
            type="submit"
            class="btn btn-primary w-full"
            :disabled="isSubmitting"
          >
            <span v-if="isSubmitting" class="loading loading-spinner loading-sm"></span>
            <span v-else>登録する</span>
          </button>
        </form>

        <div class="divider">または</div>

        <p class="text-center">
          すでにアカウントをお持ちの方は
          <NuxtLink to="/login" class="link link-primary">ログイン</NuxtLink>
        </p>
      </div>
    </div>
  </div>
</template>
