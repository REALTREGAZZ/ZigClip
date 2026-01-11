import '../models/clip.dart';
import '../utils/elo_calculator.dart';
import '../config/constants.dart';

class EloService {
  static EloResult calculateDuel(Clip winner, Clip loser) {
    return EloCalculator.calculateDuel(
      winnerElo: winner.eloScore,
      loserElo: loser.eloScore,
      kFactor: kFactor,
    );
  }

  static (Clip, Clip) applyDuelResult(Clip winner, Clip loser) {
    final result = calculateDuel(winner, loser);
    
    final updatedWinner = winner.copyWith(
      eloScore: result.newWinnerElo,
      wins: winner.wins + 1,
    );
    
    final updatedLoser = loser.copyWith(
      eloScore: result.newLoserElo,
      losses: loser.losses + 1,
    );
    
    return (updatedWinner, updatedLoser);
  }
}
