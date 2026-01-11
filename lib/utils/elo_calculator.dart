import 'dart:math';
import '../config/constants.dart';

class EloResult {
  final int winnerDelta;
  final int loserDelta;
  final int newWinnerElo;
  final int newLoserElo;

  const EloResult({
    required this.winnerDelta,
    required this.loserDelta,
    required this.newWinnerElo,
    required this.newLoserElo,
  });

  @override
  String toString() {
    return 'EloResult(winner: +$winnerDelta → $newWinnerElo, loser: $loserDelta → $newLoserElo)';
  }
}

class EloCalculator {
  static double calculateExpectedScore(int ratingA, int ratingB) {
    return 1.0 / (1.0 + pow(10, (ratingB - ratingA) / 400.0));
  }

  static EloResult calculateDuel({
    required int winnerElo,
    required int loserElo,
    double kFactor = kFactor,
  }) {
    final expectedWinner = calculateExpectedScore(winnerElo, loserElo);
    final expectedLoser = calculateExpectedScore(loserElo, winnerElo);

    final winnerDelta = (kFactor * (1.0 - expectedWinner)).round();
    final loserDelta = (kFactor * (0.0 - expectedLoser)).round();

    return EloResult(
      winnerDelta: winnerDelta,
      loserDelta: loserDelta,
      newWinnerElo: winnerElo + winnerDelta,
      newLoserElo: loserElo + loserDelta,
    );
  }
}
