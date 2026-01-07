# SmartFlowPro

SmartFlowPro is a comprehensive Field Service Management mobile application built with Flutter. It enables technicians to manage visits, create quotes and invoices, track inventory, communicate with customers, and leverage AI assistance - all while working offline.

## Features

- **Visit Management**: Schedule, start, pause, and complete visits with signature capture
- **Quotes & Invoices**: Create quotes, finalize them, and generate invoices
- **Inventory Management**: Track inventory items with AI-powered detection
- **Offline Support**: Full offline functionality with automatic sync when online
- **Real-time Updates**: Real-time chat and visit status updates (Phase 2)
- **AI Assistant**: Voice-to-text notes and image analysis
- **Conflict Resolution**: Optimistic locking with conflict detection and resolution

## Architecture

### State Management
- **Riverpod**: Primary state management solution
- **GoRouter**: Navigation and routing

### Data Layer
- **Repository Pattern**: Unified data fetching strategy (API → Cache → Mock)
- **Offline Queue**: Automatic queuing of mutations when offline
- **Conflict Detection**: Optimistic locking with version checking

### Backend Integration
- **Supabase**: Backend-as-a-Service platform
- **Edge Functions**: Business logic via Supabase Edge Functions
- **Storage**: Media files via Supabase Storage
- **Realtime**: Real-time updates via Supabase Realtime (Phase 2)

## Setup

### Prerequisites
- Flutter SDK 3.8.0 or higher
- Dart SDK 3.8.0 or higher
- Android Studio / Xcode (for mobile development)
- Supabase account (for backend)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd smartflowpro
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   
   Copy `.env.example` to `.env` and fill in your Supabase credentials:
   ```bash
   cp .env.example .env
   ```
   
   Edit `.env` with your Supabase project details:
   ```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=your-anon-key-here
   SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here
   ENVIRONMENT=development
   ```

4. **Run code generation**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

### Environment Variables

The app uses compile-time environment variables. To set them:

**For development:**
```bash
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co \
           --dart-define=SUPABASE_ANON_KEY=your-anon-key \
           --dart-define=ENVIRONMENT=development
```

**For production builds:**
```bash
flutter build apk --dart-define=SUPABASE_URL=https://your-project.supabase.co \
                 --dart-define=SUPABASE_ANON_KEY=your-anon-key \
                 --dart-define=ENVIRONMENT=production
```

Alternatively, use `flutter_dotenv` package for runtime environment variables.

## Project Structure

```
lib/
├── app/                    # App-level modules and components
│   ├── modules/           # Feature modules (auth, schedule, quotes, etc.)
│   ├── components/        # Reusable UI components
│   └── routes/            # Route definitions
├── core/                   # Core functionality
│   ├── config/            # App configuration (Supabase, etc.)
│   ├── constants/         # Constants and endpoints
│   ├── errors/            # Error handling and exceptions
│   ├── theme/             # App theme and styling
│   └── validation/        # Validation rules and validators
├── features/               # Feature-based modules
│   ├── visits/           # Visit management
│   ├── quotes/            # Quote management
│   ├── invoices/          # Invoice management
│   ├── inventory/         # Inventory management
│   ├── chat/             # Chat functionality
│   ├── ai_assistant/      # AI assistant features
│   └── auth/             # Authentication
├── shared/                 # Shared code
│   ├── data/             # Data layer (repositories, services)
│   ├── domain/            # Domain models
│   └── presentation/      # Shared UI widgets
└── router/                # Navigation router
```

## Backend Integration Guide

### Phase 1: Frontend Completion ✅
- [x] Conflict resolution with optimistic locking
- [x] Pagination for all list views
- [x] Media upload service with file size validation
- [x] Signature upload service
- [x] Schedule screen data connection
- [x] Error boundaries and global error handling
- [x] Code standardization and cleanup

### Phase 2: Backend Integration (In Progress)
- [ ] Supabase project setup
- [ ] Database schema creation
- [ ] Edge Functions implementation
- [ ] Storage buckets configuration
- [ ] Realtime subscriptions
- [ ] Authentication integration
- [ ] API endpoint implementation

### Supabase Setup

1. **Create Supabase Project**
   - Go to [Supabase Dashboard](https://app.supabase.com)
   - Create a new project
   - Note your project URL and API keys

2. **Database Schema**
   - Create tables per PRD schema
   - Set up Row Level Security (RLS) policies
   - Create indexes for performance

3. **Storage Buckets**
   - Create buckets: `visits`, `inventory`, `signatures`
   - Configure bucket policies
   - Set up signed URL generation

4. **Edge Functions**
   - Deploy Edge Functions for business logic
   - Implement API endpoints per PRD Section 29.2

5. **Realtime Channels**
   - Configure Realtime for chat, visits, quotes
   - Set up channel filters and policies

## API Endpoints

All API endpoints follow the pattern: `/v1/tech/{resource}/{id}/{action}`

### Visits
- `GET /v1/tech/visits/today` - Get today's visits
- `POST /v1/tech/visits/{id}/start` - Start a visit
- `POST /v1/tech/visits/{id}/pause` - Pause a visit
- `POST /v1/tech/visits/{id}/complete` - Complete a visit
- `GET /v1/tech/visits/{id}/notes` - Get visit notes
- `POST /v1/tech/visits/{id}/notes` - Add a note

### Quotes
- `GET /v1/tech/quotes` - Get quotes (supports pagination)
- `POST /v1/tech/quotes` - Create a quote
- `PATCH /v1/tech/quotes/{id}` - Update a quote
- `POST /v1/tech/quotes/{id}/finalize` - Finalize a quote

### Invoices
- `GET /v1/tech/invoices` - Get invoices (supports pagination)
- `POST /v1/tech/quotes/{id}/create-invoice-draft` - Create invoice from quote
- `POST /v1/tech/invoices/{id}/finalize` - Finalize invoice
- `POST /v1/tech/invoices/{id}/void` - Void invoice

### Inventory
- `GET /v1/tech/inventory` - Get inventory items (supports pagination)
- `POST /v1/tech/inventory` - Create inventory item
- `PATCH /v1/tech/inventory/{id}` - Update inventory item
- `DELETE /v1/tech/inventory/{id}` - Delete inventory item

## Validation Rules

Per PRD Section 18:

- **Quotes**: Must have at least one line item before finalization
- **Service Call Fee**: Cannot be deleted or modified once created
- **Payments**: Amount must be > 0 and cannot exceed remaining balance
- **Visits**: Signature required for completion
- **File Sizes**: Images (10MB), PDFs (25MB), Videos (100MB), Signatures (5MB)

## Error Handling

The app uses structured error handling with specific error codes:

- **422 Unprocessable Entity**: Validation errors with field-specific messages
- **409 Conflict**: Version conflicts (optimistic locking)
- **403 Forbidden**: Permission errors with role/channel context
- **401 Unauthorized**: Authentication errors with automatic token refresh

## Offline Support

The app supports full offline functionality:

- **Offline Queue**: Maximum 1000 operations (per PRD)
- **Priority System**: Critical actions (visit completion, signatures) processed first
- **Automatic Sync**: Syncs when connection is restored
- **Exponential Backoff**: Retry logic with exponential backoff
- **Conflict Resolution**: Handles conflicts when syncing

## Development

### Code Generation

After modifying models or providers, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Running Tests
```bash
flutter test
```

### Linting
```bash
flutter analyze
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Run tests and linting
4. Submit a pull request

## License

[Your License Here]

## Support

For issues and questions, please open an issue on GitHub.
# Smart-Flow_Mobile
