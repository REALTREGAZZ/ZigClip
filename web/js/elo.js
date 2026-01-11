class ELOCalculator {
  static K_FACTOR = 32;

  static calculateDuel(winnerClip, loserClip) {
    try {
      if (!winnerClip || !loserClip) {
        throw new Error('Clips inválidos');
      }

      const winnerElo = winnerClip.elo || 1600;
      const loserElo = loserClip.elo || 1600;

      const expectedWinner = 1 / (1 + Math.pow(10, (loserElo - winnerElo) / 400));
      const delta = Math.round(this.K_FACTOR * (1 - expectedWinner));

      return {
        winner_delta: delta,
        loser_delta: -delta,
        new_winner_elo: Math.max(0, winnerElo + delta),
        new_loser_elo: Math.max(0, loserElo - delta)
      };
    } catch (error) {
      console.error('❌ ELO calculation error:', error);
      return {
        winner_delta: 0,
        loser_delta: 0,
        new_winner_elo: winnerClip.elo,
        new_loser_elo: loserClip.elo
      };
    }
  }

  static getBadge(elo, totalPlayers = 100) {
    try {
      const percentile = (totalPlayers - this.getRank(elo, totalPlayers)) / totalPlayers * 100;
      
      if (percentile <= 1) return { name: 'APEX', color: '#FFD700' };
      if (percentile <= 3) return { name: 'ELITE', color: '#C0C0C0' };
      if (percentile <= 10) return { name: 'VETERAN', color: '#CD7F32' };
      return { name: 'NEWBIE', color: '#B0B0B0' };
    } catch (error) {
      console.error('Error getting badge:', error);
      return { name: 'NEWBIE', color: '#B0B0B0' };
    }
  }

  static getRank(elo, totalPlayers = 100) {
    try {
      // Simple rank calculation based on ELO
      // In a real app, this would be based on actual sorted rankings
      const maxElo = 3000;
      const minElo = 1000;
      const normalized = (elo - minElo) / (maxElo - minElo);
      return Math.floor(totalPlayers * (1 - normalized)) + 1;
    } catch (error) {
      console.error('Error calculating rank:', error);
      return Math.floor(totalPlayers / 2);
    }
  }

  static getPercentile(rank, totalPlayers = 100) {
    try {
      return Math.round((totalPlayers - rank) / totalPlayers * 100);
    } catch (error) {
      console.error('Error calculating percentile:', error);
      return 50;
    }
  }
}