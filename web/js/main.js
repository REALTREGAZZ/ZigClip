class MainApp {
  constructor() {
    this.arenaService = null;
    this.currentScreen = 'arena';
  }

  initialize() {
    // Register service worker for PWA
    this.registerServiceWorker();
    
    // Initialize storage
    StorageService.initializeIfNeeded();
    
    // Setup navigation
    this.setupNavigation();
    
    // Initialize arena
    this.showArena();
    
    // Check if we're running as PWA
    this.checkPWAInstall();
  }

  registerServiceWorker() {
    if ('serviceWorker' in navigator) {
      window.addEventListener('load', () => {
        navigator.serviceWorker.register('/service-worker.js')
          .then(registration => {
            console.log('ServiceWorker registration successful');
          })
          .catch(err => {
            console.log('ServiceWorker registration failed: ', err);
          });
      });
    }
  }

  setupNavigation() {
   const navButtons = {
     'nav-arena': 'arena',
     'nav-ranking': 'ranking',
     'nav-brag': 'brag'
   };

   Object.entries(navButtons).forEach(([buttonId, screenName]) => {
     const button = document.getElementById(buttonId);
     if (button) {
       button.addEventListener('click', () => {
         this.showScreen(screenName);
       });
     }
   });
  }

  showScreen(screenName) {
    // Hide all screens
    const screens = document.querySelectorAll('.screen');
    screens.forEach(screen => screen.classList.remove('active'));
    
    // Remove active class from nav buttons
    const navButtons = document.querySelectorAll('.nav-btn');
    navButtons.forEach(btn => btn.classList.remove('active'));
    
    // Show selected screen
    const screen = document.getElementById(screenName);
    screen.classList.add('active');
    
    // Activate corresponding nav button
    const navButton = document.getElementById(`nav-${screenName}`);
    navButton.classList.add('active');
    
    this.currentScreen = screenName;
    
    // Initialize screen-specific functionality
    switch (screenName) {
      case 'arena':
        this.showArena();
        break;
      case 'ranking':
        this.showRanking();
        break;
      case 'brag':
        this.showBrag();
        break;
    }
  }

  showArena() {
    if (!this.arenaService) {
      this.arenaService = new ArenaService();
      this.arenaService.initialize();
    }
  }

  showRanking() {
    RankingService.updateRankingDisplay();
    RankingService.setupFilterTabs();
  }

  showBrag() {
    BragService.updateBragDisplay();
  }

  checkPWAInstall() {
    // Check if app is installed
    if (window.matchMedia('(display-mode: standalone)').matches) {
      console.log('App is installed as PWA');
    }
    
    // Listen for app installed event
    window.addEventListener('appinstalled', () => {
      console.log('App was installed');
    });
  }
}

// Initialize app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
  const app = new MainApp();
  app.initialize();
});