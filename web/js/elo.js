class ELOCalculator {
  static K_FACTOR = 32;

  static calculateDuel(winnerClip, loserClip) {
    const expectedWinner = 1 / (1 + Math.pow(10, (loserClip.elo - winnerClip.elo) / 400));
    const delta = Math.round(ELOCalculator.K_FACTOR * (1 - expectedWinner));
    
    return {
      winner_delta: delta,
      loser_delta: -delta,
      new_winner_elo: winnerClip.elo + delta,
      new_loser_elo: loserClip.elo - delta
    };
  }

  static getBadge(elo, totalPlayers = 100) {
    const percentile = (totalPlayers - this.getRank(elo, totalPlayers)) / totalPlayers * 100;
    
    if (percentile <= 1) return { name: 'APEX', color: '#FFD700' };
    if (percentile <= 3) return { name: 'ELITE', color: '#C0C0C0' };
    if (percentile <= 10) return { name: 'VETERAN', color: '#CD7F32' };
    return { name: 'NEWBIE', color: '#B0B0B0' };
  }

  static getRank(elo, totalPlayers = 100) {
    // Simple rank calculation based on ELO
    // In a real app, this would be based on actual sorted rankings
    const maxElo = 3000;
    const minElo = 1000;
    const normalized = (elo - minElo) / (maxElo - minElo);
    return Math.floor(totalPlayers * (1 - normalized)) + 1;
  }

  static getPercentile(rank, totalPlayers = 100) {
    return Math.round((totalPlayers - rank) / totalPlayers * 100);
  }
}