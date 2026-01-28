export const useApi = () => {
  const config = useRuntimeConfig()
  const baseURL = config.public.apiBase as string

  const apiFetch = async <T>(
    path: string,
    options: RequestInit = {}
  ): Promise<T> => {
    const response = await $fetch<T>(`${baseURL}${path}`, {
      ...options,
      credentials: 'include',
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
    })
    return response
  }

  return {
    api: apiFetch,
    baseURL
  }
}
