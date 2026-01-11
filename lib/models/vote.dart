class Vote {
  final String clip1Id;
  final String clip2Id;
  final String winnerId;
  final int eloDelta;
  final DateTime timestamp;

  const Vote({
    required this.clip1Id,
    required this.clip2Id,
    required this.winnerId,
    required this.eloDelta,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'clip1_id': clip1Id,
      'clip2_id': clip2Id,
      'winner_id': winnerId,
      'elo_delta': eloDelta,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      clip1Id: json['clip1_id'] as String,
      clip2Id: json['clip2_id'] as String,
      winnerId: json['winner_id'] as String,
      eloDelta: json['elo_delta'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  String get loserId {
    return winnerId == clip1Id ? clip2Id : clip1Id;
  }

  @override
  String toString() {
    return 'Vote(winner: $winnerId, delta: $eloDelta, at: $timestamp)';
  }
}
