import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/theme.dart';
import 'config/supabase_client.dart';
import 'screens/arena_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await SupabaseConfig.initialize();
    await SupabaseConfig.signInAnonymously();
  } catch (e) {
    debugPrint('Supabase initialization failed (running in stub mode): $e');
  }

  runApp(
    const ProviderScope(
      child: ZigClipApp(),
    ),
  );
}

class ZigClipApp extends StatelessWidget {
  const ZigClipApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZIGCLIP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/arena',
      routes: {
        '/arena': (context) => const ArenaScreen(),
        '/ranking': (context) => const PlaceholderScreen(title: 'RANKING'),
        '/dossier': (context) => const PlaceholderScreen(title: 'DOSSIER'),
      },
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'monospace',
            color: AppColors.neonCyan,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 64,
              color: AppColors.textElite,
            ),
            const SizedBox(height: 20),
            Text(
              '$title Coming Soon',
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ],
        ),
      ),
    );
  }
}
