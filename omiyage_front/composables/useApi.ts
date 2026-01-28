export const useApi = () => {
  const config = useRuntimeConfig()
  const baseURL = config.public.apiBase as string

  const apiFetch = async <T>(
    path: string,
    options: RequestInit = {}
  ): Promise<T> => {
    try {
      const response = await $fetch<T>(`${baseURL}${path}`, {
        ...options,
        credentials: 'include',
        headers: {
          'Content-Type': 'application/json',
          ...options.headers,
        },
      })
      return response
    } catch (error: any) {
      // エラーレスポンスのボディを適切に取得して再スロー
      if (error.data) {
        throw { ...error, data: error.data }
      }
      throw error
    }
  }

  return {
    api: apiFetch,
    baseURL
  }
}
