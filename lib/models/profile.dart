class Profile {
  final String username;
  final int totalElo;
  final int wins;
  final int losses;
  final int rank;
  final int duelsCompleted;

  const Profile({
    required this.username,
    required this.totalElo,
    this.wins = 0,
    this.losses = 0,
    this.rank = 0,
    this.duelsCompleted = 0,
  });

  Profile copyWith({
    String? username,
    int? totalElo,
    int? wins,
    int? losses,
    int? rank,
    int? duelsCompleted,
  }) {
    return Profile(
      username: username ?? this.username,
      totalElo: totalElo ?? this.totalElo,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      rank: rank ?? this.rank,
      duelsCompleted: duelsCompleted ?? this.duelsCompleted,
    );
  }

  factory Profile.initial() {
    return const Profile(
      username: 'YOU',
      totalElo: 1200,
      wins: 0,
      losses: 0,
      rank: 0,
      duelsCompleted: 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'total_elo': totalElo,
      'wins': wins,
      'losses': losses,
      'rank': rank,
      'duels_completed': duelsCompleted,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      username: json['username'] as String,
      totalElo: json['total_elo'] as int,
      wins: json['wins'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      rank: json['rank'] as int? ?? 0,
      duelsCompleted: json['duels_completed'] as int? ?? 0,
    );
  }

  double get winRate {
    final total = wins + losses;
    if (total == 0) return 0.0;
    return (wins / total) * 100;
  }

  String get rankBadge {
    if (rank <= 1) return 'APEX';
    if (rank <= 3) return 'ELITE';
    if (rank <= 10) return 'VETERAN';
    return 'RISING';
  }

  @override
  String toString() {
    return 'Profile(username: $username, elo: $totalElo, rank: #$rank)';
  }
}
