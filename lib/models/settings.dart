class Settings {
  final String name;
  final String email;
  final String contactNumber;
  final bool alertOnCall;
  final bool alertOnSms;
  final bool alertOnEmail;

  Settings({
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.alertOnCall,
    required this.alertOnSms,
    required this.alertOnEmail,
  });
  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      name: json['name'],
      email: json['email'],
      contactNumber: json['contact_number'],
      alertOnCall: json['alert_on_call'],
      alertOnSms: json['alert_on_sms'],
      alertOnEmail: json['alert_on_email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'contact_number': contactNumber,
      'alert_on_call': alertOnCall,
      'alert_on_sms': alertOnSms,
      'alert_on_email': alertOnEmail,
    };
  }

  Settings copyWith({
    String? name,
    String? email,
    String? contactNumber,
    bool? alertOnCall,
    bool? alertOnSms,
    bool? alertOnEmail,
  }) {
    return Settings(
      name: name ?? this.name,
      email: email ?? this.email,
      contactNumber: contactNumber ?? this.contactNumber,
      alertOnCall: alertOnCall ?? this.alertOnCall,
      alertOnSms: alertOnSms ?? this.alertOnSms,
      alertOnEmail: alertOnEmail ?? this.alertOnEmail,
    );
  }
}
