import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;

class ImageExporter {
  static Future<Uint8List?> captureWidget(
    GlobalKey key, {
    double pixelRatio = 3.0,
  }) async {
    try {
      final RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      
      final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      
      return byteData?.buffer.asUint8List();
    } catch (e) {
      debugPrint('Error capturing widget: $e');
      return null;
    }
  }

  static Widget buildStatusCard({
    required String username,
    required int elo,
    required int rank,
    required double winRate,
    required int wins,
    required int losses,
    required String badge,
    required String phrase,
    required Widget qrCode,
  }) {
    return Container(
      width: 1080,
      height: 1920,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF00FFD0).withValues(alpha: 0.3),
            const Color(0xFF050505),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Text(
              'ZIGCLIP',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF00FFD0),
                letterSpacing: 8,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  badge,
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  phrase,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFB0B0B0),
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 80),
                Text(
                  'RANK #$rank',
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00FFD0),
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$elo ELO',
                  style: const TextStyle(
                    fontSize: 96,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00FFD0),
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  'WIN RATE: ${winRate.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 36,
                    color: Color(0xFFB0B0B0),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$wins W | $losses L',
                  style: const TextStyle(
                    fontSize: 28,
                    color: Color(0xFFB0B0B0),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 120,
            right: 80,
            child: Column(
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: qrCode,
                ),
                const SizedBox(height: 20),
                const Text(
                  'PROVE ME WRONG',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00FFD0),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
