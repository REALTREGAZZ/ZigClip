class DataManager {
  constructor() {
    this.clips = [];
    this.loaded = false;
  }

  async loadClips() {
    try {
      const response = await fetch('data/clips.json');
      const data = await response.json();
      this.clips = data.clips.map(clip => ({
        ...clip,
        video_url: clip.video_url || `assets/videos/${clip.id}.mp4`
      }));
      this.loaded = true;
      console.log(`✅ Loaded ${this.clips.length} clips`);
      return this.clips;
    } catch (e) {
      console.warn('⚠️ Failed to load clips.json, using defaults');
      this.clips = this.getDefaultClips();
      this.loaded = true;
      return this.clips;
    }
  }

  getDefaultClips() {
    return [
      { id: 'clip_001', name: 'RADIANT_ACE_1v5', elo: 2850, wins: 89, losses: 12, video_url: 'assets/videos/clip_1.mp4', owner: 'Pro Player', badge: 'gold' },
      { id: 'clip_002', name: 'IMMORTAL_CLUTCH', elo: 2650, wins: 72, losses: 18, video_url: 'assets/videos/clip_2.mp4', owner: 'Elite Gamer', badge: 'silver' },
      { id: 'clip_003', name: 'ELITE_HEADSHOT', elo: 2450, wins: 65, losses: 25, video_url: 'assets/videos/clip_3.mp4', owner: 'Sharp Shooter', badge: 'bronze' },
      { id: 'clip_004', name: 'DIAMOND_KNIFE', elo: 2280, wins: 58, losses: 32, video_url: 'assets/videos/clip_4.mp4', owner: 'Knife Master', badge: '' },
      { id: 'clip_005', name: 'PLATINUM_ULTIMATE', elo: 2100, wins: 45, losses: 42, video_url: 'assets/videos/clip_5.mp4', owner: 'Ultimate User', badge: '' }
    ];
  }

  getClips() {
    return this.clips;
  }

  getClip(id) {
    return this.clips.find(c => c.id === id);
  }

  updateClipElo(id, delta) {
    const clip = this.clips.find(c => c.id === id);
    if (clip) {
      clip.elo += delta;
      if (delta > 0) {
        clip.wins++;
      } else {
        clip.losses++;
      }
    }
  }

  getClipsByElo() {
    return [...this.clips].sort((a, b) => b.elo - a.elo);
  }
}

export default DataManager;
