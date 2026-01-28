export interface User {
  id: number
  name: string
  email: string
  avatar_url?: string
  created_at: string
}

export interface Souvenir {
  id: number
  name: string
  price: number
  category: SouvenirCategory
  description?: string
  image_url?: string
  user: Pick<User, 'id' | 'name'>
  created_at: string
  updated_at: string
}

export type SouvenirCategory = 'food' | 'goods' | 'cosmetic' | 'craft' | 'other'

export interface ApiError {
  errors: string[]
}

export interface ApiResponse<T> {
  data?: T
  errors?: string[]
}

export const CATEGORY_LABELS: Record<SouvenirCategory, string> = {
  food: '食品',
  goods: '雑貨',
  cosmetic: 'コスメ',
  craft: '工芸品',
  other: 'その他'
}
