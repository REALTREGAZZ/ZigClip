class Arena {
  constructor(videoManager, eloSystem, effects, storage, dataManager) {
    this.videoManager = videoManager;
    this.eloSystem = eloSystem;
    this.effects = effects;
    this.storage = storage;
    this.dataManager = dataManager;
    
    this.isProcessing = false;
    this.touchStartY = 0;
    this.touchStartX = 0;
    this.swipeThreshold = 50;
    
    this.duelCount = 0;
  }

  init() {
    this.setupSwipeDetection();
    this.updateHeader();
    console.log('✅ Arena initialized');
  }

  setupSwipeDetection() {
    const videoLeft = document.getElementById('video-left');
    const videoRight = document.getElementById('video-right');
    
    if (!videoLeft || !videoRight) return;

    [videoLeft, videoRight].forEach((video, index) => {
      video.addEventListener('touchstart', (e) => this.onTouchStart(e), { passive: true });
      video.addEventListener('touchend', (e) => this.onTouchEnd(e, index), { passive: true });
      
      video.addEventListener('mousedown', (e) => this.onMouseDown(e));
      video.addEventListener('mouseup', (e) => this.onMouseUp(e, index));
      
      video.addEventListener('click', (e) => {
        if (!this.isProcessing) {
          this.handleWin(index);
        }
      });
    });
  }

  onTouchStart(e) {
    this.touchStartY = e.touches[0].clientY;
    this.touchStartX = e.touches[0].clientX;
  }

  onTouchEnd(e, index) {
    if (this.isProcessing) return;
    
    const touchEndY = e.changedTouches[0].clientY;
    const touchEndX = e.changedTouches[0].clientX;
    
    const deltaY = Math.abs(touchEndY - this.touchStartY);
    const deltaX = Math.abs(touchEndX - this.touchStartX);
    
    if (deltaY > this.swipeThreshold || deltaX > this.swipeThreshold) {
      this.handleWin(index);
    }
  }

  onMouseDown(e) {
    this.touchStartY = e.clientY;
    this.touchStartX = e.clientX;
  }

  onMouseUp(e, index) {
    if (this.isProcessing) return;
    
    const deltaY = Math.abs(e.clientY - this.touchStartY);
    const deltaX = Math.abs(e.clientX - this.touchStartX);
    
    if (deltaY > this.swipeThreshold || deltaX > this.swipeThreshold) {
      this.handleWin(index);
    }
  }

  async handleWin(winnerIndex) {
    if (this.isProcessing) return;
    this.isProcessing = true;

    const pair = this.videoManager.getCurrentPair();
    const winner = winnerIndex === 0 ? pair.left : pair.right;
    const loser = winnerIndex === 0 ? pair.right : pair.left;

    const winnerContainer = winnerIndex === 0 
      ? document.querySelector('.video-container:first-child')
      : document.querySelector('.video-container:last-child');

    this.effects.pulseWinner(winnerContainer);
    this.effects.comboEffect();

    const result = this.eloSystem.processMatch(winner, loser);
    
    this.dataManager.updateClipElo(winner.id, result.delta);
    this.dataManager.updateClipElo(loser.id, -result.delta);

    const userData = this.storage.getUserData();
    this.storage.updateUserElo(result.delta);
    this.storage.recordVote(winner.id, loser.id, winner.id);
    this.storage.updateStats(userData.wins + 1, userData.losses);

    this.effects.showEloDelta(result.delta, true);

    this.duelCount++;
    this.updateHeader();

    await new Promise(resolve => setTimeout(resolve, 600));

    await this.videoManager.loadNextPair();

    this.isProcessing = false;
  }

  updateHeader() {
    const userData = this.storage.getUserData();
    
    const duelCountEl = document.getElementById('duel-count');
    const userEloEl = document.getElementById('user-elo');
    
    if (duelCountEl) duelCountEl.textContent = this.duelCount;
    if (userEloEl) userEloEl.textContent = `${userData.elo} ELO`;
  }

  reset() {
    this.duelCount = 0;
    this.isProcessing = false;
    this.updateHeader();
  }
}

export default Arena;
