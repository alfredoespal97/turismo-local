class HereCredentials {
  final String appId;
  final String accessKeyId;
  final String accessKeySecret;

  const HereCredentials({
    this.appId = '',
    this.accessKeyId = '',
    this.accessKeySecret = '',
  });

  bool get isValid =>
      appId.isNotEmpty && accessKeyId.isNotEmpty && accessKeySecret.isNotEmpty;

  Map<String, String> toMap() => {
        'appId': appId,
        'accessKeyId': accessKeyId,
        'accessKeySecret': accessKeySecret,
      };

  factory HereCredentials.fromMap(Map<String, dynamic> map) {
    return HereCredentials(
      appId: map['appId'] as String? ?? '',
      accessKeyId: map['accessKeyId'] as String? ?? '',
      accessKeySecret: map['accessKeySecret'] as String? ?? '',
    );
  }
}
