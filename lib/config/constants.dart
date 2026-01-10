class AppConstants {
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
  
  static const int eloKFactor = 32;
  static const int videoPreloadCount = 2;
  
  static const String apiEndpointClips = '/rest/v1/clips';
  static const String apiEndpointVotes = '/rest/v1/votes';
  static const String apiEndpointProfiles = '/rest/v1/profiles';
  
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration eloDisplayDuration = Duration(milliseconds: 1500);
  
  static const double arenaCardWidth = 400.0;
  static const double arenaCardHeight = 600.0;
  
  static const double swipeThreshold = 100.0;
}
