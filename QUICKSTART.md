# ZIGCLIP - Quick Start Guide

## ⚡ Get Running in 3 Steps

### 1. Install Dependencies (1 minute)

```bash
flutter pub get
```

### 2. Add Assets (REQUIRED - 5 minutes)

#### Videos (5 files required)
Place in `assets/videos/`:
- `clip_1.mp4`
- `clip_2.mp4`
- `clip_3.mp4`
- `clip_4.mp4`
- `clip_5.mp4`

💡 **Don't have gaming clips?** Use ANY short videos (10-20 seconds) for testing.
- Download from: pexels.com or pixabay.com
- Or use screen recordings from your phone
- Just rename them to match the names above

#### Audio (1 file required)
Place in `assets/sounds/`:
- `kill_sound.mp3`

💡 **Don't have a kill sound?** Use any short audio file:
- Download from: freesound.org or zapsplat.com
- Or record a quick sound on your phone
- Just rename it to `kill_sound.mp3`

### 3. Run (30 seconds)

```bash
flutter run
```

Choose your target:
- Android device/emulator
- iOS device/simulator  
- Chrome (web)

## 🎮 How to Use

### The Arena (Main Screen)
1. Watch both clips playing
2. Swipe UP on the better clip
3. See ELO points calculated
4. Next duel loads automatically

### The Wall of Ego (Rankings)
1. Tap Rankings tab at bottom
2. See Top 100 leaderboard
3. Your position shows at bottom
4. Pull down to refresh

### The Brag (Profile)
1. Tap Profile tab at bottom
2. View your stats
3. Tap "EXPORT STATUS" to create shareable card
4. Image copied to clipboard

## 🎨 What You'll See

- **Neon cyan theme** (#00FFD0)
- **Smooth animations** (flash, particles, ELO delta)
- **Video preloading** (zero lag between duels)
- **Glassmorphism effects** on cards
- **Monospace font** (Courier Prime)

## 🐛 Troubleshooting

### Videos not showing?
- Check files are in `assets/videos/`
- Verify names match exactly: `clip_1.mp4`, etc.
- Make sure they are MP4 format

### No sound?
- Check file is in `assets/sounds/`
- Verify name is exactly: `kill_sound.mp3`
- Check device volume is up

### App won't run?
```bash
flutter clean
flutter pub get
flutter run
```

### Want to build for production?
```bash
# Android
flutter build apk --release

# Web (PWA)
flutter build web --web-renderer canvaskit

# iOS (requires Mac)
flutter build ios --release
```

## 📱 Platforms Supported

- ✅ Android
- ✅ iOS  
- ✅ Web (PWA)
- ✅ Desktop (Windows/Mac/Linux)

## 🚀 Next Steps

1. Add your own gaming clips
2. Customize colors in `lib/config/theme.dart`
3. Share with friends
4. Deploy to web (GitHub Pages)
5. Publish to app stores

## 📚 More Info

- Full setup: See `SETUP.md`
- Architecture: See `TECHNICAL.md`
- Features: See `README.md`
- Status: See `CHECKLIST.md`

## 🎯 That's It!

You now have a fully functional competitive clip validation app with:
- ELO ranking system
- Smooth video playback
- Beautiful animations
- Offline functionality
- PWA support

**Enjoy! 🎮**
