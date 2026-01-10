# ZIGCLIP

A Flutter app for video clip voting with ELO ratings. Swipe right to vote a clip as winner, swipe left for loser. Watch ELO scores evolve in real-time with neon-themed animations.

## Features

- **THE ARENA**: Core voting experience with swipe gestures
- **Video Preloading**: Aggressive N+2 preloading for seamless transitions
- **ELO System**: Dynamic rating calculation with K-factor 32
- **Neon UI**: Cyberpunk-inspired glassmorphism design
- **PWA Ready**: Works on web with CanvasKit renderer

## Project Structure

```
lib/
├── config/          # Theme, constants, Supabase config
├── models/          # Data models (Clip, Profile, Vote)
├── services/        # Business logic (Video preloader, ELO, Supabase)
├── providers/       # Riverpod state management
├── widgets/         # Reusable UI components
├── screens/         # App screens (Arena, Ranking, Dossier)
└── utils/           # Helper utilities
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Supabase account (optional, runs in stub mode)

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Configuration

Update `lib/config/supabase_client.dart` with your Supabase credentials:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_ANON_KEY';
```

## Architecture

### State Management

Uses **Riverpod** for reactive state management:
- `clipProvider`: Manages arena clips and current index
- `authProvider`: Handles authentication state
- `eloProvider`: Tracks ELO feedback animations

### Video Preloading

The `VideoPreloadingService` maintains 2 active `VideoPlayerController` instances:
- Current clip (playing)
- Next clip (preloaded, paused)
- Aggressively preloads N+2 in background

### ELO Calculation

Standard ELO formula with K-factor 32:
```
delta = K * (1 - expected_winner)
expected = 1 / (1 + 10^((ratingB - ratingA) / 400))
```

## UI/UX

### Swipe Gestures

- **Swipe Right**: Current clip wins (+ELO)
- **Swipe Left**: Current clip loses (-ELO)
- Threshold: 100px

### Animations

- **300ms**: Transition duration for fades and scales
- **1500ms**: ELO feedback display time
- **Cyan flash**: Winner animation
- **Red flash**: Loser animation

### Theme

- **Dark BG**: #050505
- **Neon Cyan**: #00FFD0
- **Neon Red**: #FF3B3B
- **Text Elite**: #B0B0B0

## Development

### Run Tests

```bash
flutter test
```

### Analyze Code

```bash
flutter analyze
```

### Build for Web

```bash
flutter build web --web-renderer canvaskit
```

## License

MIT
