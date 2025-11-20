class Settings {
  final String name;
  final String email;
  final String contactNumber;
  final bool shouldCall;
  final bool shouldSms;
  final bool shouldEmail;

  Settings({
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.shouldCall,
    required this.shouldSms,
    required this.shouldEmail,
  });
}
