// ZIGCLIP Main Application - Fixed initialization flow
document.addEventListener('DOMContentLoaded', async () => {
  console.log('🚀 ZIGCLIP starting...');

  // 1. Initialize storage
  StorageService.initializeIfNeeded();

  // 2. Load clips
  const clips = StorageService.loadClips();
  console.log(`📹 ${clips.length} clips cargados`);

  // 3. Create video paths
  const videoPaths = clips.map(c => c.video);

  // 4. Initialize preloader (WITHOUT autoplay)
  const preloader = new VideoPreloader(videoPaths);
  await preloader.initialize();

  // 5. Initialize arena
  const arena = new ArenaService();
  arena.setPreloader(preloader);
  arena.initialize();

  // 6. Setup START button
  document.getElementById('start-button').addEventListener('click', async () => {
    console.log('▶️ START clicked - reproducing video');
    
    // Hide overlay, show arena
    document.getElementById('startup-overlay').classList.add('hidden');
    document.getElementById('arena-container').classList.add('show');
    
    // Now play video (after user interaction)
    await preloader.play();
  });

  // 7. Save references globally
  window.ZIGCLIP = { preloader, arena };

  console.log('✅ ZIGCLIP initialized');
});