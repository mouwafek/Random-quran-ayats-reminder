# Quran Mobile App

Android mobile app made with Flutter, that reminds you of Quran with random ayats

## App screens

<img src="https://github.com/user-attachments/assets/4c8b3f69-fe8b-4ff9-8673-8d2ddceb3d96" width="300" height="600" alt="Loader-screen">

![Home-screen](https://github.com/user-attachments/assets/f4723108-407b-4592-a843-ca7ec3aa047b)

## Features

- **Quran display**

  - Display of quran random ayats
  - English and arabic translation
  - Set liked ayah as favourite

- **Collection of favourite ayats**

  - Display all liked quran ayats

## Installation

### Prerequisites

- Flutter sdk 3.24.5
- Android Studio (for Android development)

### Setup Instructions

1. Clone the repository:

```bash
git clone https://github.com/mouwafek/Random-quran-ayats-reminder
cd Random-quran-ayats-reminder
```

2. Install dependencies:

```bash
pub get
```

3. Run the application:

```bash
flutter run
```

## Project Structure

```
Random-quran-ayats-reminder/
lib/
├── main.dart
├── models/
│   └── quran_ayah.dart
├── providers/
│   └── quran_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── generator_screen.dart
│   └── favorites_screen.dart
├── services/
│   └── api_service.dart
└── widgets/
    ├── ayah_card.dart
    ├── action_buttons.dart
    └── navigation_handler.dart


```
