class RankingService {
  static generateTop100() {
    const clips = StorageService.loadClips();
    const userProfile = StorageService.loadProfile();
    
    // Create a combined array of clips and user
    const allPlayers = [...clips, userProfile];
    
    // Sort by ELO (descending)
    allPlayers.sort((a, b) => b.elo - a.elo);
    
    // Generate top 100 (pad with fake data if needed)
    const top100 = allPlayers.slice(0, 100);
    
    // Add fake players if we don't have enough
    while (top100.length < 100) {
      const fakePlayer = {
        id: top100.length + 1,
        username: `PLAYER_${top100.length + 1}`,
        elo: 1000 + Math.floor(Math.random() * 1000),
        wins: Math.floor(Math.random() * 50),
        losses: Math.floor(Math.random() * 50)
      };
      top100.push(fakePlayer);
    }
    
    // Sort again after adding fake players
    top100.sort((a, b) => b.elo - a.elo);
    
    return top100;
  }

  static updateRankingDisplay() {
    const rankingBody = document.getElementById('ranking-body');
    const top100 = RankingService.generateTop100();
    const userProfile = StorageService.loadProfile();
    
    rankingBody.innerHTML = '';
    
    top100.forEach((player, index) => {
      const row = document.createElement('tr');
      
      // Rank
      const rankCell = document.createElement('td');
      rankCell.textContent = index + 1;
      
      // Username
      const usernameCell = document.createElement('td');
      usernameCell.textContent = player.username;
      
      // ELO
      const eloCell = document.createElement('td');
      eloCell.textContent = player.elo;
      
      // Win Rate
      const totalGames = player.wins + player.losses;
      const winRate = totalGames > 0 ? Math.round((player.wins / totalGames) * 100) : 0;
      const winRateCell = document.createElement('td');
      winRateCell.textContent = `${winRate}%`;
      
      // Badge
      const badge = ELOCalculator.getBadge(player.elo, 100);
      const badgeCell = document.createElement('td');
      const badgeSpan = document.createElement('span');
      badgeSpan.textContent = badge.name;
      badgeSpan.style.color = badge.color;
      badgeSpan.style.fontWeight = 'bold';
      badgeCell.appendChild(badgeSpan);
      
      // Apply glow to top 3
      if (index < 3) {
        row.style.background = 'rgba(0, 255, 208, 0.1)';
        row.style.boxShadow = '0 0 10px #00FFD0';
      }
      
      row.appendChild(rankCell);
      row.appendChild(usernameCell);
      row.appendChild(eloCell);
      row.appendChild(winRateCell);
      row.appendChild(badgeCell);
      
      rankingBody.appendChild(row);
    });
    
    // Update user position
    RankingService.updateUserPosition();
  }

  static updateUserPosition() {
    const userProfile = StorageService.loadProfile();
    const top100 = RankingService.generateTop100();
    
    // Find user rank
    const userRank = top100.findIndex(p => p.username === userProfile.username) + 1;
    const percentile = ELOCalculator.getPercentile(userRank, 100);
    
    const yourPosition = document.getElementById('your-position');
    const yourPercentile = document.getElementById('your-percentile');
    const yourTrend = document.getElementById('your-trend');
    
    yourPosition.textContent = `TU POSICIÓN: #${userRank}`;
    yourPercentile.textContent = `TOP ${percentile}%`;
    
    // Simple trend indicator (no history tracking in this simple version)
    yourTrend.textContent = '→';
    yourTrend.style.color = '#B0B0B0';
  }

  static setupFilterTabs() {
    const tabs = document.querySelectorAll('.tab');
    tabs.forEach(tab => {
      tab.addEventListener('click', () => {
        tabs.forEach(t => t.classList.remove('active'));
        tab.classList.add('active');
        RankingService.updateRankingDisplay();
      });
    });
  }
}