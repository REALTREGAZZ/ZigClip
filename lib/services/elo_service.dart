import 'dart:math';
import '../config/constants.dart';

class EloService {
  static int calculateEloDelta(int winnerRating, int loserRating) {
    final expectedWinner = _calculateExpectedScore(winnerRating, loserRating);
    final delta = (AppConstants.eloKFactor * (1 - expectedWinner)).round();
    return delta;
  }

  static double _calculateExpectedScore(int ratingA, int ratingB) {
    return 1 / (1 + pow(10, (ratingB - ratingA) / 400));
  }

  static Map<String, int> calculateNewRatings(int winnerRating, int loserRating) {
    final delta = calculateEloDelta(winnerRating, loserRating);
    
    return {
      'winnerNew': winnerRating + delta,
      'loserNew': loserRating - delta,
      'delta': delta,
    };
  }

  static String formatEloDelta(int delta, bool isWinner) {
    final sign = isWinner ? '+' : '-';
    return '$sign${delta.abs()} ELO';
  }
}
