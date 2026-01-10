class Vote {
  final String winnerId;
  final String loserId;
  final int eloDelta;
  final DateTime createdAt;

  Vote({
    required this.winnerId,
    required this.loserId,
    required this.eloDelta,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      winnerId: json['winner_id'] as String,
      loserId: json['loser_id'] as String,
      eloDelta: json['elo_delta'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'winner_id': winnerId,
      'loser_id': loserId,
      'elo_delta': eloDelta,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
