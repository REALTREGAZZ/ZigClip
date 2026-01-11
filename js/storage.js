class Storage {
  constructor() {
    this.KEY = 'zigclip_data';
    this.init();
  }

  init() {
    if (!this.get()) {
      this.set({
        userElo: 2450,
        userVotes: [],
        eloHistory: [],
        settings: {
          soundOn: true,
          vibrateOn: true
        },
        stats: {
          wins: 156,
          losses: 77,
          duels: 0
        }
      });
    }
  }

  get() {
    try {
      const data = localStorage.getItem(this.KEY);
      return data ? JSON.parse(data) : null;
    } catch (e) {
      console.error('Storage get error:', e);
      return null;
    }
  }

  set(data) {
    try {
      localStorage.setItem(this.KEY, JSON.stringify(data));
      return true;
    } catch (e) {
      console.error('Storage set error:', e);
      return false;
    }
  }

  update(updates) {
    const current = this.get();
    if (current) {
      this.set({ ...current, ...updates });
    }
  }

  getUserData() {
    const data = this.get();
    return data ? {
      elo: data.userElo,
      wins: data.stats.wins,
      losses: data.stats.losses,
      duels: data.stats.duels
    } : null;
  }

  updateUserElo(delta) {
    const data = this.get();
    if (data) {
      data.userElo += delta;
      data.eloHistory.push({
        elo: data.userElo,
        delta,
        timestamp: Date.now()
      });
      this.set(data);
    }
  }

  recordVote(clipA, clipB, winner) {
    const data = this.get();
    if (data) {
      data.userVotes.push({
        clipA,
        clipB,
        winner,
        timestamp: Date.now()
      });
      data.stats.duels++;
      this.set(data);
    }
  }

  updateStats(wins, losses) {
    const data = this.get();
    if (data) {
      data.stats.wins = wins;
      data.stats.losses = losses;
      this.set(data);
    }
  }

  clear() {
    localStorage.removeItem(this.KEY);
    this.init();
  }
}

export default Storage;
