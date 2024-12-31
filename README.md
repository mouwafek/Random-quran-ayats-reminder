# Quran mobile application

Android / Ios mobile app that reminds you of Quran with random ayats

## Getting Started

This mobile app helps to remember Quran with random ayats

Api for Arabic version:
http://api.alquran.cloud/v1/quran/quran-uthmani

Api for English translation:
http://api.alquran.cloud/v1/quran/en.asad

## App screens

# Quran Mobile App

Android mobile app made with Flutter, that reminds you of Quran with random ayats

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
