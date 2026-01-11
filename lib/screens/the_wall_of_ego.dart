import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ranking_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/rank_badge.dart';
import '../widgets/glassmorphic_card.dart';
import '../config/theme.dart';

class TheWallOfEgo extends ConsumerWidget {
  const TheWallOfEgo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ranking = ref.watch(rankingProvider);
    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'THE WALL OF EGO',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: neonCyan,
            letterSpacing: 2,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          ref.invalidate(rankingProvider);
        },
        color: neonCyan,
        backgroundColor: bgDark,
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ranking.length,
          itemBuilder: (context, index) {
            final rankedClip = ranking[index];
            final isTop3 = rankedClip.rank <= 3;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: isTop3
                  ? GlassmorphicCard(
                      borderColor: _getBorderColor(rankedClip.rank),
                      borderWidth: 2,
                      child: _buildRankingRow(rankedClip),
                    )
                  : _buildRankingRow(rankedClip),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildUserPosition(userProfile),
    );
  }

  Widget _buildRankingRow(RankedClip rankedClip) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: rankedClip.rank <= 3 
            ? Colors.transparent 
            : glassWhite.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 50,
            child: Text(
              '#${rankedClip.rank}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getRankColor(rankedClip.rank),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              rankedClip.clip.username,
              style: const TextStyle(
                fontSize: 16,
                color: textElite,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${rankedClip.clip.eloScore}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: neonCyan,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${(rankedClip.clip.winRate * 100).toStringAsFixed(0)}%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: textElite,
              ),
            ),
          ),
          SizedBox(
            width: 80,
            child: RankBadge(
              badge: rankedClip.badge,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserPosition(Profile profile) {
    final percentile = profile.rank > 0 
        ? (profile.rank / 100.0 * 100).toStringAsFixed(1) 
        : 'N/A';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgDark,
        border: Border(
          top: BorderSide(
            color: neonCyan.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.person,
              color: neonCyan,
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              'YOUR POSITION: ',
              style: const TextStyle(
                fontSize: 16,
                color: textElite,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              profile.rank > 0 ? '#${profile.rank}' : 'UNRANKED',
              style: const TextStyle(
                fontSize: 18,
                color: neonCyan,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'TOP $percentile%',
              style: TextStyle(
                fontSize: 16,
                color: profile.rank <= 10 ? neonGreen : textElite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank == 1) return goldBadge;
    if (rank == 2) return silverBadge;
    if (rank == 3) return bronzeBadge;
    if (rank <= 10) return neonCyan;
    return textElite;
  }

  Color _getBorderColor(int rank) {
    if (rank == 1) return goldBadge;
    if (rank == 2) return silverBadge;
    if (rank == 3) return bronzeBadge;
    return neonCyan;
  }
}
