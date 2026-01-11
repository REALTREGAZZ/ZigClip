class ZigClip {
  constructor() {
    this.clips = [
      {
        id: 1,
        name: 'RADIANT_ACE_1v5',
        subtitle: 'Valorant Pro League Highlight',
        elo: 2850,
        wins: 89,
        losses: 12,
        video: 'assets/videos/clip_1.mp4',
        region: 'NA',
        agent: 'Jett'
      },
      {
        id: 2,
        name: 'IMMORTAL_CLUTCH_SPIKE',
        subtitle: '5 Seconds Left - Defuse Outplay',
        elo: 2650,
        wins: 72,
        losses: 18,
        video: 'assets/videos/clip_2.mp4',
        region: 'EU',
        agent: 'Viper'
      },
      {
        id: 3,
        name: 'ELITE_HEADSHOT_MONTAGE',
        subtitle: 'Vandal Only - 10 Kill Streak',
        elo: 2450,
        wins: 65,
        losses: 25,
        video: 'assets/videos/clip_3.mp4',
        region: 'BR',
        agent: 'Reyna'
      },
      {
        id: 4,
        name: 'DIAMOND_KNIFE_OUTPLAY',
        subtitle: 'Knife Round 1v4 Win',
        elo: 2280,
        wins: 58,
        losses: 32,
        video: 'assets/videos/clip_4.mp4',
        region: 'LATAM',
        agent: 'Raze'
      },
      {
        id: 5,
        name: 'PLATINUM_ULTIMATE_COMBO',
        subtitle: 'Phoenix + Sage Ultimate Synergy',
        elo: 2100,
        wins: 45,
        losses: 42,
        video: 'assets/videos/clip_5.mp4',
        region: 'APAC',
        agent: 'Phoenix'
      }
    ];

    this.user = {
      username: 'YOU',
      elo: 2450,
      wins: 156,
      losses: 77,
      duels: 0,
      agent: 'Jett',
      region: 'NA'
    };

    this.currentDuel = 0;
    this.isProcessing = false;
    this.startX = 0;
    this.startY = 0;
  }

  init() {
    this.loadFromStorage();
    this.setupEventListeners();
    this.switchScreen('home');
  }

  setupEventListeners() {
    document.getElementById('start-btn').addEventListener('click', () => this.startArena());
    document.getElementById('brag-btn').addEventListener('click', () => this.switchScreen('brag'));
    document.getElementById('arena-btn').addEventListener('click', () => this.switchScreen('arena'));
    document.getElementById('ranking-btn').addEventListener('click', () => this.switchScreen('ranking'));
    document.getElementById('export-btn').addEventListener('click', () => this.exportStatus());

    const videoLeft = document.getElementById('video-left');
    const videoRight = document.getElementById('video-right');

    videoLeft.addEventListener('touchstart', (e) => this.onTouchStart(e, 0));
    videoLeft.addEventListener('touchend', (e) => this.onTouchEnd(e, 0));
    videoLeft.addEventListener('mousedown', (e) => this.onMouseDown(e, 0));
    videoLeft.addEventListener('mouseup', (e) => this.onMouseUp(e, 0));

    videoRight.addEventListener('touchstart', (e) => this.onTouchStart(e, 1));
    videoRight.addEventListener('touchend', (e) => this.onTouchEnd(e, 1));
    videoRight.addEventListener('mousedown', (e) => this.onMouseDown(e, 1));
    videoRight.addEventListener('mouseup', (e) => this.onMouseUp(e, 1));
  }

  onTouchStart(e, side) {
    this.startX = e.touches[0].clientX;
    this.startY = e.touches[0].clientY;
  }

  onTouchEnd(e, side) {
    if (this.isProcessing) return;

    const endX = e.changedTouches[0].clientX;
    const endY = e.changedTouches[0].clientY;
    const deltaY = this.startY - endY;

    if (deltaY > 50) {
      this.handleWin(side);
    }
  }

  onMouseDown(e, side) {
    this.startX = e.clientX;
    this.startY = e.clientY;
  }

  onMouseUp(e, side) {
    if (this.isProcessing) return;

    const endX = e.clientX;
    const endY = e.clientY;
    const deltaY = this.startY - endY;

    if (deltaY > 50) {
      this.handleWin(side);
    }
  }

  startArena() {
    this.switchScreen('arena');
    this.loadVideos();
    this.playVideos();
  }

  loadVideos() {
    const left = this.clips[this.currentDuel % this.clips.length];
    const right = this.clips[(this.currentDuel + 1) % this.clips.length];

    const videoLeft = document.getElementById('video-left');
    const videoRight = document.getElementById('video-right');

    videoLeft.src = left.video;
    videoRight.src = right.video;

    document.getElementById('clip-name-left').textContent = left.name;
    document.getElementById('clip-elo-left').textContent = `${left.elo} ELO`;
    document.getElementById('clip-name-right').textContent = right.name;
    document.getElementById('clip-elo-right').textContent = `${right.elo} ELO`;
  }

  playVideos() {
    const videoLeft = document.getElementById('video-left');
    const videoRight = document.getElementById('video-right');

    videoLeft.currentTime = 0;
    videoRight.currentTime = 0;

    videoLeft.play().catch(e => console.warn('Video play failed:', e));
    videoRight.play().catch(e => console.warn('Video play failed:', e));
  }

  calculateElo(winnerElo, loserElo) {
    const K = 32;
    const expectedScore = 1 / (1 + Math.pow(10, (loserElo - winnerElo) / 400));
    const eloGain = Math.round(K * (1 - expectedScore));

    return eloGain;
  }

  async handleWin(winnerId) {
    this.isProcessing = true;

    const left = this.clips[this.currentDuel % this.clips.length];
    const right = this.clips[(this.currentDuel + 1) % this.clips.length];

    const winner = winnerId === 0 ? left : right;
    const loser = winnerId === 0 ? right : left;

    const eloGain = this.calculateElo(winner.elo, loser.elo);
    const eloLoss = eloGain;

    winner.elo += eloGain;
    loser.elo -= eloLoss;

    this.user.duels++;
    this.user.wins++;
    this.user.elo += eloGain;

    this.showFlash();
    this.showEloDelta(eloGain);
    this.playKillSound();

    this.saveToStorage();

    await new Promise(r => setTimeout(r, 600));
    this.currentDuel++;
    this.loadVideos();
    await this.playVideos();

    this.updateRanking();
    this.updateBrag();

    this.isProcessing = false;
  }

  showFlash() {
    const flash = document.getElementById('flash');
    flash.style.opacity = '1';
    setTimeout(() => {
      flash.style.opacity = '0';
    }, 400);
  }

  showEloDelta(delta) {
    const el = document.getElementById('elo-delta');

    let current = 0;
    const step = delta / 20;
    const interval = setInterval(() => {
      current += step;
      if (current >= delta) {
        current = delta;
        clearInterval(interval);
      }

      el.textContent = `+${Math.floor(current)} ELO`;
    }, 20);

    el.style.color = delta > 0 ? '#00FF00' : '#FF3B3B';
    el.classList.remove('hidden');

    setTimeout(() => {
      el.classList.add('hidden');
    }, 1500);
  }

  playKillSound() {
    const audio = new Audio('assets/sounds/kill.mp3');
    audio.volume = 0.3;
    audio.play().catch(e => console.warn('Audio play failed:', e));
  }

  updateRanking() {
    const rankingList = document.getElementById('ranking-list');
    rankingList.innerHTML = '';

    const allPlayers = [...this.clips, this.user];
    allPlayers.sort((a, b) => b.elo - a.elo);

    allPlayers.slice(0, 100).forEach((player, index) => {
      const li = document.createElement('li');
      li.className = 'ranking-item';

      const badge = this.getBadge(index);
      const badgeSpan = document.createElement('span');
      badgeSpan.className = 'badge';
      badgeSpan.textContent = badge;
      badgeSpan.style.color = this.getBadgeColor(index);

      const nameSpan = document.createElement('span');
      nameSpan.className = 'name';
      nameSpan.textContent = player.name || player.username;

      const eloSpan = document.createElement('span');
      eloSpan.className = 'elo';
      eloSpan.textContent = player.elo;

      li.appendChild(badgeSpan);
      li.appendChild(nameSpan);
      li.appendChild(eloSpan);
      rankingList.appendChild(li);
    });
  }

  getBadge(index) {
    if (index === 0) return '🏆';
    if (index < 3) return '🥇';
    if (index < 10) return '🔥';
    return '#';
  }

  getBadgeColor(index) {
    if (index === 0) return '#FFD700';
    if (index < 3) return '#C0C0C0';
    if (index < 10) return '#FF4500';
    return '#B0B0B0';
  }

  updateBrag() {
    document.getElementById('user-elo').textContent = `${this.user.elo} ELO`;
    document.getElementById('user-wins').textContent = this.user.wins;
    document.getElementById('user-losses').textContent = this.user.losses;
    document.getElementById('duel-count').textContent = this.currentDuel + 1;

    const total = this.user.wins + this.user.losses;
    const rate = total > 0 ? ((this.user.wins / total) * 100).toFixed(1) : 0;
    document.getElementById('user-winrate').textContent = `${rate}%`;
  }

  exportStatus() {
    const canvas = document.getElementById('export-canvas');
    canvas.width = 1080;
    canvas.height = 1920;
    const ctx = canvas.getContext('2d');

    const gradientBg = ctx.createLinearGradient(0, 0, 0, 1920);
    gradientBg.addColorStop(0, '#00FFD0');
    gradientBg.addColorStop(0.5, '#1a1a1a');
    gradientBg.addColorStop(1, '#050505');

    ctx.fillStyle = gradientBg;
    ctx.fillRect(0, 0, 1080, 1920);

    ctx.strokeStyle = 'rgba(0, 255, 208, 0.1)';
    ctx.lineWidth = 2;
    for (let i = 0; i < 1920; i += 50) {
      ctx.beginPath();
      ctx.moveTo(i, 0);
      ctx.lineTo(i + 1080, 1920);
      ctx.stroke();
    }

    ctx.font = 'bold 140px Courier New';
    ctx.fillStyle = '#00FFD0';
    ctx.textAlign = 'center';
    ctx.shadowColor = 'rgba(0, 255, 208, 0.5)';
    ctx.shadowBlur = 30;
    ctx.shadowOffsetY = 0;
    ctx.fillText('ZIGCLIP', 540, 200);

    const tier = this.getTier();
    ctx.font = 'bold 120px Courier New';
    ctx.fillStyle = tier.color;
    ctx.shadowColor = tier.shadowColor;
    ctx.shadowBlur = 40;
    ctx.fillText(tier.name, 540, 500);

    ctx.strokeStyle = '#00FFD0';
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.moveTo(150, 600);
    ctx.lineTo(930, 600);
    ctx.stroke();

    ctx.font = 'bold 140px Courier New';
    ctx.fillStyle = '#FFFFFF';
    ctx.shadowColor = 'rgba(0, 255, 208, 0.3)';
    ctx.shadowBlur = 20;
    ctx.fillText(`${this.user.elo}`, 540, 900);

    ctx.font = '40px Courier New';
    ctx.fillStyle = '#B0B0B0';
    ctx.shadowColor = 'none';
    ctx.fillText('ELO RATING', 540, 970);

    ctx.font = '60px Courier New';
    ctx.fillStyle = '#00FF00';
    ctx.textAlign = 'left';
    ctx.fillText(`${this.user.wins}W`, 200, 1150);

    ctx.fillStyle = '#FF3B3B';
    ctx.textAlign = 'right';
    ctx.fillText(`${this.user.losses}L`, 880, 1150);

    const total = this.user.wins + this.user.losses;
    const rate = total > 0 ? ((this.user.wins / total) * 100).toFixed(1) : 0;
    ctx.font = '50px Courier New';
    ctx.fillStyle = '#B0B0B0';
    ctx.textAlign = 'center';
    ctx.fillText(`${rate}% WIN RATE`, 540, 1300);

    ctx.font = 'bold 50px Courier New';
    ctx.fillStyle = '#00FFD0';
    ctx.textAlign = 'center';
    ctx.fillText(`MAIN: ${this.user.agent}`, 540, 1500);

    ctx.strokeStyle = '#00FFD0';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.moveTo(150, 1600);
    ctx.lineTo(930, 1600);
    ctx.stroke();

    const egoText = this.getEgoPhrase();
    ctx.font = 'italic 40px Courier New';
    ctx.fillStyle = '#FFD700';
    ctx.textAlign = 'center';
    ctx.fillText(egoText, 540, 1800);

    ctx.font = '35px Courier New';
    ctx.fillStyle = '#00FFD0';
    ctx.fillText('ENTRA EN ZIGCLIP.IO', 540, 1900);

    canvas.toBlob(blob => {
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = `ZIGCLIP-STATUS-${this.user.elo}.png`;
      a.click();
      URL.revokeObjectURL(url);
    });
  }

  getTier() {
    const elo = this.user.elo;

    if (elo >= 2700) {
      return { name: 'RADIANT', color: '#FF0000', shadowColor: 'rgba(255, 0, 0, 0.5)' };
    } else if (elo >= 2500) {
      return { name: 'IMMORTAL', color: '#FF6B9D', shadowColor: 'rgba(255, 107, 157, 0.5)' };
    } else if (elo >= 2400) {
      return { name: 'ELITE', color: '#00FFD0', shadowColor: 'rgba(0, 255, 208, 0.5)' };
    } else if (elo >= 2200) {
      return { name: 'DIAMOND', color: '#9D4EDD', shadowColor: 'rgba(157, 78, 221, 0.5)' };
    } else {
      return { name: 'ASCENDING', color: '#FFD700', shadowColor: 'rgba(255, 215, 0, 0.5)' };
    }
  }

  getEgoPhrase() {
    const phrases = [
      '¿Crees que puedes superarme?',
      'Únete si eres lo suficientemente bueno',
      'Esta es mi clase. ¿Cuál es la tuya?',
      'Demuestrame que tienes lo que se necesita',
      'Yo estoy aquí. ¿Dónde estás tú?',
      'El ranking espera tu desafío',
      'Haz que valga la pena'
    ];
    return phrases[Math.floor(Math.random() * phrases.length)];
  }

  saveToStorage() {
    localStorage.setItem('zigclip-user', JSON.stringify(this.user));
    localStorage.setItem('zigclip-clips', JSON.stringify(this.clips));
    localStorage.setItem('zigclip-duel', this.currentDuel);
  }

  loadFromStorage() {
    const user = localStorage.getItem('zigclip-user');
    const clips = localStorage.getItem('zigclip-clips');
    const duel = localStorage.getItem('zigclip-duel');

    if (user) this.user = JSON.parse(user);
    if (clips) this.clips = JSON.parse(clips);
    if (duel) this.currentDuel = parseInt(duel);
  }

  switchScreen(screen) {
    document.querySelectorAll('.screen').forEach(s => s.classList.add('hidden'));
    document.getElementById(`${screen}-screen`).classList.remove('hidden');

    document.querySelectorAll('.tab').forEach(t => t.classList.remove('active'));
    document.querySelector(`.tab[data-screen="${screen}"]`).classList.add('active');
  }
}

const app = new ZigClip();
app.init();