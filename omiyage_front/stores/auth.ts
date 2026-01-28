import { defineStore } from 'pinia'
import type { User } from '~/types'

interface AuthState {
  user: User | null
  isLoading: boolean
  isInitialized: boolean
}

interface AuthResult {
  success: boolean
  errors?: string[]
}

export const useAuthStore = defineStore('auth', {
  state: (): AuthState => ({
    user: null,
    isLoading: false,
    isInitialized: false,
  }),

  getters: {
    isLoggedIn: (state): boolean => !!state.user,
  },

  actions: {
    async login(email: string, password: string): Promise<AuthResult> {
      this.isLoading = true
      try {
        const { api } = useApi()
        const response = await api<{ user: User }>('/api/v1/sessions', {
          method: 'POST',
          body: JSON.stringify({ email, password }),
        })
        this.user = response.user
        return { success: true }
      } catch (error: any) {
        const errors = error.data?.errors || ['ログインに失敗しました']
        return { success: false, errors }
      } finally {
        this.isLoading = false
      }
    },

    async logout(): Promise<void> {
      try {
        const { api } = useApi()
        await api('/api/v1/sessions', { method: 'DELETE' })
      } catch (error) {
        console.error('Logout error:', error)
      } finally {
        this.user = null
        navigateTo('/login')
      }
    },

    async register(
      name: string,
      email: string,
      password: string,
      passwordConfirmation: string
    ): Promise<AuthResult> {
      this.isLoading = true
      try {
        const { api } = useApi()
        const response = await api<{ user: User }>('/api/v1/registrations', {
          method: 'POST',
          body: JSON.stringify({
            user: {
              name,
              email,
              password,
              password_confirmation: passwordConfirmation
            }
          }),
        })
        this.user = response.user
        return { success: true }
      } catch (error: any) {
        const errors = error.data?.errors || ['登録に失敗しました']
        return { success: false, errors }
      } finally {
        this.isLoading = false
      }
    },

    async fetchCurrentUser(): Promise<void> {
      try {
        const { api } = useApi()
        const response = await api<{ user: User }>('/api/v1/me')
        this.user = response.user
      } catch {
        this.user = null
      } finally {
        this.isInitialized = true
      }
    },

    async initialize(): Promise<void> {
      if (!this.isInitialized) {
        await this.fetchCurrentUser()
      }
    },
  },
})
