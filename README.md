# EyeOn AI Frontend

A Flutter application for AI-powered security monitoring and surveillance.

## Features

- **Dashboard**: Overview of security status and system metrics
- **Chat Agent**: AI-powered assistant for security monitoring and queries
- **Events**: View and manage security events and activities
- **Cameras**: Monitor and control security cameras
- **Alerts**: Receive and manage security alerts and notifications
- **Settings**: Configure application preferences and system settings

## Getting Started

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK (version 2.19 or higher)
- Android Studio or VS Code with Flutter extensions

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/eyeon_ai_frontend.git
   cd eyeon_ai_frontend
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```

#### iOS (on macOS)
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

## Project Structure

```
lib/
├── app.dart                 # Main app configuration and routing
├── main.dart               # App entry point
├── controllers/            # State management controllers
│   ├── auth_controller.dart
│   ├── chat_controller.dart
│   ├── cameras_controller.dart
│   ├── events_controller.dart
│   └── alerts_controller.dart
├── models/                 # Data models
│   ├── message.dart
│   ├── camera.dart
│   ├── event.dart
│   └── alert.dart
├── screens/                # UI screens
│   ├── auth_screen.dart
│   ├── dashboard_screen.dart
│   ├── chat_screen.dart
│   ├── cameras_screen.dart
│   ├── events_screen.dart
│   ├── alerts_screen.dart
│   └── settings_screen.dart
├── services/               # Business logic and API services
│   ├── websocket_service.dart
│   └── supabase_service.dart
├── utils/                  # Utilities and constants
│   ├── app_constants.dart
│   └── theme_constants.dart
└── widgets/                # Reusable UI components
    ├── custom_button.dart
    ├── custom_text_field.dart
    └── custom_drawer.dart
```

## Architecture

This app follows the MVVM (Model-View-ViewModel) architecture pattern:

- **Models**: Represent data structures and business logic
- **Views**: UI components and screens
- **ViewModels/Controllers**: Handle state management and user interactions

## Dependencies

- `provider`: State management
- `supabase_flutter`: Backend services
- `flutter/material.dart`: UI framework

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For support, email support@eyeonai.com or join our Discord community.
