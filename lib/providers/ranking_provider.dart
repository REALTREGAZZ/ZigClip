import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/clip.dart';
import '../config/app_config.dart';
import 'clips_provider.dart';

class RankedClip {
  final Clip clip;
  final int rank;
  final double percentile;

  const RankedClip({
    required this.clip,
    required this.rank,
    required this.percentile,
  });

  String get badge {
    if (percentile <= 1.0) return 'APEX';
    if (percentile <= 3.0) return 'ELITE';
    if (percentile <= 10.0) return 'VETERAN';
    return '';
  }

  @override
  String toString() {
    return 'RankedClip(rank: #$rank, ${clip.username}, elo: ${clip.eloScore})';
  }
}

final rankingProvider = Provider<List<RankedClip>>((ref) {
  final clips = ref.watch(clipsProvider);
  
  final sortedClips = [...clips];
  sortedClips.sort((a, b) => b.eloScore.compareTo(a.eloScore));

  final totalClips = max(sortedClips.length, AppConfig.rankingTopCount);
  
  final ranked = <RankedClip>[];
  for (var i = 0; i < sortedClips.length; i++) {
    final percentile = ((i + 1) / totalClips) * 100;
    ranked.add(RankedClip(
      clip: sortedClips[i],
      rank: i + 1,
      percentile: percentile,
    ));
  }

  if (ranked.length < AppConfig.rankingTopCount) {
    final dummyClips = _generateDummyClips(
      AppConfig.rankingTopCount - ranked.length,
      ranked.length + 1,
      ranked.isNotEmpty ? ranked.last.clip.eloScore : 1200,
    );
    
    for (var i = 0; i < dummyClips.length; i++) {
      final rank = ranked.length + i + 1;
      final percentile = (rank / AppConfig.rankingTopCount) * 100;
      ranked.add(RankedClip(
        clip: dummyClips[i],
        rank: rank,
        percentile: percentile,
      ));
    }
  }

  AppConfig.log('Generated ranking with ${ranked.length} entries');
  return ranked.take(AppConfig.rankingTopCount).toList();
});

List<Clip> _generateDummyClips(int count, int startRank, int baseElo) {
  final random = Random(42);
  final clips = <Clip>[];
  
  for (var i = 0; i < count; i++) {
    final rank = startRank + i;
    final elo = baseElo - (i * 20) - random.nextInt(15);
    final wins = random.nextInt(100) + 20;
    final losses = random.nextInt(80) + 10;
    
    clips.add(Clip(
      id: 'dummy_$rank',
      username: 'PLAYER_${rank.toString().padLeft(3, '0')}',
      eloScore: max(800, elo),
      videoPath: 'assets/videos/clip_1.mp4',
      wins: wins,
      losses: losses,
    ));
  }
  
  return clips;
}
