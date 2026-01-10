import 'package:flutter/material.dart';

import 'screens/arena_screen.dart';

void main() {
  runApp(const ZigClipApp());
}

class ZigClipApp extends StatelessWidget {
  const ZigClipApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZIGCLIP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050505),
        primaryColor: const Color(0xFF00FFD0),
      ),
      home: const ArenaScreen(),
    );
  }
}
