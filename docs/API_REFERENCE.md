# SmartFlowPro API Reference

This document provides comprehensive documentation for all API endpoints used in the SmartFlowPro mobile application.

## Base URLs

- **Edge Functions Base**: `{SUPABASE_URL}/functions/v1`
- **REST API Base**: `{SUPABASE_URL}/rest/v1`
- **Storage Base**: `{SUPABASE_URL}/storage/v1`
- **Realtime**: `wss://{PROJECT_REF}.supabase.co/realtime/v1`

## Authentication

All API requests (except auth endpoints) require authentication via JWT token in the Authorization header:

```
Authorization: Bearer {JWT_TOKEN}
apikey: {SUPABASE_ANON_KEY}
```

---

## Authentication Endpoints

### Login
- **Endpoint**: `POST /v1/auth/login`
- **Description**: Authenticate technician and receive JWT token
- **Request Body**:
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```
- **Response**: `200 OK`
  ```json
  {
    "token": "string",
    "refresh_token": "string",
    "user": {
      "id": "string",
      "email": "string",
      "full_name": "string",
      "role": "technician",
      "org_id": "string"
    }
  }
  ```
- **Error Codes**: `401` (Invalid credentials), `422` (Validation error)

### Signup
- **Endpoint**: `POST /v1/auth/signup`
- **Description**: Register new technician account
- **Request Body**:
  ```json
  {
    "email": "string",
    "password": "string",
    "full_name": "string",
    "phone": "string",
    "org_id": "string"
  }
  ```
- **Response**: `201 Created`
- **Error Codes**: `422` (Validation error), `409` (Email already exists)

### Logout
- **Endpoint**: `POST /v1/auth/logout`
- **Description**: Invalidate current session
- **Response**: `200 OK`

### Refresh Token
- **Endpoint**: `POST /v1/auth/refresh`
- **Description**: Refresh JWT token using refresh token
- **Request Body**:
  ```json
  {
    "refresh_token": "string"
  }
  ```
- **Response**: `200 OK`
  ```json
  {
    "token": "string",
    "refresh_token": "string"
  }
  ```
- **Error Codes**: `401` (Invalid refresh token)

### Forgot Password
- **Endpoint**: `POST /v1/auth/forgot-password`
- **Description**: Request password reset OTP
- **Request Body**:
  ```json
  {
    "email": "string"
  }
  ```
- **Response**: `200 OK`

### Verify OTP
- **Endpoint**: `POST /v1/auth/verify-otp`
- **Description**: Verify OTP for password reset
- **Request Body**:
  ```json
  {
    "email": "string",
    "otp": "string"
  }
  ```
- **Response**: `200 OK`
- **Error Codes**: `422` (Invalid OTP), `429` (Too many attempts)

### Reset Password
- **Endpoint**: `POST /v1/auth/reset-password`
- **Description**: Reset password with verified OTP
- **Request Body**:
  ```json
  {
    "email": "string",
    "otp": "string",
    "new_password": "string"
  }
  ```
- **Response**: `200 OK`
- **Error Codes**: `422` (Validation error), `401` (Invalid OTP)

---

## Visit Endpoints

### Get Today's Visits
- **Endpoint**: `GET /v1/tech/visits/today`
- **Description**: Get all visits scheduled for today for the authenticated technician
- **Response**: `200 OK`
  ```json
  {
    "visits": [
      {
        "id": "string",
        "org_id": "string",
        "job_id": "string",
        "technician_id": "string",
        "scheduled_start": "2024-01-01T10:00:00Z",
        "scheduled_end": "2024-01-01T12:00:00Z",
        "status": "scheduled",
        "version": 1
      }
    ]
  }
  ```
- **Error Codes**: `401` (Unauthorized), `403` (Forbidden)

### Get Visit Details
- **Endpoint**: `GET /v1/tech/visits/{visitId}`
- **Description**: Get detailed information about a specific visit
- **Path Parameters**: `visitId` (string) - Visit ID
- **Response**: `200 OK`
  ```json
  {
    "id": "string",
    "org_id": "string",
    "job_id": "string",
    "technician_id": "string",
    "scheduled_start": "2024-01-01T10:00:00Z",
    "scheduled_end": "2024-01-01T12:00:00Z",
    "actual_start": "2024-01-01T10:05:00Z",
    "actual_end": null,
    "status": "in_progress",
    "version": 2
  }
  ```
- **Error Codes**: `404` (Visit not found), `403` (Access denied)

### Start Visit
- **Endpoint**: `POST /v1/tech/visits/{visitId}/start`
- **Description**: Start a scheduled visit (state transition: scheduled → in_progress)
- **Path Parameters**: `visitId` (string) - Visit ID
- **Request Body**:
  ```json
  {
    "actual_start": "2024-01-01T10:00:00Z"
  }
  ```
- **Response**: `200 OK` (Returns updated visit)
- **Error Codes**: `409` (State transition conflict), `422` (Validation error)

### Pause Visit
- **Endpoint**: `POST /v1/tech/visits/{visitId}/pause`
- **Description**: Pause an in-progress visit (state transition: in_progress → paused)
- **Path Parameters**: `visitId` (string) - Visit ID
- **Request Body**:
  ```json
  {
    "status_reason": "string (optional)"
  }
  ```
- **Response**: `200 OK` (Returns updated visit)
- **Error Codes**: `409` (State transition conflict), `422` (Validation error)

### Complete Visit
- **Endpoint**: `POST /v1/tech/visits/{visitId}/complete`
- **Description**: Complete a visit (state transition: in_progress/paused → completed)
- **Path Parameters**: `visitId` (string) - Visit ID
- **Request Body**:
  ```json
  {
    "actual_end": "2024-01-01T12:00:00Z",
    "signature_url": "string (required)"
  }
  ```
- **Response**: `200 OK` (Returns updated visit)
- **Error Codes**: `409` (State transition conflict), `422` (Signature required), `403` (Forbidden)

---

## Notes Endpoints

### Get Visit Notes
- **Endpoint**: `GET /v1/tech/visits/{visitId}/notes`
- **Description**: Get all notes for a visit
- **Path Parameters**: `visitId` (string) - Visit ID
- **Response**: `200 OK`
  ```json
  {
    "notes": [
      {
        "id": "string",
        "visit_id": "string",
        "author_id": "string",
        "body": "string",
        "created_at": "2024-01-01T10:00:00Z",
        "version": 1
      }
    ]
  }
  ```

### Add Note
- **Endpoint**: `POST /v1/tech/visits/{visitId}/notes`
- **Description**: Add a new note to a visit
- **Path Parameters**: `visitId` (string) - Visit ID
- **Request Body**:
  ```json
  {
    "body": "string",
    "is_internal": false,
    "image_urls": ["string"]
  }
  ```
- **Response**: `201 Created` (Returns created note)
- **Error Codes**: `422` (Validation error), `409` (Conflict)

### Update Note
- **Endpoint**: `PUT /v1/tech/visits/{visitId}/notes/{noteId}`
- **Description**: Update an existing note
- **Path Parameters**: 
  - `visitId` (string) - Visit ID
  - `noteId` (string) - Note ID
- **Request Body**:
  ```json
  {
    "body": "string",
    "version": 1
  }
  ```
- **Response**: `200 OK` (Returns updated note)
- **Error Codes**: `409` (Version conflict), `422` (Validation error)

### Delete Note
- **Endpoint**: `DELETE /v1/tech/visits/{visitId}/notes/{noteId}`
- **Description**: Delete a note
- **Path Parameters**: 
  - `visitId` (string) - Visit ID
  - `noteId` (string) - Note ID
- **Response**: `204 No Content`
- **Error Codes**: `404` (Note not found), `403` (Forbidden)

---

## Media Endpoints

### Get Visit Media
- **Endpoint**: `GET /v1/tech/visits/{visitId}/media`
- **Description**: Get all media files for a visit
- **Path Parameters**: `visitId` (string) - Visit ID
- **Response**: `200 OK`
  ```json
  {
    "media": [
      {
        "id": "string",
        "visit_id": "string",
        "url": "string",
        "file_type": "image",
        "created_at": "2024-01-01T10:00:00Z"
      }
    ]
  }
  ```

### Request Upload URL
- **Endpoint**: `POST /v1/tech/{entityType}/{entityId}/media/upload-url`
- **Description**: Request a signed URL for uploading media
- **Path Parameters**: 
  - `entityType` (string) - Entity type (e.g., "visits", "inventory")
  - `entityId` (string) - Entity ID
- **Request Body**:
  ```json
  {
    "path": "string",
    "filename": "string",
    "content_type": "image/jpeg"
  }
  ```
- **Response**: `200 OK`
  ```json
  {
    "upload_url": "string",
    "file_key": "string",
    "public_url": "string"
  }
  ```

### Confirm Media Upload
- **Endpoint**: `POST /v1/tech/{entityType}/{entityId}/media/confirm`
- **Description**: Confirm media upload completion
- **Path Parameters**: 
  - `entityType` (string) - Entity type
  - `entityId` (string) - Entity ID
- **Request Body**:
  ```json
  {
    "file_key": "string",
    "path": "string"
  }
  ```
- **Response**: `200 OK` (Returns media record)

### Delete Media
- **Endpoint**: `DELETE /v1/tech/{entityType}/{entityId}/media`
- **Description**: Delete a media file
- **Path Parameters**: 
  - `entityType` (string) - Entity type
  - `entityId` (string) - Entity ID
- **Query Parameters**: `url` (string) - Media URL to delete
- **Response**: `204 No Content`
- **Error Codes**: `404` (Media not found), `403` (Forbidden)

---

## Signature Endpoints

### Get Visit Signature
- **Endpoint**: `GET /v1/tech/visits/{visitId}/signature`
- **Description**: Get signature for a visit
- **Path Parameters**: `visitId` (string) - Visit ID
- **Response**: `200 OK`
  ```json
  {
    "id": "string",
    "visit_id": "string",
    "signature_url": "string",
    "created_at": "2024-01-01T10:00:00Z"
  }
  ```
- **Error Codes**: `404` (Signature not found)

### Upload Signature
- **Endpoint**: `POST /v1/tech/visits/{visitId}/signature`
- **Description**: Upload signature for a visit (uses media upload flow)
- **Path Parameters**: `visitId` (string) - Visit ID
- **Request**: Uses media upload endpoints (upload-url → upload → confirm)
- **File Size Limit**: 5MB (per PRD Section 18)
- **Error Codes**: `422` (File too large, signature required), `409` (Conflict)

---

## Quote Endpoints

### Get Quote Details
- **Endpoint**: `GET /v1/tech/quotes/{quoteId}`
- **Description**: Get detailed information about a quote
- **Path Parameters**: `quoteId` (string) - Quote ID
- **Response**: `200 OK`
  ```json
  {
    "id": "string",
    "visit_id": "string",
    "status": "draft",
    "line_items": [],
    "version": 1
  }
  ```

### Create Quote
- **Endpoint**: `POST /v1/tech/visits/{visitId}/quotes`
- **Description**: Create a new draft quote for a visit
- **Path Parameters**: `visitId` (string) - Visit ID
- **Request Body**:
  ```json
  {
    "line_items": []
  }
  ```
- **Response**: `201 Created` (Returns created quote)
- **Error Codes**: `422` (Validation error), `409` (Conflict)

### Finalize Quote
- **Endpoint**: `POST /v1/tech/quotes/{quoteId}/finalize`
- **Description**: Finalize a draft quote (locks it, makes it read-only)
- **Path Parameters**: `quoteId` (string) - Quote ID
- **Request Body**:
  ```json
  {
    "version": 1
  }
  ```
- **Response**: `200 OK` (Returns finalized quote)
- **Error Codes**: `422` (Quote must have at least one line item), `409` (Version conflict), `403` (Already finalized)

---

## Inventory Endpoints

### Get Inventory List
- **Endpoint**: `GET /v1/tech/inventory`
- **Description**: Get paginated list of inventory items
- **Query Parameters**: 
  - `page` (int, default: 1)
  - `page_size` (int, default: 20, max: 100)
  - `search` (string, optional) - Search by name or SKU
- **Response**: `200 OK`
  ```json
  {
    "items": [],
    "page_info": {
      "current_page": 1,
      "page_size": 20,
      "total_count": 100,
      "has_next_page": true
    }
  }
  ```

### Get Inventory Item
- **Endpoint**: `GET /v1/tech/inventory/{itemId}`
- **Description**: Get details of a specific inventory item
- **Path Parameters**: `itemId` (string) - Item ID
- **Response**: `200 OK`

### Add Inventory Item
- **Endpoint**: `POST /v1/tech/inventory`
- **Description**: Create a new inventory item
- **Request Body**:
  ```json
  {
    "name": "string",
    "sku": "string",
    "unit": "string",
    "sale_price": 0.0,
    "taxable_default": true,
    "image_path": "string"
  }
  ```
- **Response**: `201 Created`
- **Error Codes**: `422` (Validation error), `409` (SKU already exists)

### AI Detect Inventory
- **Endpoint**: `POST /v1/tech/inventory/ai-detect`
- **Description**: Use AI to detect inventory item details from image
- **Request Body**: Form data with image file
- **Response**: `200 OK`
  ```json
  {
    "name": "string",
    "unit": "string",
    "suggested_price": 0.0,
    "sku": "string"
  }
  ```
- **Error Codes**: `422` (Invalid image), `429` (Rate limit exceeded)

---

## Invoice Endpoints

### Get Invoice List
- **Endpoint**: `GET /v1/tech/invoices`
- **Description**: Get paginated list of invoices
- **Query Parameters**: 
  - `page` (int, default: 1)
  - `page_size` (int, default: 20)
  - `status` (string, optional) - Filter by status
- **Response**: `200 OK`

### Get Invoice Details
- **Endpoint**: `GET /v1/tech/invoices/{invoiceId}`
- **Description**: Get detailed information about an invoice
- **Path Parameters**: `invoiceId` (string) - Invoice ID
- **Response**: `200 OK`

### Get Invoice Preview
- **Endpoint**: `GET /v1/tech/invoices/{invoiceId}/preview`
- **Description**: Get formatted invoice preview (PDF-ready)
- **Path Parameters**: `invoiceId` (string) - Invoice ID
- **Response**: `200 OK`

### Finalize Invoice
- **Endpoint**: `POST /v1/tech/invoices/{invoiceId}/finalize`
- **Description**: Finalize a draft invoice
- **Path Parameters**: `invoiceId` (string) - Invoice ID
- **Response**: `200 OK`
- **Error Codes**: `422` (Validation error), `409` (Conflict), `403` (Already finalized)

---

## Chat Endpoints

### Get Chat Threads
- **Endpoint**: `GET /v1/tech/chat/threads`
- **Description**: Get paginated list of chat threads for authenticated user
- **Query Parameters**: 
  - `page` (int, default: 1)
  - `page_size` (int, default: 20)
- **Response**: `200 OK`

### Get Chat Messages
- **Endpoint**: `GET /v1/tech/chat/threads/{threadId}/messages`
- **Description**: Get messages for a chat thread
- **Path Parameters**: `threadId` (string) - Thread ID
- **Query Parameters**: 
  - `page` (int, default: 1)
  - `page_size` (int, default: 50)
- **Response**: `200 OK`

### Send Message
- **Endpoint**: `POST /v1/tech/chat/threads/{threadId}/messages`
- **Description**: Send a message in a chat thread
- **Path Parameters**: `threadId` (string) - Thread ID
- **Request Body**:
  ```json
  {
    "content": "string"
  }
  ```
- **Response**: `201 Created` (Returns created message)

---

## AI Assistant Endpoints

### AI Chat
- **Endpoint**: `POST /v1/tech/ai/chat`
- **Description**: Send a message to AI assistant
- **Request Body**:
  ```json
  {
    "message": "string",
    "visit_id": "string (optional)",
    "context": {}
  }
  ```
- **Response**: `200 OK`
  ```json
  {
    "response": "string",
    "suggestions": ["string"]
  }
  ```
- **Error Codes**: `429` (Rate limit exceeded), `422` (Validation error)

### AI Analyze Image
- **Endpoint**: `POST /v1/tech/ai/analyze-image`
- **Description**: Analyze an image with AI
- **Request Body**: Form data with image file
- **Response**: `200 OK`
- **Error Codes**: `422` (Invalid image), `429` (Rate limit exceeded)

---

## Schedule Endpoints

### Get Schedule by Date
- **Endpoint**: `GET /v1/tech/schedule?date={date}`
- **Description**: Get visits scheduled for a specific date
- **Query Parameters**: `date` (string, format: YYYY-MM-DD)
- **Response**: `200 OK`

### Get Schedule by Range
- **Endpoint**: `GET /v1/tech/schedule?start={start}&end={end}`
- **Description**: Get visits scheduled for a date range
- **Query Parameters**: 
  - `start` (string, format: YYYY-MM-DD)
  - `end` (string, format: YYYY-MM-DD)
- **Response**: `200 OK`

---

## Error Codes

### Standard HTTP Status Codes

- **200 OK**: Request successful
- **201 Created**: Resource created successfully
- **204 No Content**: Request successful, no content to return
- **400 Bad Request**: Invalid request format
- **401 Unauthorized**: Authentication required or invalid token
- **403 Forbidden**: Insufficient permissions
- **404 Not Found**: Resource not found
- **409 Conflict**: Version conflict or state transition conflict
- **422 Unprocessable Entity**: Validation error (see error details)
- **429 Too Many Requests**: Rate limit exceeded
- **500 Internal Server Error**: Server error

### Error Response Format

```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "field_errors": {
      "field_name": "Field-specific error message"
    }
  }
}
```

### Common Error Codes

- `QUOTE_FINALIZATION_ERROR`: Quote must have at least one line item
- `PAYMENT_AMOUNT_ERROR`: Payment amount must be greater than zero
- `PAYMENT_EXCEEDS_BALANCE`: Payment exceeds remaining invoice balance
- `SIGNATURE_REQUIRED`: Signature required for visit completion
- `SERVICE_CALL_FEE_LOCKED`: Service call fee cannot be deleted or modified
- `VERSION_CONFLICT`: Optimistic locking conflict detected
- `STATE_TRANSITION_CONFLICT`: Invalid state transition

---

## File Upload Limits

Per PRD Section 18:

- **Images**: 10MB maximum
- **PDFs**: 25MB maximum
- **Videos**: 100MB maximum
- **Signatures**: 5MB maximum

---

## Pagination

All list endpoints support pagination:

- **Query Parameters**:
  - `page` (int): Page number (default: 1)
  - `page_size` (int): Items per page (default: 20, max: 100)

- **Response Format**:
  ```json
  {
    "data": [],
    "page_info": {
      "current_page": 1,
      "page_size": 20,
      "total_count": 100,
      "has_next_page": true,
      "has_previous_page": false
    }
  }
  ```

---

## Rate Limiting

- **AI Endpoints**: 100 requests per hour per user (configurable per org)
- **General API**: 1000 requests per minute per user
- **Rate Limit Headers**:
  - `X-RateLimit-Limit`: Maximum requests allowed
  - `X-RateLimit-Remaining`: Remaining requests
  - `X-RateLimit-Reset`: Time when limit resets (Unix timestamp)

---

## Realtime Subscriptions

The app uses Supabase Realtime for live updates:

- **Visits Channel**: `visits:{org_id}` - Listen for visit updates
- **Quotes Channel**: `quotes:{visit_id}` - Listen for quote updates
- **Chat Channel**: `chat:{thread_id}` - Listen for new messages

### Realtime Event Types

- `INSERT`: New record created
- `UPDATE`: Record updated
- `DELETE`: Record deleted

---

## Notes

1. All timestamps are in ISO 8601 format (UTC)
2. All monetary values are in cents (or smallest currency unit)
3. Version fields are used for optimistic locking - always include current version in update requests
4. All endpoints require authentication except auth endpoints
5. File uploads use signed URLs for security


