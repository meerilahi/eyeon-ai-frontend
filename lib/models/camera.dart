class Camera {
  final String id;
  final String name;
  final String rtspUrl;
  final DateTime createdAt;

  Camera({
    required this.id,
    required this.name,
    required this.rtspUrl,
    required this.createdAt,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      id: json['id'] as String,
      name: json['name'] as String,
      rtspUrl: json['rtsp_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rtsp_url': rtspUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
