class VideoManager {
  constructor() {
    this.videoLeft = null;
    this.videoRight = null;
    this.preloadQueue = [];
    this.currentIndex = 0;
    this.clips = [];
    this.isReady = false;
  }

  init(clips) {
    this.clips = clips;
    this.videoLeft = document.getElementById('video-left');
    this.videoRight = document.getElementById('video-right');
    
    if (!this.videoLeft || !this.videoRight) {
      console.error('❌ Video elements not found');
      return;
    }

    this.setupVideoElements();
    this.loadInitialPair();
    console.log('✅ VideoManager initialized');
  }

  setupVideoElements() {
    [this.videoLeft, this.videoRight].forEach(video => {
      video.loop = true;
      video.muted = true;
      video.playsInline = true;
      video.preload = 'auto';
      
      video.addEventListener('loadeddata', () => {
        console.log('✅ Video loaded:', video.src);
      });

      video.addEventListener('error', (e) => {
        console.error('❌ Video error:', e);
      });
    });
  }

  loadInitialPair() {
    const clipA = this.clips[this.currentIndex % this.clips.length];
    const clipB = this.clips[(this.currentIndex + 1) % this.clips.length];
    
    this.loadPair(clipA, clipB);
    this.preloadNext();
  }

  loadPair(clipA, clipB) {
    if (!clipA || !clipB) return;

    this.videoLeft.src = clipA.video_url;
    this.videoRight.src = clipB.video_url;

    this.updateClipInfo('left', clipA);
    this.updateClipInfo('right', clipB);

    this.videoLeft.load();
    this.videoRight.load();

    return Promise.all([
      this.waitForCanPlay(this.videoLeft),
      this.waitForCanPlay(this.videoRight)
    ]);
  }

  waitForCanPlay(video) {
    return new Promise((resolve) => {
      if (video.readyState >= 3) {
        resolve();
      } else {
        video.addEventListener('canplay', () => resolve(), { once: true });
      }
    });
  }

  updateClipInfo(side, clip) {
    const nameEl = document.getElementById(`clip-name-${side}`);
    const eloEl = document.getElementById(`clip-elo-${side}`);
    
    if (nameEl) nameEl.textContent = clip.name;
    if (eloEl) eloEl.textContent = `${clip.elo} ELO`;
  }

  async playVideos() {
    try {
      await Promise.all([
        this.videoLeft.play(),
        this.videoRight.play()
      ]);
      this.isReady = true;
      console.log('✅ Videos playing');
    } catch (e) {
      console.warn('⚠️ Autoplay blocked, user interaction needed');
      
      const playOnInteraction = async () => {
        try {
          await this.videoLeft.play();
          await this.videoRight.play();
          this.isReady = true;
          document.removeEventListener('click', playOnInteraction);
          document.removeEventListener('touchstart', playOnInteraction);
        } catch (err) {
          console.error('Play failed:', err);
        }
      };
      
      document.addEventListener('click', playOnInteraction, { once: true });
      document.addEventListener('touchstart', playOnInteraction, { once: true });
    }
  }

  preloadNext() {
    const nextIndexA = (this.currentIndex + 2) % this.clips.length;
    const nextIndexB = (this.currentIndex + 3) % this.clips.length;
    
    const clipA = this.clips[nextIndexA];
    const clipB = this.clips[nextIndexB];
    
    if (clipA && clipB) {
      this.preloadVideo(clipA.video_url);
      this.preloadVideo(clipB.video_url);
    }
  }

  preloadVideo(url) {
    if (this.preloadQueue.includes(url)) return;
    
    const video = document.createElement('video');
    video.preload = 'auto';
    video.src = url;
    video.load();
    
    this.preloadQueue.push(url);
    
    if (this.preloadQueue.length > 6) {
      this.preloadQueue.shift();
    }
  }

  async loadNextPair() {
    this.currentIndex += 2;
    
    const clipA = this.clips[this.currentIndex % this.clips.length];
    const clipB = this.clips[(this.currentIndex + 1) % this.clips.length];
    
    await this.loadPair(clipA, clipB);
    await this.playVideos();
    
    this.preloadNext();
  }

  getCurrentPair() {
    return {
      left: this.clips[this.currentIndex % this.clips.length],
      right: this.clips[(this.currentIndex + 1) % this.clips.length]
    };
  }

  pause() {
    this.videoLeft?.pause();
    this.videoRight?.pause();
  }

  resume() {
    this.videoLeft?.play().catch(e => console.warn('Resume failed:', e));
    this.videoRight?.play().catch(e => console.warn('Resume failed:', e));
  }

  destroy() {
    this.pause();
    this.videoLeft = null;
    this.videoRight = null;
    this.preloadQueue = [];
  }
}

export default VideoManager;
