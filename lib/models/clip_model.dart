class Clip {
  final String id;
  final String userId;
  final String videoUrl;
  int eloScore;
  final DateTime createdAt;
  final bool isOriginal;

  Clip({
    required this.id,
    required this.userId,
    required this.videoUrl,
    required this.eloScore,
    required this.createdAt,
    this.isOriginal = true,
  });

  factory Clip.fromJson(Map<String, dynamic> json) {
    return Clip(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      videoUrl: json['video_url'] as String,
      eloScore: json['elo_score'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      isOriginal: json['is_original'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'video_url': videoUrl,
      'elo_score': eloScore,
      'created_at': createdAt.toIso8601String(),
      'is_original': isOriginal,
    };
  }

  Clip copyWith({
    String? id,
    String? userId,
    String? videoUrl,
    int? eloScore,
    DateTime? createdAt,
    bool? isOriginal,
  }) {
    return Clip(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      videoUrl: videoUrl ?? this.videoUrl,
      eloScore: eloScore ?? this.eloScore,
      createdAt: createdAt ?? this.createdAt,
      isOriginal: isOriginal ?? this.isOriginal,
    );
  }
}
