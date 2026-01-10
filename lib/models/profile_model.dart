class Profile {
  final String id;
  final String username;
  int eloScore;
  final String? avatarUrl;
  final String badge;

  Profile({
    required this.id,
    required this.username,
    required this.eloScore,
    this.avatarUrl,
    this.badge = 'Rookie',
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      username: json['username'] as String,
      eloScore: json['elo_score'] as int? ?? 1000,
      avatarUrl: json['avatar_url'] as String?,
      badge: json['badge'] as String? ?? 'Rookie',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'elo_score': eloScore,
      'avatar_url': avatarUrl,
      'badge': badge,
    };
  }

  Profile copyWith({
    String? id,
    String? username,
    int? eloScore,
    String? avatarUrl,
    String? badge,
  }) {
    return Profile(
      id: id ?? this.id,
      username: username ?? this.username,
      eloScore: eloScore ?? this.eloScore,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      badge: badge ?? this.badge,
    );
  }

  String getBadgeForPercentile(double percentile) {
    if (percentile <= 1) return 'Elite 1%';
    if (percentile <= 5) return 'Top 5%';
    if (percentile <= 10) return 'Top 10%';
    if (percentile <= 25) return 'Rising Star';
    return 'Rookie';
  }
}
