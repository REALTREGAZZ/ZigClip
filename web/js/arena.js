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

  initialize() {
   // Initialize storage
   StorageService.initializeIfNeeded();

   // Setup video paths
   const videoPaths = [];
   for (let i = 1; i <= 5; i++) {
     videoPaths.push(`assets/videos/clip_${i}.mp4`);
   }

   // Initialize preloader
   this.preloader = new VideoPreloader(videoPaths);
   this.preloader.initialize();

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
    
    // Touch events for mobile
    currentVideo.addEventListener('touchstart', (e) => {
      this.touchStartX = e.changedTouches[0].screenX;
      this.touchStartY = e.changedTouches[0].screenY;
    }, { passive: true });
    
    currentVideo.addEventListener('touchend', (e) => {
      this.touchEndX = e.changedTouches[0].screenX;
      this.touchEndY = e.changedTouches[0].screenY;
      this.handleSwipe(currentVideo, 'left');
    }, { passive: true });
    
    nextVideo.addEventListener('touchstart', (e) => {
      this.touchStartX = e.changedTouches[0].screenX;
      this.touchStartY = e.changedTouches[0].screenY;
    }, { passive: true });
    
    nextVideo.addEventListener('touchend', (e) => {
      this.touchEndX = e.changedTouches[0].screenX;
      this.touchEndY = e.changedTouches[0].screenY;
      this.handleSwipe(nextVideo, 'right');
    }, { passive: true });
    
    // Mouse events for desktop
    let isDragging = false;
    
    currentVideo.addEventListener('mousedown', (e) => {
      isDragging = true;
      this.touchStartX = e.clientX;
      this.touchStartY = e.clientY;
    });
    
    currentVideo.addEventListener('mouseup', (e) => {
      if (isDragging) {
        this.touchEndX = e.clientX;
        this.touchEndY = e.clientY;
        this.handleSwipe(currentVideo, 'left');
        isDragging = false;
      }
    });
    
    nextVideo.addEventListener('mousedown', (e) => {
      isDragging = true;
      this.touchStartX = e.clientX;
      this.touchStartY = e.clientY;
    });
    
    nextVideo.addEventListener('mouseup', (e) => {
      if (isDragging) {
        this.touchEndX = e.clientX;
        this.touchEndY = e.clientY;
        this.handleSwipe(nextVideo, 'right');
        isDragging = false;
      }
    });
    
    // Prevent default touch behavior
    document.addEventListener('touchmove', (e) => {
      e.preventDefault();
    }, { passive: false });
  }

  handleSwipe(videoElement, side) {
    if (this.isProcessingVote) return;
    
    const deltaX = this.touchEndX - this.touchStartX;
    const deltaY = this.touchEndY - this.touchStartY;
    
    // Check if it's a swipe up
    if (Math.abs(deltaY) > Math.abs(deltaX) && deltaY < -50) {
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
    
    // In this implementation, the user is always dueling against clips
    // Left side is current clip vs user, right side is next clip vs user
    let opponentClip, userWon;
    
    if (winningSide === 'left') {
      // User beat the current clip
      opponentClip = currentClip;
      userWon = true;
    } else {
      // User lost to the next clip
      opponentClip = nextClip;
      userWon = false;
    }
    
    // Calculate ELO changes between user and opponent
    const eloResult = userWon 
      ? ELOCalculator.calculateDuel(userProfile, opponentClip)
      : ELOCalculator.calculateDuel(opponentClip, userProfile);
    
    // Update user profile
    if (userWon) {
      userProfile.elo = eloResult.new_winner_elo;
      userProfile.wins++;
      opponentClip.elo = eloResult.new_loser_elo;
    } else {
      userProfile.elo = eloResult.new_loser_elo;
      userProfile.losses++;
      opponentClip.elo = eloResult.new_winner_elo;
    }
    
    userProfile.duels_played++;
    
    // Save updates
    StorageService.saveClips(clips);
    StorageService.saveProfile(userProfile);
    
    // Record vote
    const vote = {
      timestamp: new Date().toISOString(),
      winnerId: userWon ? userProfile.id : opponentClip.id,
      loserId: userWon ? opponentClip.id : userProfile.id,
      eloChange: userWon ? eloResult.winner_delta : eloResult.loser_delta
    };
    StorageService.saveVote(vote);
    
    // Trigger animations
    const eloDelta = userWon ? eloResult.winner_delta : eloResult.loser_delta;
    this.triggerVictoryAnimations(winningSide, eloDelta);
    
    // Move to next duel
    setTimeout(() => {
      this.preloader.nextDuel();
      this.updateDuelCount();
      this.updateUserELO();
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
    Animations.animateELODelta(text, color);
    
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