# ZIGCLIP MVP Setup Guide

## Quick Start

### 1. Prerequisites

Ensure you have Flutter installed:
```bash
flutter --version
```

If not installed, follow: https://docs.flutter.dev/get-started/install

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Add Assets (REQUIRED)

The app requires video and audio assets to function:

#### Video Files
Place 5 MP4 video files in `assets/videos/`:
- `clip_1.mp4`
- `clip_2.mp4`
- `clip_3.mp4`
- `clip_4.mp4`
- `clip_5.mp4`

**Recommended specs:**
- Duration: 12-20 seconds
- Format: MP4 (H.264)
- Resolution: 720p or 1080p
- Can be any video for testing

#### Audio File
Place 1 MP3 file in `assets/sounds/`:
- `kill_sound.mp3`

**Recommended specs:**
- Duration: ~200ms
- Format: MP3
- Type: Short sound effect

**Where to find free assets for testing:**
- Videos: Pexels.com, Pixabay.com (free stock videos)
- Audio: Freesound.org, Zapsplat.com, Mixkit.co

### 4. Run the App

**Mobile (Android/iOS):**
```bash
flutter run
```

**Web:**
```bash
flutter run -d chrome
```

**Build for Production:**
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web (PWA)
flutter build web --web-renderer canvaskit
```

## Project Structure

```
lib/
├── config/                   # Theme and configuration
│   ├── theme.dart           # Neon cyberpunk theme
│   ├── constants.dart       # ELO constants, paths
│   └── app_config.dart      # App-wide settings
├── models/                   # Data models
│   ├── clip.dart            # Clip with ELO score
│   ├── profile.dart         # User profile
│   ├── vote.dart            # Duel vote record
│   └── arena_state.dart     # Current arena state
├── services/                 # Business logic
│   ├── local_storage_service.dart    # JSON persistence
│   ├── elo_service.dart              # ELO calculations
│   ├── video_preloading_service.dart # Video management
│   └── audio_service.dart            # Sound effects
├── providers/                # Riverpod state management
│   ├── clips_provider.dart
│   ├── user_profile_provider.dart
│   ├── arena_state_provider.dart
│   ├── ranking_provider.dart
│   └── vote_history_provider.dart
├── widgets/                  # Reusable components
│   ├── video_player_widget.dart
│   ├── elo_delta_animation.dart
│   ├── neon_flash_widget.dart
│   ├── particle_effect.dart
│   ├── rank_badge.dart
│   ├── glassmorphic_card.dart
│   └── arena_video_pair.dart
├── screens/                  # Main screens
│   ├── the_arena.dart       # Main duel screen
│   ├── the_wall_of_ego.dart # Rankings
│   └── the_brag.dart        # Profile & export
└── utils/                    # Utilities
    ├── elo_calculator.dart
    ├── image_exporter.dart
    └── qr_generator.dart
```

## How It Works

### The Arena
1. Two videos load simultaneously (current and next)
2. User swipes UP on the better clip
3. ELO points calculated and applied
4. Animations play (flash, particles, sound)
5. Next duel automatically loads

### ELO System
- Initial rating: 1200
- K-factor: 32
- Formula: Standard chess ELO
- Updates in real-time
- Stored locally

### Video Preloading
- 3 controllers in memory:
  - **Current**: Playing now
  - **Next**: Ready to play
  - **Upcoming**: Preloading in background
- Zero-lag transitions
- Infinite loop through clips

### Storage
- All data stored locally via shared_preferences
- JSON format for clips, votes, profile
- No external API calls
- 100% offline functional

## Customization

### Change Theme Colors
Edit `lib/config/theme.dart`:
```dart
const Color neonCyan = Color(0xFF00FFD0);  // Primary color
const Color neonRed = Color(0xFFFF3B3B);   // Error/loss color
const Color bgDark = Color(0xFF050505);     // Background
```

### Adjust ELO Settings
Edit `lib/config/constants.dart`:
```dart
const double kFactor = 32.0;      // Rating volatility
const int initialElo = 1200;       // Starting rating
```

### Modify Ranking Size
Edit `lib/config/app_config.dart`:
```dart
static const int rankingTopCount = 100;  // Top N to display
```

## Troubleshooting

### Videos not loading
- Ensure MP4 files are in `assets/videos/`
- Check file names match exactly
- Verify pubspec.yaml includes `assets/videos/`

### No sound
- Ensure MP3 file is in `assets/sounds/`
- Check audio permissions (mobile)
- Verify pubspec.yaml includes `assets/sounds/`

### Build errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### White screen on web
- Use CanvasKit renderer:
```bash
flutter run -d chrome --web-renderer canvaskit
```

## Future Backend Integration

The architecture is ready for Supabase/Firebase:

1. Replace `LocalStorageService` with API service
2. Update providers to fetch from backend
3. Add authentication
4. Enable video uploads
5. Real-time multiplayer

All UI and business logic remains unchanged.

## Performance Tips

- Use release builds for testing performance
- Videos should be optimized (not raw)
- Consider lower resolution for web builds
- Enable code minification for production

## Support

For issues or questions, check:
- Flutter docs: https://docs.flutter.dev
- Riverpod docs: https://riverpod.dev
- Video player package: https://pub.dev/packages/video_player

## License

MIT License - feel free to use and modify for your projects.
