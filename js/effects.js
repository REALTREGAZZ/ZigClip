class Effects {
  constructor() {
    this.killSound = null;
    this.soundEnabled = true;
    this.vibrateEnabled = true;
    this.preloadSound();
  }

  preloadSound() {
    try {
      this.killSound = new Audio('assets/sounds/kill.mp3');
      this.killSound.volume = 0.3;
      this.killSound.load();
    } catch (e) {
      console.warn('⚠️ Sound preload failed:', e);
    }
  }

  playKillSound() {
    if (!this.soundEnabled || !this.killSound) return;
    
    try {
      this.killSound.currentTime = 0;
      this.killSound.play().catch(e => console.warn('Sound play failed:', e));
    } catch (e) {
      console.warn('Sound error:', e);
    }
  }

  vibrate(pattern = [50, 30, 50]) {
    if (!this.vibrateEnabled) return;
    
    if (navigator.vibrate) {
      navigator.vibrate(pattern);
    }
  }

  flash() {
    const flashEl = document.getElementById('flash');
    if (!flashEl) return;
    
    flashEl.style.opacity = '1';
    setTimeout(() => {
      flashEl.style.opacity = '0';
    }, 100);
  }

  showEloDelta(delta, isWin = true) {
    const eloDeltaEl = document.getElementById('elo-delta');
    if (!eloDeltaEl) return;

    const sign = delta >= 0 ? '+' : '';
    eloDeltaEl.textContent = `${sign}${delta} ELO`;
    eloDeltaEl.style.color = isWin ? '#00FF00' : '#FF3B3B';
    eloDeltaEl.classList.add('show');

    this.animateNumber(eloDeltaEl, 0, delta, 400);

    setTimeout(() => {
      eloDeltaEl.classList.remove('show');
    }, 1500);
  }

  animateNumber(element, start, end, duration) {
    const startTime = performance.now();
    const sign = end >= 0 ? '+' : '';
    
    const animate = (currentTime) => {
      const elapsed = currentTime - startTime;
      const progress = Math.min(elapsed / duration, 1);
      const current = Math.floor(start + (end - start) * progress);
      
      element.textContent = `${sign}${current} ELO`;
      
      if (progress < 1) {
        requestAnimationFrame(animate);
      }
    };
    
    requestAnimationFrame(animate);
  }

  pulseWinner(videoContainer) {
    if (!videoContainer) return;
    videoContainer.classList.add('winner-selected');
    setTimeout(() => {
      videoContainer.classList.remove('winner-selected');
    }, 300);
  }

  comboEffect() {
    this.flash();
    this.playKillSound();
    this.vibrate();
  }

  setSoundEnabled(enabled) {
    this.soundEnabled = enabled;
  }

  setVibrateEnabled(enabled) {
    this.vibrateEnabled = enabled;
  }
}

export default Effects;
