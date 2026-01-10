import 'package:flutter_riverpod/flutter_riverpod.dart';

class EloFeedback {
  final int delta;
  final bool isWinner;
  final DateTime timestamp;

  EloFeedback({
    required this.delta,
    required this.isWinner,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  String get formattedDelta {
    final sign = isWinner ? '+' : '-';
    return '$sign${delta.abs()} ELO';
  }
}

class EloState {
  final EloFeedback? lastEloGain;
  final bool isAnimating;

  EloState({
    this.lastEloGain,
    this.isAnimating = false,
  });

  EloState copyWith({
    EloFeedback? lastEloGain,
    bool? isAnimating,
  }) {
    return EloState(
      lastEloGain: lastEloGain ?? this.lastEloGain,
      isAnimating: isAnimating ?? this.isAnimating,
    );
  }
}

class EloNotifier extends StateNotifier<EloState> {
  EloNotifier() : super(EloState());

  void showEloChange(int delta, bool isWinner) {
    state = EloState(
      lastEloGain: EloFeedback(
        delta: delta,
        isWinner: isWinner,
      ),
      isAnimating: true,
    );

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        state = state.copyWith(isAnimating: false);
      }
    });
  }

  void clearEloChange() {
    state = EloState();
  }
}

final eloProvider = StateNotifierProvider<EloNotifier, EloState>((ref) {
  return EloNotifier();
});
