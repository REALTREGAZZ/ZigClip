class VideoPreloader {
  constructor(videoPaths) {
    this.paths = videoPaths;
    this.currentIndex = 0;
    this.currentVideo = document.getElementById('current-video');
    this.nextVideo = document.getElementById('next-video');
    this.upcomingVideo = null;
    this.isTransitioning = false;
    this.isInitialized = false;
  }

  // Initialize videos WITHOUT autoplay
  async initialize() {
    if (this.paths.length === 0) return;
    
    try {
      this.currentVideo.src = this.paths[0];
      this.nextVideo.src = this.paths[1];
      
      // Preload upcoming video
      this.preloadNext();
      
      this.isInitialized = true;
      console.log('✅ Videos inicializados (NO autoplay)');
    } catch (error) {
      console.error('❌ Error inicializando videos:', error);
    }
  }

  // Play must be called AFTER user interaction
  async play() {
    if (!this.isInitialized) {
      console.warn('Videos no inicializados, omitiendo play');
      return;
    }
    
    try {
      // Ensure videos are muted for autoplay compatibility
      this.currentVideo.muted = true;
      this.nextVideo.muted = true;
      
      // Use playsinline + muted for better compatibility
      const playPromise = this.currentVideo.play();
      if (playPromise !== undefined) {
        await playPromise;
        console.log('▶️ Video playing');
      }
    } catch (error) {
      console.error('❌ Play error:', error);
    }
  }

  preloadNext() {
    const nextIndex = (this.currentIndex + 2) % this.paths.length;
    if (this.upcomingVideo) {
      this.upcomingVideo.pause();
      this.upcomingVideo.src = '';
    }
    
    this.upcomingVideo = document.createElement('video');
    this.upcomingVideo.src = this.paths[nextIndex];
    this.upcomingVideo.preload = 'auto';
    this.upcomingVideo.muted = true; // Ensure muted for preloading
    this.upcomingVideo.load();
  }

  async nextDuel() {
    this.isTransitioning = true;

    // Move current to next
    this.currentIndex = (this.currentIndex + 1) % this.paths.length;

    // Pause current video
    this.currentVideo.pause();
    this.currentVideo.currentTime = 0;

    // Update video sources
    this.currentVideo.src = this.nextVideo.src;
    this.nextVideo.src = this.upcomingVideo ? this.upcomingVideo.src : this.paths[(this.currentIndex + 1) % this.paths.length];

    // Preload new upcoming
    this.preloadNext();

    // Play current video after a small delay
    await new Promise(r => setTimeout(r, 100));
    await this.play();

    setTimeout(() => {
      this.isTransitioning = false;
    }, 500);
  }

  getCurrentClipId() {
    return this.currentIndex + 1; // 1-based index
  }

  getNextClipId() {
    return (this.currentIndex + 1) % this.paths.length + 1; // 1-based index
  }
}