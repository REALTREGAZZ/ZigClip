class ArenaService {
  constructor() {
    this.preloader = null;
    this.particleSystem = null;
    this.currentDuelCount = 0;
    this.isProcessingVote = false;
    this.touchStartX = 0;
    this.touchStartY = 0;
    this.touchEndX = 0;
    this.touchEndY = 0;
  }

  setPreloader(preloader) {
    this.preloader = preloader;
  }

  initialize() {
    // Initialize storage
    StorageService.initializeIfNeeded();

    // Initialize particle system
    const particleCanvas = document.getElementById('particles');
    this.particleSystem = new ParticleSystem(particleCanvas);

    // Setup event listeners
    this.setupEventListeners();

    // Update duel count
    this.updateDuelCount();

    // Update user ELO display
    this.updateUserELO();
  }

  setupEventListeners() {
    const currentVideo = document.getElementById('current-video');
    const nextVideo = document.getElementById('next-video');
    const flashOverlay = document.getElementById('flash-overlay');
    
    // Touch events for mobile - SWIPE UP TO WIN
    currentVideo.addEventListener('touchstart', (e) => {
      this.touchStartY = e.changedTouches[0].clientY;
    }, { passive: true });
    
    currentVideo.addEventListener('touchend', (e) => {
      this.touchEndY = e.changedTouches[0].clientY;
      this.handleSwipe('left'); // Left video wins
    }, { passive: true });
    
    nextVideo.addEventListener('touchstart', (e) => {
      this.touchStartY = e.changedTouches[0].clientY;
    }, { passive: true });
    
    nextVideo.addEventListener('touchend', (e) => {
      this.touchEndY = e.changedTouches[0].clientY;
      this.handleSwipe('right'); // Right video wins
    }, { passive: true });
    
    // Mouse events for desktop
    let isDragging = false;
    
    currentVideo.addEventListener('mousedown', (e) => {
      isDragging = true;
      this.touchStartY = e.clientY;
    });
    
    currentVideo.addEventListener('mouseup', (e) => {
      if (isDragging) {
        this.touchEndY = e.clientY;
        this.handleSwipe('left');
        isDragging = false;
      }
    });
    
    nextVideo.addEventListener('mousedown', (e) => {
      isDragging = true;
      this.touchStartY = e.clientY;
    });
    
    nextVideo.addEventListener('mouseup', (e) => {
      if (isDragging) {
        this.touchEndY = e.clientY;
        this.handleSwipe('right');
        isDragging = false;
      }
    });
    
    // Prevent default touch behavior
    document.addEventListener('touchmove', (e) => {
      e.preventDefault();
    }, { passive: false });
  }

  handleSwipe(side) {
    if (this.isProcessingVote) return;
    
    const deltaY = this.touchStartY - this.touchEndY;
    
    // If swipe UP (>50px), winner
    if (deltaY > 50) {
      this.isProcessingVote = true;
      this.processVote(side);
    }
  }

  processVote(winningSide) {
    const clips = StorageService.loadClips();
    const userProfile = StorageService.loadProfile();
    
    const currentClipId = this.preloader.getCurrentClipId();
    const nextClipId = this.preloader.getNextClipId();
    
    const currentClip = clips.find(c => c.id === currentClipId);
    const nextClip = clips.find(c => c.id === nextClipId);
    
    if (!currentClip || !nextClip) {
      console.error('Clips not found');
      this.isProcessingVote = false;
      return;
    }
    
    // Determine winner and loser between the two clips
    const winnerClip = winningSide === 'left' ? currentClip : nextClip;
    const loserClip = winningSide === 'left' ? nextClip : currentClip;
    
    // Calculate ELO changes
    const eloResult = ELOCalculator.calculateDuel(winnerClip, loserClip);
    
    // Update clips
    winnerClip.elo = eloResult.new_winner_elo;
    loserClip.elo = eloResult.new_loser_elo;
    
    // Save updates
    StorageService.saveClips(clips);
    
    // Record vote
    const vote = {
      timestamp: new Date().toISOString(),
      winnerId: winnerClip.id,
      loserId: loserClip.id,
      winnerElo: eloResult.winner_delta
    };
    StorageService.saveVote(vote);
    
    // Trigger animations
    const eloDelta = eloResult.winner_delta;
    this.triggerVictoryAnimations(winningSide, eloDelta);
    
    // Move to next duel
    setTimeout(() => {
      this.preloader.nextDuel();
      this.updateDuelCount();
      this.isProcessingVote = false;
    }, 1500);
  }

  triggerVictoryAnimations(winningSide, eloDelta) {
    const flashOverlay = document.getElementById('flash-overlay');
    const currentVideo = document.getElementById('current-video');
    const nextVideo = document.getElementById('next-video');
    
    // Flash animation
    Animations.flashNeon(flashOverlay, '#00FFD0', 3);
    
    // ELO delta animation
    const color = eloDelta > 0 ? '#00FFD0' : '#FF3B3B';
    const text = eloDelta > 0 ? `+${eloDelta} ELO` : `${eloDelta} ELO`;
    
    // Show and animate ELO delta
    const eloDeltaElement = document.getElementById('elo-delta');
    eloDeltaElement.textContent = text;
    eloDeltaElement.style.color = color;
    eloDeltaElement.classList.remove('hidden');
    eloDeltaElement.classList.add('show');
    
    setTimeout(() => {
      eloDeltaElement.classList.remove('show');
      eloDeltaElement.classList.add('hidden');
    }, 1000);
    
    // Particles
    const rect = winningSide === 'left' ? currentVideo.getBoundingClientRect() : nextVideo.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const centerY = rect.top + rect.height / 2;
    this.particleSystem.emit(centerX, centerY);
    
    // Sound
    Animations.playKillSound();
  }

  updateDuelCount() {
    const duelCount = document.getElementById('duel-count');
    this.currentDuelCount++;
    duelCount.textContent = this.currentDuelCount;
  }

  updateUserELO() {
    const userProfile = StorageService.loadProfile();
    const userELO = document.getElementById('user-elo');
    userELO.textContent = `${userProfile.elo} ELO`;
  }
}