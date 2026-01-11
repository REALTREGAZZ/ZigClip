class Clip {
  final String id;
  final String username;
  final int eloScore;
  final String videoPath;
  final int wins;
  final int losses;

  const Clip({
    required this.id,
    required this.username,
    required this.eloScore,
    required this.videoPath,
    this.wins = 0,
    this.losses = 0,
  });

  Clip copyWith({
    String? id,
    String? username,
    int? eloScore,
    String? videoPath,
    int? wins,
    int? losses,
  }) {
    return Clip(
      id: id ?? this.id,
      username: username ?? this.username,
      eloScore: eloScore ?? this.eloScore,
      videoPath: videoPath ?? this.videoPath,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'elo_score': eloScore,
      'video_path': videoPath,
      'wins': wins,
      'losses': losses,
    };
  }

  factory Clip.fromJson(Map<String, dynamic> json) {
    return Clip(
      id: json['id'] as String,
      username: json['username'] as String,
      eloScore: json['elo_score'] as int,
      videoPath: json['video_path'] as String,
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
    );
  }

  double get winRate {
    final total = wins + losses;
    if (total == 0) return 0.0;
    return wins / total;
  }

  @override
  String toString() {
    return 'Clip(id: $id, username: $username, elo: $eloScore, W/L: $wins/$losses)';
  }
}
