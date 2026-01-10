import 'package:flutter/material.dart';

class ArenaScreen extends StatelessWidget {
  const ArenaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'ZIGCLIP',
              style: TextStyle(
                color: Color(0xFF00FFD0),
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'THE ARENA - Coming Soon',
              style: TextStyle(
                color: Color(0xFFB0B0B0),
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 300,
              height: 400,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00FFD0), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Video Placeholder',
                  style: TextStyle(color: Color(0xFFB0B0B0)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
