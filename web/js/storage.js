class StorageService {
  static STORAGE_KEYS = {
    CLIPS: 'zigclip_clips',
    PROFILE: 'zigclip_profile',
    VOTES: 'zigclip_votes'
  };

  static initializeIfNeeded() {
    if (!localStorage.getItem(StorageService.STORAGE_KEYS.CLIPS)) {
      const initialClips = [
        { id: 1, username: 'APEX_PRED_1', elo: 2450, wins: 45, losses: 12, votes: [] },
        { id: 2, username: 'ELITE_PLAYER_2', elo: 2100, wins: 38, losses: 18, votes: [] },
        { id: 3, username: 'VETERAN_3', elo: 1850, wins: 32, losses: 25, votes: [] },
        { id: 4, username: 'RISING_STAR_4', elo: 1600, wins: 28, losses: 35, votes: [] },
        { id: 5, username: 'NEWBIE_5', elo: 1400, wins: 15, losses: 42, votes: [] }
      ];
      
      localStorage.setItem(StorageService.STORAGE_KEYS.CLIPS, JSON.stringify(initialClips));
    }

    if (!localStorage.getItem(StorageService.STORAGE_KEYS.PROFILE)) {
     const userProfile = {
       id: 'user',
       username: 'YOU',
       elo: 1800,
       wins: 25,
       losses: 15,
       duels_played: 40,
       votes: []
     };

     localStorage.setItem(StorageService.STORAGE_KEYS.PROFILE, JSON.stringify(userProfile));
    }

    if (!localStorage.getItem(StorageService.STORAGE_KEYS.VOTES)) {
      localStorage.setItem(StorageService.STORAGE_KEYS.VOTES, JSON.stringify([]));
    }
  }

  static loadClips() {
    return JSON.parse(localStorage.getItem(StorageService.STORAGE_KEYS.CLIPS));
  }

  static saveClips(clips) {
    localStorage.setItem(StorageService.STORAGE_KEYS.CLIPS, JSON.stringify(clips));
  }

  static loadProfile() {
    return JSON.parse(localStorage.getItem(StorageService.STORAGE_KEYS.PROFILE));
  }

  static saveProfile(profile) {
    localStorage.setItem(StorageService.STORAGE_KEYS.PROFILE, JSON.stringify(profile));
  }

  static loadVotes() {
    return JSON.parse(localStorage.getItem(StorageService.STORAGE_KEYS.VOTES));
  }

  static saveVote(vote) {
    const votes = StorageService.loadVotes();
    votes.push(vote);
    localStorage.setItem(StorageService.STORAGE_KEYS.VOTES, JSON.stringify(votes));
  }

  static saveVotes(votes) {
    localStorage.setItem(StorageService.STORAGE_KEYS.VOTES, JSON.stringify(votes));
  }

  static clearAll() {
    localStorage.clear();
    StorageService.initializeIfNeeded();
  }
}