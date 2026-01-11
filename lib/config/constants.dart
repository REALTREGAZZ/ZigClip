// ELO System
const double kFactor = 32.0;
const int initialElo = 1200;

// Video paths
const List<String> initialVideoPaths = [
  'assets/videos/clip_1.mp4',
  'assets/videos/clip_2.mp4',
  'assets/videos/clip_3.mp4',
  'assets/videos/clip_4.mp4',
  'assets/videos/clip_5.mp4',
];

// Audio
const String killSoundPath = 'assets/sounds/kill_sound.mp3';

// Animation durations
const int flashDurationMs = 300;
const int transitionDurationMs = 300;
const int particleDurationMs = 600;

// Rank thresholds
const double apexPercentile = 0.01; // Top 1%
const double elitePercentile = 0.03; // Top 3%
const double veteranPercentile = 0.10; // Top 10%

// Local storage keys
const String clipsStorageKey = 'clips_data';
const String votesStorageKey = 'votes_data';
const String profileStorageKey = 'user_profile';

// QR Code
const String qrProveUrl = 'https://prove-me-wrong.local';

// Phrases
const Map<String, String> rankPhrases = {
  'APEX': 'TOP 1% - CAN\'T BE STOPPED',
  'ELITE': 'TOP 3% - ELITE PERFORMER',
  'VETERAN': 'TOP 10% - VETERAN GAMER',
  'DEFAULT': 'RISING THROUGH THE RANKS',
};
