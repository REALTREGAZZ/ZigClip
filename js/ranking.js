class Ranking {
  constructor(storage, dataManager) {
    this.storage = storage;
    this.dataManager = dataManager;
    this.currentFilter = 'alltime';
  }

  init() {
    this.setupFilters();
    this.render();
    console.log('✅ Ranking initialized');
  }

  setupFilters() {
    const filtersHTML = `
      <div id="ranking-filters">
        <button class="filter-btn active" data-filter="alltime">ALL TIME</button>
        <button class="filter-btn" data-filter="month">MONTH</button>
        <button class="filter-btn" data-filter="week">WEEK</button>
      </div>
    `;
    
    const rankingEl = document.getElementById('ranking');
    const h2 = rankingEl.querySelector('h2');
    
    if (!document.getElementById('ranking-filters')) {
      h2.insertAdjacentHTML('afterend', filtersHTML);
      
      document.querySelectorAll('.filter-btn').forEach(btn => {
        btn.addEventListener('click', (e) => this.switchFilter(e.target.dataset.filter));
      });
    }
  }

  switchFilter(filter) {
    this.currentFilter = filter;
    
    document.querySelectorAll('.filter-btn').forEach(btn => {
      btn.classList.toggle('active', btn.dataset.filter === filter);
    });
    
    this.render();
  }

  render() {
    const tbody = document.getElementById('ranking-body');
    if (!tbody) return;

    const userData = this.storage.getUserData();
    const rankings = this.generateRankings(100);
    
    tbody.innerHTML = '';

    rankings.forEach((entry, index) => {
      const tr = document.createElement('tr');
      const isUser = entry.username === 'YOU';
      const isTop3 = index < 3;
      
      if (isUser) {
        tr.classList.add('rank-user');
      }
      
      const rankClass = isTop3 ? 'rank-top3' : '';
      const badge = this.getBadgeEmoji(entry.badge);
      const trendIcon = this.getTrendIcon(entry.trend);
      
      tr.innerHTML = `
        <td class="${rankClass}">#${index + 1}</td>
        <td>${entry.username}</td>
        <td class="${rankClass}">${entry.elo} ${trendIcon}</td>
        <td>${badge}</td>
      `;
      
      tbody.appendChild(tr);
    });
  }

  generateRankings(count) {
    const userData = this.storage.getUserData();
    const rankings = [];
    
    const clips = this.dataManager.getClipsByElo();
    
    for (let i = 1; i <= count; i++) {
      const baseElo = 2500 - (i * 15);
      const variance = Math.floor(Math.random() * 20) - 10;
      const elo = baseElo + variance;
      
      const trend = Math.random() > 0.5 ? 'up' : Math.random() > 0.5 ? 'down' : 'same';
      
      let badge = '';
      if (i === 1) badge = 'APEX';
      else if (i <= 3) badge = 'ELITE';
      else if (i <= 10) badge = 'VET';
      
      rankings.push({
        rank: i,
        username: `PLAYER_${i}`,
        elo,
        badge,
        trend
      });
    }

    const userRank = Math.floor(Math.random() * 30) + 5;
    rankings.splice(userRank - 1, 0, {
      rank: userRank,
      username: 'YOU',
      elo: userData.elo,
      badge: this.getUserBadge(userData.elo),
      trend: 'up'
    });

    return rankings;
  }

  getUserBadge(elo) {
    if (elo >= 2700) return 'APEX';
    if (elo >= 2500) return 'ELITE';
    if (elo >= 2300) return 'VET';
    return '';
  }

  getBadgeEmoji(badge) {
    const badges = {
      'APEX': '👑',
      'ELITE': '⭐',
      'VET': '🔥',
      '': ''
    };
    return badges[badge] || '';
  }

  getTrendIcon(trend) {
    const icons = {
      'up': '<span style="color: #00FF00;">▲</span>',
      'down': '<span style="color: #FF3B3B;">▼</span>',
      'same': '<span style="color: #B0B0B0;">━</span>'
    };
    return icons[trend] || '';
  }

  update() {
    this.render();
  }
}

export default Ranking;
