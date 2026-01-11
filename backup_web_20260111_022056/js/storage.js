class StorageService {
  static STORAGE_KEYS = {
    CLIPS: 'zigclip_clips',
    PROFILE: 'zigclip_profile',
    VOTES: 'zigclip_votes'
  };

  static initializeIfNeeded() {
    try {
      if (!localStorage.getItem(this.STORAGE_KEYS.CLIPS)) {
        const initialClips = [
          { id: 1, username: 'APEX_PRED_1', elo: 2450, wins: 45, losses: 12, video: 'assets/videos/clip_1.mp4' },
          { id: 2, username: 'ELITE_PLAYER_2', elo: 2100, wins: 38, losses: 18, video: 'assets/videos/clip_2.mp4' },
          { id: 3, username: 'VETERAN_3', elo: 1850, wins: 32, losses: 25, video: 'assets/videos/clip_3.mp4' },
          { id: 4, username: 'RISING_STAR_4', elo: 1600, wins: 28, losses: 35, video: 'assets/videos/clip_4.mp4' },
          { id: 5, username: 'NEWBIE_5', elo: 1400, wins: 15, losses: 42, video: 'assets/videos/clip_5.mp4' }
        ];
        
        localStorage.setItem(this.STORAGE_KEYS.CLIPS, JSON.stringify(initialClips));
        console.log('✅ Default clips initialized');
      }

      if (!localStorage.getItem(this.STORAGE_KEYS.PROFILE)) {
        const userProfile = {
          id: 'user',
          username: 'YOU',
          elo: 1800,
          wins: 0,
          losses: 0,
          duels_played: 0,
          votes: []
        };

        localStorage.setItem(this.STORAGE_KEYS.PROFILE, JSON.stringify(userProfile));
        console.log('✅ Default profile initialized');
      }

      if (!localStorage.getItem(this.STORAGE_KEYS.VOTES)) {
        localStorage.setItem(this.STORAGE_KEYS.VOTES, JSON.stringify([]));
        console.log('✅ Default votes initialized');
      }

      console.log('✅ Storage initialized successfully');
    } catch (error) {
      console.error('❌ Error initializing storage:', error);
    }
  }

  static loadClips() {
    try {
      const data = localStorage.getItem(this.STORAGE_KEYS.CLIPS);
      return data ? JSON.parse(data) : [];
    } catch (error) {
      console.error('Error loading clips:', error);
      return [];
    }
  }

  static saveClips(clips) {
    try {
      localStorage.setItem(this.STORAGE_KEYS.CLIPS, JSON.stringify(clips));
    } catch (error) {
      console.error('Error saving clips:', error);
    }
  }

  static loadProfile() {
    try {
      const data = localStorage.getItem(this.STORAGE_KEYS.PROFILE);
      return data ? JSON.parse(data) : null;
    } catch (error) {
      console.error('Error loading profile:', error);
      return null;
    }
  }

  static saveProfile(profile) {
    try {
      localStorage.setItem(this.STORAGE_KEYS.PROFILE, JSON.stringify(profile));
    } catch (error) {
      console.error('Error saving profile:', error);
    }
  }

  static loadVotes() {
    try {
      const data = localStorage.getItem(this.STORAGE_KEYS.VOTES);
      return data ? JSON.parse(data) : [];
    } catch (error) {
      console.error('Error loading votes:', error);
      return [];
    }
  }

  static saveVote(vote) {
    try {
      const votes = this.loadVotes();
      votes.push({
        ...vote,
        timestamp: new Date().toISOString()
      });
      localStorage.setItem(this.STORAGE_KEYS.VOTES, JSON.stringify(votes));
    } catch (error) {
      console.error('Error saving vote:', error);
    }
  }

  static saveVotes(votes) {
    try {
      localStorage.setItem(this.STORAGE_KEYS.VOTES, JSON.stringify(votes));
    } catch (error) {
      console.error('Error saving votes:', error);
    }
  }

  static clearAll() {
    try {
      localStorage.clear();
      this.initializeIfNeeded();
      console.log('Storage cleared and reinitialized');
    } catch (error) {
      console.error('Error clearing storage:', error);
    }
  }
}