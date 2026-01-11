// ========================================
// ZIGCLIP - VANILLA JAVASCRIPT PWA
// ========================================

class ZigClip {
  constructor() {
    this.clips = [
      { id: 1, name: 'APEX_PRED_1', elo: 2450, wins: 45, losses: 12, video: 'assets/videos/clip_1.mp4' },
      { id: 2, name: 'ELITE_PLAYER_2', elo: 2100, wins: 38, losses: 18, video: 'assets/videos/clip_2.mp4' },
      { id: 3, name: 'VETERAN_3', elo: 1850, wins: 32, losses: 25, video: 'assets/videos/clip_3.mp4' },
      { id: 4, name: 'RISING_STAR_4', elo: 1600, wins: 28, losses: 35, video: 'assets/videos/clip_4.mp4' },
      { id: 5, name: 'NEWBIE_5', elo: 1400, wins: 15, losses: 42, video: 'assets/videos/clip_5.mp4' }
    ];

    this.user = {
      elo: 1800,
      wins: 0,
      losses: 0,
      duels: 0
    };

    this.currentDuel = 0;
    this.isProcessing = false;
    this.touchStartY = 0;

    this.loadFromStorage();
    this.init();
  }

  init() {
    console.log('🚀 ZIGCLIP Initialized');

    // Start button
    document.getElementById('start-btn').addEventListener('click', () => this.startArena());

    // Navigation
    document.querySelectorAll('.nav-btn').forEach(btn => {
      btn.addEventListener('click', (e) => this.switchScreen(e.target.dataset.screen));
    });

    // Arena videos
    const videoLeft = document.getElementById('video-left');
    const videoRight = document.getElementById('video-right');

    [videoLeft, videoRight].forEach((video, idx) => {
      video.addEventListener('touchstart', (e) => this.onTouchStart(e));
      video.addEventListener('touchend', (e) => this.onTouchEnd(e, idx));
      video.addEventListener('mousedown', (e) => this.onMouseDown(e));
      video.addEventListener('mouseup', (e) => this.onMouseUp(e, idx));
    });

    // Export button
    document.getElementById('export-btn')?.addEventListener('click', () => this.exportStatus());

    // Setup initial videos
    this.loadVideos();

    // Update ranking
    this.updateRanking();
    this.updateBrag();
  }

  startArena() {
    this.switchScreen('arena');
    this.playVideos();
  }

  switchScreen(screenName) {
    document.querySelectorAll('.screen').forEach(s => {
      s.classList.remove('active');
      s.classList.add('hidden');
    });

    const screen = document.getElementById(screenName);
    if (screen) {
      screen.classList.remove('hidden');
      screen.classList.add('active');
    }

    // Update nav
    document.querySelectorAll('.nav-btn').forEach(btn => {
      btn.classList.toggle('active', btn.dataset.screen === screenName);
    });
  }

  loadVideos() {
    const left = this.clips[this.currentDuel % this.clips.length];
    const right = this.clips[(this.currentDuel + 1) % this.clips.length];

    const videoLeft = document.getElementById('video-left');
    const videoRight = document.getElementById('video-right');

    videoLeft.src = left.video;
    videoRight.src = right.video;
  }

  async playVideos() {
    try {
      const videoLeft = document.getElementById('video-left');
      await videoLeft.play();
    } catch (e) {
      console.error('❌ Play error:', e);
    }
  }

  onTouchStart(e) {
    this.touchStartY = e.touches?.[0]?.clientY || 0;
  }

  onTouchEnd(e, videoIdx) {
    if (this.isProcessing) return;

    const touchEndY = e.changedTouches?.[0]?.clientY || 0;
    const deltaY = this.touchStartY - touchEndY;

    if (Math.abs(deltaY) > 50) {
      this.handleWin(videoIdx);
    }
  }

  onMouseDown(e) {
    this.touchStartY = e.clientY;
  }

  onMouseUp(e, videoIdx) {
    if (this.isProcessing) return;

    const touchEndY = e.clientY;
    const deltaY = this.touchStartY - touchEndY;

    if (Math.abs(deltaY) > 50) {
      this.handleWin(videoIdx);
    }
  }

  async handleWin(winnerId) {
    this.isProcessing = true;

    const left = this.clips[this.currentDuel % this.clips.length];
    const right = this.clips[(this.currentDuel + 1) % this.clips.length];

    const winner = winnerId === 0 ? left : right;
    const loser = winnerId === 0 ? right : left;

    // ELO Calculation
    const eloResult = this.calculateElo(winner.elo, loser.elo);

    // Update clips
    winner.elo += eloResult;
    loser.elo -= eloResult;

    // Update user if playing
    this.user.duels++;
    this.user.wins++;
    this.user.elo = Math.max(100, this.user.elo + eloResult);

    // Animations
    this.showFlash();
    this.showEloDelta(eloResult);

    // Save
    this.saveToStorage();

    // Next duel
    await new Promise(r => setTimeout(r, 600));
    this.currentDuel++;
    this.loadVideos();
    await this.playVideos();

    this.updateRanking();
    this.updateBrag();

    this.isProcessing = false;
  }

  calculateElo(winnerElo, loserElo) {
    const expected = 1 / (1 + Math.pow(10, (loserElo - winnerElo) / 400));
    return Math.round(32 * (1 - expected));
  }

  showFlash() {
    const flash = document.getElementById('flash');
    flash.style.opacity = '0.8';
    setTimeout(() => {
      flash.style.opacity = '0';
    }, 200);
  }

  showEloDelta(delta) {
    const el = document.getElementById('elo-delta');
    el.textContent = `+${delta} ELO`;
    el.style.color = '#00FF00';
    el.classList.remove('hidden');

    setTimeout(() => {
      el.classList.add('hidden');
    }, 1000);
  }

  updateRanking() {
    const tbody = document.getElementById('ranking-body');
    tbody.innerHTML = '';

    // Generate 100 fake rankings
    const ranking = [];
    for (let i = 1; i <= 100; i++) {
      const elo = 2500 - i * 15 + Math.random() * 100;
      ranking.push({
        rank: i,
        name: `PLAYER_${i}`,
        elo: Math.floor(elo),
        badge: i <= 1 ? 'APEX' : i <= 3 ? 'ELITE' : i <= 10 ? 'VET' : ''
      });
    }

    ranking.forEach(r => {
      const tr = document.createElement('tr');
      tr.innerHTML = `
        <td>#${r.rank}</td>
        <td>${r.name}</td>
        <td>${r.elo}</td>
        <td>${r.badge}</td>
      `;
      tbody.appendChild(tr);
    });

    // Your position
    const yourRank = Math.floor(Math.random() * 100) + 1;
    document.getElementById('your-rank').textContent = `TU POSICIÓN: #${yourRank} (TOP ${Math.floor(100 / yourRank)}%)`;
  }

  updateBrag() {
    document.getElementById('brag-elo').textContent = this.user.elo;
    document.getElementById('brag-wins').textContent = this.user.wins;
    document.getElementById('brag-losses').textContent = this.user.losses;

    const total = this.user.wins + this.user.losses;
    const rate = total > 0 ? Math.floor((this.user.wins / total) * 100) : 0;
    document.getElementById('brag-rate').textContent = `${rate}%`;
  }

  exportStatus() {
    const canvas = document.getElementById('export-canvas');
    canvas.width = 1080;
    canvas.height = 1920;
    const ctx = canvas.getContext('2d');

    // Background
    const gradient = ctx.createLinearGradient(0, 0, 0, 1920);
    gradient.addColorStop(0, '#00FFD0');
    gradient.addColorStop(1, '#050505');
    ctx.fillStyle = gradient;
    ctx.fillRect(0, 0, 1080, 1920);

    // Text
    ctx.font = 'bold 80px Courier New';
    ctx.fillStyle = '#FFFFFF';
    ctx.textAlign = 'center';
    ctx.fillText('ZIGCLIP', 540, 200);

    // Stats
    ctx.font = '60px Courier New';
    ctx.fillText(`${this.user.elo} ELO`, 540, 600);
    ctx.fillText(`${this.user.wins} WINS`, 540, 750);
    ctx.fillText(`${this.user.losses} LOSSES`, 540, 900);

    // Rank
    ctx.font = 'bold 100px Courier New';
    ctx.fillText(`RANK #5`, 540, 1400);

    // Download
    canvas.toBlob(blob => {
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = 'zigclip-status.png';
      a.click();
      URL.revokeObjectURL(url);
    });
  }

  saveToStorage() {
    localStorage.setItem('zigclip_user', JSON.stringify(this.user));
    localStorage.setItem('zigclip_clips', JSON.stringify(this.clips));
  }

  loadFromStorage() {
    const user = localStorage.getItem('zigclip_user');
    const clips = localStorage.getItem('zigclip_clips');

    if (user) this.user = JSON.parse(user);
    if (clips) this.clips = JSON.parse(clips);
  }
}

// Start when DOM ready
document.addEventListener('DOMContentLoaded', () => {
  window.app = new ZigClip();
});