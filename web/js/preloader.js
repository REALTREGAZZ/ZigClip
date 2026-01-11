class VideoPreloader {
  constructor(videoPaths) {
    this.paths = videoPaths;
    this.currentIndex = 0;
    this.currentVideo = document.getElementById('current-video');
    this.nextVideo = document.getElementById('next-video');
    this.upcomingVideo = null;
    this.isTransitioning = false;
  }

  initialize() {
    if (this.paths.length === 0) return;
    
    this.currentVideo.src = this.paths[0];
    this.nextVideo.src = this.paths[1];
    
    // Preload upcoming video
    this.preloadNext();
    
    // Start playing current video
    this.currentVideo.play().catch(e => console.error('Video play error:', e));
    
    // Loop when current video ends
    this.currentVideo.addEventListener('ended', () => {
      if (!this.isTransitioning) {
        this.nextDuel();
      }
    });
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
    this.upcomingVideo.load();
  }

  nextDuel() {
   this.isTransitioning = true;

   // Move current to next
   this.currentIndex = (this.currentIndex + 1) % this.paths.length;

   // Update video sources
   this.currentVideo.src = this.nextVideo.src;
   this.nextVideo.src = this.upcomingVideo ? this.upcomingVideo.src : this.paths[(this.currentIndex + 1) % this.paths.length];

   // Preload new upcoming
   this.preloadNext();

   // Play current video
   this.currentVideo.currentTime = 0;
   this.currentVideo.play().catch(e => console.error('Video play error:', e));

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