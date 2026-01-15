// Shared TypeScript Types for Edge Functions

export interface ApiResponse<T> {
  data: T
  meta: {
    request_id: string
    ts: string
  }
}

export interface ApiError {
  error: {
    code: string
    message: string
    details?: any
  }
  meta: {
    request_id: string
    ts: string
  }
}

export interface PaginationMeta {
  page: number
  page_size: number
  total: number
  has_more: boolean
  next_cursor?: string
}

export interface PaginatedResponse<T> extends ApiResponse<T[]> {
  meta: ApiResponse<T[]>['meta'] & PaginationMeta
}
