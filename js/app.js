import Storage from './storage.js';
import DataManager from './dataManager.js';
import EloSystem from './eloSystem.js';
import Effects from './effects.js';
import VideoManager from './videoManager.js';
import Arena from './arena.js';
import Ranking from './ranking.js';
import Brag from './brag.js';

class ZigClipApp {
  constructor() {
    this.currentScreen = 'startup';
    this.initialized = false;
    
    this.storage = new Storage();
    this.dataManager = new DataManager();
    this.eloSystem = new EloSystem(32);
    this.effects = new Effects();
    this.videoManager = new VideoManager();
    this.arena = null;
    this.ranking = null;
    this.brag = null;
  }

  async init() {
    console.log('🚀 ZIGCLIP Starting...');
    
    await this.registerServiceWorker();
    
    await this.dataManager.loadClips();
    
    this.videoManager.init(this.dataManager.getClips());
    
    this.arena = new Arena(
      this.videoManager,
      this.eloSystem,
      this.effects,
      this.storage,
      this.dataManager
    );
    this.arena.init();
    
    this.ranking = new Ranking(this.storage, this.dataManager);
    this.ranking.init();
    
    this.brag = new Brag(this.storage, this.eloSystem);
    this.brag.init();
    
    this.setupNavigation();
    this.setupStartButton();
    
    this.initialized = true;
    console.log('✅ ZIGCLIP Ready');
  }

  async registerServiceWorker() {
    if ('serviceWorker' in navigator) {
      try {
        const registration = await navigator.serviceWorker.register('./sw.js');
        console.log('✅ Service Worker registered:', registration.scope);
      } catch (error) {
        console.warn('⚠️ Service Worker registration failed:', error);
      }
    }
  }

  setupStartButton() {
    const startBtn = document.getElementById('start-btn');
    if (startBtn) {
      startBtn.addEventListener('click', () => {
        this.switchScreen('arena');
        this.videoManager.playVideos();
      });
    }
  }

  setupNavigation() {
    const navButtons = document.querySelectorAll('.nav-btn');
    navButtons.forEach(btn => {
      btn.addEventListener('click', (e) => {
        const screen = e.target.dataset.screen;
        this.switchScreen(screen);
      });
    });
  }

  switchScreen(screenName) {
    document.querySelectorAll('.screen').forEach(screen => {
      screen.classList.remove('active');
    });

    const targetScreen = document.getElementById(screenName);
    if (targetScreen) {
      targetScreen.classList.add('active');
    }

    document.querySelectorAll('.nav-btn').forEach(btn => {
      btn.classList.toggle('active', btn.dataset.screen === screenName);
    });

    this.currentScreen = screenName;

    if (screenName === 'arena') {
      this.videoManager.resume();
    } else {
      this.videoManager.pause();
    }

    if (screenName === 'ranking') {
      this.ranking.update();
    }

    if (screenName === 'brag') {
      this.brag.update();
    }

    console.log(`📍 Screen: ${screenName}`);
  }

  getScreenManager(screenName) {
    const managers = {
      arena: this.arena,
      ranking: this.ranking,
      brag: this.brag
    };
    return managers[screenName];
  }
}

document.addEventListener('DOMContentLoaded', async () => {
  window.zigclip = new ZigClipApp();
  await window.zigclip.init();
});
