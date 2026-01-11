# ZIGCLIP MVP - Offline First

A competitive skill validation app for gaming clips with ELO ranking system, built with Flutter.

## Features

- **The Arena**: Binary duels with swipe-to-vote mechanics
- **The Wall of Ego**: Top 100 ranking leaderboard
- **The Brag**: Personal stats with exportable status cards
- **ELO System**: Competitive ranking algorithm (K-factor 32)
- **100% Offline**: No external APIs, all data stored locally
- **Neon Cyberpunk Theme**: Glassmorphism effects and particle animations

## Tech Stack

- Flutter 3.x
- Riverpod for state management
- video_player for seamless video preloading
- just_audio for sound effects
- Local storage with shared_preferences

## Project Structure

```
lib/
├── config/          # Theme, constants, app configuration
├── models/          # Data models (Clip, Profile, Vote, ArenaState)
├── services/        # Business logic services
├── providers/       # Riverpod state management
├── widgets/         # Reusable UI components
├── screens/         # Main app screens
└── utils/           # Helper utilities
```

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Add video assets to `assets/videos/`:
   - Place 5 MP4 video files named `clip_1.mp4` through `clip_5.mp4`
   - Videos should be 12-20 seconds each

4. Add audio asset to `assets/sounds/`:
   - Place a sound effect file named `kill_sound.mp3`
   - Should be around 200ms duration

### Running the App

```bash
# Run on mobile
flutter run

# Run on web
flutter run -d chrome

# Build for web (PWA)
flutter build web --web-renderer canvaskit
```

## How to Play

1. **The Arena**: Watch two clips side by side, swipe UP on the better one
2. **ELO Calculation**: Points are awarded based on the difficulty of the matchup
3. **Rankings**: Check your position and compare with top players
4. **Export Stats**: Generate shareable status images with QR codes

## Architecture

### ELO System

Uses standard ELO formula with K-factor of 32:
```
expected_winner = 1 / (1 + 10^((loser_elo - winner_elo)/400))
delta = K * (1 - expected_winner)
```

### Video Preloading

Maintains 3 video controllers in memory:
- Current: Playing
- Next: Preloaded and ready
- Upcoming: Preloading in background

This ensures zero-lag transitions between duels.

### State Management

All state managed with Riverpod providers:
- `clipsProvider`: Clip data and updates
- `arenaStateProvider`: Current duel state
- `userProfileProvider`: User statistics
- `rankingProvider`: Top 100 calculated rankings
- `voteHistoryProvider`: Duel history

## Customization

### Theme Colors

Edit `lib/config/theme.dart`:
```dart
const Color neonCyan = Color(0xFF00FFD0);
const Color neonRed = Color(0xFFFF3B3B);
const Color bgDark = Color(0xFF050505);
```

### ELO Configuration

Edit `lib/config/constants.dart`:
```dart
const double kFactor = 32.0;
const int initialElo = 1200;
```

## Future Enhancements

- [ ] Supabase backend integration
- [ ] Real-time multiplayer duels
- [ ] Video upload functionality
- [ ] Social sharing
- [ ] Advanced analytics
- [ ] Tournament mode

## License

MIT License

## Credits

Built for competitive gaming communities who want to validate skill through direct clip comparison.
