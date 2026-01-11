import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_profile_provider.dart';
import '../utils/image_exporter.dart';
import '../utils/qr_generator.dart';
import '../widgets/glassmorphic_card.dart';
import '../config/theme.dart';
import '../config/constants.dart';

class TheBrag extends ConsumerStatefulWidget {
  const TheBrag({super.key});

  @override
  ConsumerState<TheBrag> createState() => _TheBragState();
}

class _TheBragState extends ConsumerState<TheBrag> {
  final GlobalKey _exportKey = GlobalKey();
  bool _isExporting = false;

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(userProfileProvider);

    return Scaffold(
      backgroundColor: bgDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'THE BRAG',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: neonCyan,
            letterSpacing: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildStatsCard(profile),
            const SizedBox(height: 32),
            _buildExportButton(),
            const SizedBox(height: 24),
            _buildExportPreview(profile),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(Profile profile) {
    return GlassmorphicCard(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              profile.username,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: neonCyan,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '${profile.totalElo}',
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: neonCyan,
              ),
            ),
            const Text(
              'ELO',
              style: TextStyle(
                fontSize: 24,
                color: textElite,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem(
                  'WIN RATE',
                  '${profile.winRate.toStringAsFixed(1)}%',
                ),
                _buildStatItem(
                  'DUELS',
                  '${profile.duelsCompleted}',
                ),
                _buildStatItem(
                  'RANK',
                  profile.rank > 0 ? '#${profile.rank}' : 'N/A',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildWLStat('${profile.wins} W', neonGreen),
                const SizedBox(width: 8),
                const Text('|', style: TextStyle(color: textElite)),
                const SizedBox(width: 8),
                _buildWLStat('${profile.losses} L', neonRed),
              ],
            ),
            if (profile.rankBadge.isNotEmpty) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: _getBadgeColor(profile.rankBadge).withValues(alpha: 0.2),
                  border: Border.all(
                    color: _getBadgeColor(profile.rankBadge),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  profile.rankBadge,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _getBadgeColor(profile.rankBadge),
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: neonCyan,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: textElite,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildWLStat(String text, Color color) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }

  Widget _buildExportButton() {
    return ElevatedButton(
      onPressed: _isExporting ? null : _exportStatus,
      style: ElevatedButton.styleFrom(
        backgroundColor: neonCyan,
        foregroundColor: bgDark,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: _isExporting
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: bgDark,
              ),
            )
          : const Text(
              'EXPORT STATUS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
    );
  }

  Widget _buildExportPreview(Profile profile) {
    return RepaintBoundary(
      key: _exportKey,
      child: Transform.scale(
        scale: 0.3,
        child: ImageExporter.buildStatusCard(
          username: profile.username,
          elo: profile.totalElo,
          rank: profile.rank > 0 ? profile.rank : 999,
          winRate: profile.winRate,
          wins: profile.wins,
          losses: profile.losses,
          badge: profile.rankBadge,
          phrase: _getPhrase(profile.rankBadge),
          qrCode: QRGenerator.generateQR(),
        ),
      ),
    );
  }

  Future<void> _exportStatus() async {
    setState(() => _isExporting = true);

    try {
      final image = await ImageExporter.captureWidget(_exportKey);
      
      if (image != null) {
        await Clipboard.setData(const ClipboardData(text: 'ZIGCLIP status exported!'));
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Status image copied to clipboard!'),
              backgroundColor: neonGreen,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        throw Exception('Failed to capture image');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to export status'),
            backgroundColor: neonRed,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  Color _getBadgeColor(String badge) {
    switch (badge) {
      case 'APEX':
        return goldBadge;
      case 'ELITE':
        return silverBadge;
      case 'VETERAN':
        return bronzeBadge;
      default:
        return textElite;
    }
  }

  String _getPhrase(String badge) {
    return rankPhrases[badge] ?? rankPhrases['DEFAULT']!;
  }
}
