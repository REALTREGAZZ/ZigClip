import '../config/supabase_client.dart';
import '../models/clip_model.dart';
import '../models/profile_model.dart';
import '../models/vote_model.dart';

class SupabaseService {
  final _client = SupabaseConfig.client;

  Future<List<Clip>> fetchClipsForArena({int limit = 50}) async {
    try {
      final response = await _client
          .from('clips')
          .select()
          .order('created_at', ascending: false)
          .limit(limit);

      return (response as List)
          .map((json) => Clip.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return _getMockClips();
    }
  }

  Future<void> submitVote(Vote vote) async {
    try {
      await _client.from('votes').insert(vote.toJson());
      
      await _client
          .from('clips')
          .update({'elo_score': 'elo_score + ${vote.eloDelta}'})
          .eq('id', vote.winnerId);
      
      await _client
          .from('clips')
          .update({'elo_score': 'elo_score - ${vote.eloDelta}'})
          .eq('id', vote.loserId);
    } catch (e) {
      print('Vote submission failed (stub mode): $e');
    }
  }

  Future<Profile> getUserProfile() async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('Not authenticated');

      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .single();

      return Profile.fromJson(response);
    } catch (e) {
      return _getMockProfile();
    }
  }

  Future<void> updateClipElo(String clipId, int newElo) async {
    try {
      await _client
          .from('clips')
          .update({'elo_score': newElo})
          .eq('id', clipId);
    } catch (e) {
      print('ELO update failed (stub mode): $e');
    }
  }

  List<Clip> _getMockClips() {
    return List.generate(
      10,
      (index) => Clip(
        id: 'clip_$index',
        userId: 'user_$index',
        videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        eloScore: 1000 + (index * 50),
        createdAt: DateTime.now().subtract(Duration(days: index)),
        isOriginal: true,
      ),
    );
  }

  Profile _getMockProfile() {
    return Profile(
      id: 'mock_user',
      username: 'Anonymous',
      eloScore: 1000,
      badge: 'Rookie',
    );
  }
}
