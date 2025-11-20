class Camera {
  final String cameraId;
  final String name;
  final String rtspUrl;
  final DateTime createdAt;

  Camera({
    required this.cameraId,
    required this.name,
    required this.rtspUrl,
    required this.createdAt,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      cameraId: json['camera_id'] as String,
      name: json['name'] as String,
      rtspUrl: json['rtsp_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'camera_id': cameraId,
      'name': name,
      'rtsp_url': rtspUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Camera copyWith({
    String? cameraId,
    String? name,
    String? rtspUrl,
    DateTime? createdAt,
  }) {
    return Camera(
      cameraId: cameraId ?? this.cameraId,
      name: name ?? this.name,
      rtspUrl: rtspUrl ?? this.rtspUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class Device {
  final String deviceId;
  final String name;
  final String type;
  final String ipAddress;
  final String port;
  final String username;
  final String password;
  final DateTime createdAt;
  final List<Camera> cameras;

  Device({
    required this.deviceId,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.ipAddress,
    required this.port,
    required this.username,
    required this.password,
    required this.cameras,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      deviceId: json['device_id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      ipAddress: json['ip_address'],
      port: json['port'],
      username: json['username'],
      password: json['password'],
      cameras: json['cameras'] != null
          ? (json['cameras'] as List)
                .map((c) => Camera.fromJson(c as Map<String, dynamic>))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'device_id': deviceId,
      'name': name,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'ip_address': ipAddress,
      'port': port,
      'username': username,
      'password': password,
      'cameras': cameras.map((c) => c.toJson()).toList(),
    };
  }

  Device copyWith({
    String? deviceId,
    String? name,
    String? type,
    String? ipAddress,
    String? port,
    String? username,
    String? password,
    DateTime? createdAt,
    List<Camera>? cameras,
  }) {
    return Device(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      type: type ?? this.type,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      username: username ?? this.username,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      cameras: cameras ?? this.cameras,
    );
  }
}
