class EloSystem {
  constructor(K = 32) {
    this.K = K;
  }

  calculate(winnerElo, loserElo) {
    const expectedScore = 1 / (1 + Math.pow(10, (loserElo - winnerElo) / 400));
    const delta = Math.round(this.K * (1 - expectedScore));
    return delta;
  }

  processMatch(winner, loser) {
    const delta = this.calculate(winner.elo, loser.elo);
    return {
      delta,
      winnerNewElo: winner.elo + delta,
      loserNewElo: loser.elo - delta
    };
  }

  getTier(elo) {
    if (elo >= 2700) return { name: 'RADIANT', color: '#FF0000' };
    if (elo >= 2500) return { name: 'IMMORTAL', color: '#FF6B9D' };
    if (elo >= 2400) return { name: 'ELITE', color: '#00FFD0' };
    if (elo >= 2200) return { name: 'DIAMOND', color: '#9D4EDD' };
    if (elo >= 2000) return { name: 'PLATINUM', color: '#34D399' };
    if (elo >= 1800) return { name: 'GOLD', color: '#FFD700' };
    return { name: 'SILVER', color: '#C0C0C0' };
  }

  getBadge(elo) {
    if (elo >= 2700) return 'gold';
    if (elo >= 2500) return 'silver';
    if (elo >= 2400) return 'bronze';
    return '';
  }
}

export default EloSystem;
