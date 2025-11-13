class Camera {
  final String cameraId;
  final String name;
  final String description;
  final String rtspUrl;
  final DateTime createdAt;

  Camera({
    required this.cameraId,
    required this.name,
    required this.description,
    required this.rtspUrl,
    required this.createdAt,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      cameraId: json['camera_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      rtspUrl: json['rtsp_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'camera_id': cameraId,
      'name': name,
      'description': description,
      'rtsp_url': rtspUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
