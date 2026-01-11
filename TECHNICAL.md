# ZIGCLIP - Technical Documentation

## Architecture Overview

ZIGCLIP follows Clean Architecture principles with clear separation of concerns:

```
Presentation Layer (Screens/Widgets)
         ↓
State Management Layer (Riverpod Providers)
         ↓
Business Logic Layer (Services)
         ↓
Data Layer (Models + Local Storage)
```

## State Management - Riverpod

### Provider Types

1. **StateNotifierProvider**: Mutable state that can be updated
   - `ClipsNotifier`: Manages clip data and updates
   - `ProfileNotifier`: User profile and statistics
   - `ArenaStateNotifier`: Current duel state
   - `VoteHistoryNotifier`: Historical votes

2. **Provider**: Computed/derived state
   - `rankingProvider`: Calculates top 100 from clips

### Data Flow

```
User Action (Swipe) 
  → ArenaStateNotifier.recordWinner()
    → EloService.calculateDuel()
    → ClipsNotifier.updateMultipleClips()
    → LocalStorageService.saveVote()
    → UI updates automatically (Riverpod watch)
```

## Video Preloading Strategy

### Three-Controller System

```
┌─────────────┐
│  Current    │ ← Playing NOW
│ (visible)   │
└─────────────┘
       ↓
┌─────────────┐
│    Next     │ ← Initialized, ready to play
│ (preloaded) │
└─────────────┘
       ↓
┌─────────────┐
│  Upcoming   │ ← Initializing in background
│(background) │
└─────────────┘
```

### Transition Flow

1. User selects winner
2. Wait for animations (1500ms)
3. Swap controllers:
   - current = next
   - next = upcoming
   - upcoming = new VideoPlayerController
4. Start playing current
5. Initialize upcoming in background

### Benefits
- Zero-frame black screen
- Instant playback
- Smooth user experience
- Efficient memory usage

## ELO Rating System

### Formula

```dart
// Expected score for player A vs player B
expected_A = 1 / (1 + 10^((rating_B - rating_A) / 400))

// Rating change for player A
delta_A = K * (actual_score - expected_A)

// Where:
// K = 32 (volatility factor)
// actual_score = 1 for win, 0 for loss
```

### Example Calculation

```
Clip A: 1600 ELO
Clip B: 1200 ELO

A beats B (expected):
  expected_A = 1 / (1 + 10^(-400/400)) = 0.76
  delta_A = 32 * (1 - 0.76) = +8 ELO
  delta_B = 32 * (0 - 0.24) = -8 ELO

B beats A (upset):
  expected_B = 1 / (1 + 10^(400/400)) = 0.24
  delta_B = 32 * (1 - 0.24) = +24 ELO
  delta_A = 32 * (0 - 0.76) = -24 ELO
```

### Properties
- Self-correcting: Ratings converge to true skill level
- Upset rewards: Beating higher-rated opponents = more points
- Conservative with favorites: Less gain for expected wins
- Zero-sum: Points gained = points lost

## Local Storage Schema

### Clips Storage
```json
{
  "clips": [
    {
      "id": "clip_1",
      "username": "PLAYER_NAME",
      "elo_score": 1200,
      "video_path": "assets/videos/clip_1.mp4",
      "wins": 0,
      "losses": 0
    }
  ]
}
```

### Votes Storage
```json
{
  "votes": [
    {
      "clip1_id": "clip_1",
      "clip2_id": "clip_2",
      "winner_id": "clip_1",
      "elo_delta": 18,
      "timestamp": "2024-01-11T10:30:00Z"
    }
  ]
}
```

### Profile Storage
```json
{
  "user_profile": {
    "username": "YOU",
    "total_elo": 1200,
    "wins": 0,
    "losses": 0,
    "rank": 0,
    "duels_completed": 0
  }
}
```

## Animation System

### Neon Flash Effect
- Trigger: On winner selection
- Duration: 300ms
- Effect: Cyan overlay fade in/out
- Implementation: AnimatedContainer with color overlay

### ELO Delta Display
- Trigger: After winner selection
- Duration: 1200ms (200ms fade-in, 800ms hold, 300ms fade-out)
- Effect: "+X ELO" text with glow
- Color: Green (win) / Red (loss)
- Implementation: flutter_animate package

### Particle Effect
- Trigger: On winner selection
- Duration: 600ms
- Effect: 8 particles radiate from center
- Implementation: CustomPainter with AnimatedBuilder

### Loser Fade Out
- Trigger: On winner selection
- Duration: 300ms
- Effect: Opacity 1.0 → 0.3
- Implementation: AnimatedOpacity in VideoPlayerWidget

## Performance Optimizations

### Video Loading
- Asset-based videos (bundled with app)
- Controllers kept in memory (no dispose/reinit)
- Looping enabled to prevent black frames
- Background preloading for smooth experience

### State Updates
- Riverpod selective rebuilds (only affected widgets)
- Immutable state with copyWith pattern
- Minimal Widget tree depth
- const constructors where possible

### Memory Management
- Only 3 video controllers at a time
- Dispose old controllers after transition
- Lazy loading of ranking data
- Efficient JSON parsing

## Theme System

### Color Palette
```dart
Neon Cyan:   #00FFD0  (Primary, text, borders)
Neon Red:    #FF3B3B  (Errors, losses)
Neon Green:  #39FF14  (Wins, success)
Dark BG:     #050505  (Background)
Text Elite:  #B0B0B0  (Secondary text)
Gold Badge:  #FFD700  (Rank 1)
Silver:      #C0C0C0  (Rank 2-3)
Bronze:      #CD7F32  (Rank 4-10)
```

### Typography
- Font: Courier Prime (monospace)
- Letter spacing: Wide (cyberpunk aesthetic)
- Weights: Bold for emphasis, Regular for body

### Effects
- Glassmorphism: Blur + semi-transparent backgrounds
- Glow: Text shadows with color
- Borders: Neon colored with low opacity
- Animations: Fast (200-300ms) for snappy feel

## Error Handling

### Video Failures
- Graceful degradation: Show loading spinner
- Retry logic in preloading service
- Fallback to next clip if initialization fails

### Storage Failures
- Return default values (empty arrays, initial profile)
- No data loss on read failures
- Atomic writes to prevent corruption

### State Inconsistencies
- Null safety throughout codebase
- State validation before operations
- Reset mechanisms for recovery

## Testing Strategy

### Unit Tests
- `elo_calculator_test.dart`: ELO formula accuracy
- `clip_model_test.dart`: Model serialization
- `local_storage_service_test.dart`: Storage operations

### Widget Tests
- `video_player_widget_test.dart`: Video display
- `arena_video_pair_test.dart`: Gesture detection
- `rank_badge_test.dart`: Badge rendering

### Integration Tests
- `arena_flow_test.dart`: Complete duel workflow
- `ranking_calculation_test.dart`: Ranking updates
- `export_flow_test.dart`: Status image export

## Future Enhancements

### Backend Migration Path
1. Create API service mirroring LocalStorageService
2. Update providers to use new service
3. Add authentication provider
4. Implement video upload/streaming
5. Add real-time sync

### Multiplayer Mode
- WebSocket connections for live duels
- Matchmaking based on ELO
- Real-time opponent selection
- Synchronized video playback

### Advanced Features
- Video trimming/editing
- Multiple game support
- Tournament brackets
- Clan/team rankings
- Achievement system
- Social sharing integration

## Build Configuration

### Web
```bash
flutter build web \
  --web-renderer canvaskit \
  --release \
  --pwa-strategy offline-first
```

### Android
```bash
flutter build apk \
  --release \
  --shrink \
  --obfuscate \
  --split-per-abi
```

### iOS
```bash
flutter build ios \
  --release \
  --no-codesign
```

## Dependencies

### Core
- `flutter_riverpod`: State management
- `video_player`: Video playback
- `shared_preferences`: Local storage

### UI
- `google_fonts`: Typography
- `flutter_animate`: Animations
- `qr_flutter`: QR code generation

### Media
- `just_audio`: Sound effects
- `screenshot`: Image export

### Utilities
- `path_provider`: File system access

## Performance Benchmarks

### Target Metrics
- Video transition: < 50ms
- ELO calculation: < 1ms
- Storage write: < 10ms
- UI render: 60 FPS
- App startup: < 2s

### Optimization Techniques
- Asset preloading
- Const constructors
- Efficient rebuilds
- Lazy loading
- Memory pooling

## Security Considerations

### Current (MVP)
- Local-only data (no network exposure)
- No authentication required
- No sensitive data stored

### Future (Backend)
- JWT authentication
- HTTPS only
- Rate limiting
- Input validation
- CORS configuration
- Video content moderation

## Deployment

### Web Hosting (GitHub Pages)
1. Build: `flutter build web --web-renderer canvaskit`
2. Deploy: Copy `build/web/` to GitHub Pages
3. Configure: Set base href in index.html
4. PWA: Service worker auto-configured

### Mobile Stores
1. Generate signing keys
2. Update version in pubspec.yaml
3. Build release binaries
4. Upload to Play Store / App Store
5. Submit for review

## Monitoring

### Recommended Tools
- Firebase Analytics (user behavior)
- Sentry (error tracking)
- Google Lighthouse (web performance)
- Flutter DevTools (debugging)

## Contributing

### Code Style
- Follow Dart style guide
- Use provided linter rules
- Write descriptive commit messages
- Add comments for complex logic

### PR Process
1. Create feature branch
2. Implement changes
3. Run tests: `flutter test`
4. Check analysis: `flutter analyze`
5. Submit PR with description

## License

MIT License - See LICENSE file for details.
