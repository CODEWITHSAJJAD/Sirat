# Sirat - Islamic Companion App

<div align="center">

![Version](https://img.shields.io/badge/version-1.0.0-blue)
![Platform](https://img.shields.io/badge/platform-Android-green)
![Flutter](https://img.shields.io/badge/Flutter-3.5.0+-blue)
![License](https://img.shields.io/badge/license-MIT-orange)

**Your Daily Journey Towards Sirat al-Mustaqeem**

A comprehensive Islamic companion app for Muslims, featuring prayer times, Ramadan tracking, tasbeeh counter, Zakat calculator, and more.

</div>

---

## Features

### 🕌 Prayer Times
- Accurate prayer times based on your location
- Auto-detect city or manual selection
- Next prayer countdown timer
- Azan notifications
- Per-prayer time offsets

### 🌙 Ramadan Tracker
- Automatic Ramadan detection based on Hijri calendar
- Sehr/Iftar countdown timers
- Daily roza (fasting) tracking
- Taraweeh prayer tracking
- Streak calculation (current & longest)
- Achievement badges (7 days, 15 days, full month)
- Moon sighting adjustment for Pakistan region

### 📿 Tasbeeh Counter
- 7 preset dhikr options with targets
- Custom tasbeeh creation
- Editable targets for all zikrs
- Progress tracking with circular indicator
- Haptic feedback on tap

### 📅 Islamic Calendar
- Dual date display (Gregorian + Hijri)
- Moon sighting adjustment (+1 day for Pakistan)
- Islamic events highlighting
- Pakistani Islamic holidays list

### 💰 Zakat Calculator
- Calculate Zakat on gold, silver, and cash
- Track nisab threshold (PKR 87,249 for 2024)
- Save Zakat payment history
- Year-over-year tracking

### 📖 Daily Content
- Ayah of the day from Quran
- Hadith of the day
- Morning and evening Duas

### 🔔 Notifications
- Prayer time Azan notifications
- Sehr/Iftar reminders during Ramadan
- Islamic event reminders

---

## Technical Architecture

### Clean Architecture
```
lib/
├── core/
│   ├── constants/       # App constants
│   ├── di/             # Dependency injection (Provider)
│   ├── errors/         # Error handling
│   ├── navigation/     # GoRouter setup
│   ├── theme/          # App theming
│   └── utils/          # Utilities
├── features/
│   ├── daily_content/   # Daily Ayah/Hadith
│   ├── hijri_calendar/# Islamic calendar
│   ├── home/           # Home dashboard
│   ├── namaz_streak/   # Prayer streak tracking
│   ├── prayer/         # Prayer times
│   ├── ramazan/        # Ramadan tracker
│   ├── tasbeeh/        # Dhikr counter
│   └── zakat/          # Zakat calculator
└── services/           # Business logic services
```

### State Management
- **Provider** for dependency injection and state management
- **ChangeNotifier** for reactive UI updates

### Local Storage
- **Hive** for fast, type-safe local database
- **SharedPreferences** for settings and preferences

### Key Dependencies
| Package | Purpose |
|---------|---------|
| provider | State management |
| hive_flutter | Local database |
| adhan | Prayer time calculation |
| hijri | Islamic calendar |
| geolocator | GPS location |
| flutter_local_notifications | Push notifications |
| timezone | Notification scheduling |

---

## Installation

### Prerequisites
- Flutter SDK 3.5.0 or higher
- Android SDK
- Android device or emulator

### Build APK
```bash
# Clone the repository
cd islamic_companion

# Install dependencies
flutter pub get

# Build debug APK
flutter build apk --debug

# Build release APK
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/`

---

## Configuration

### Android Permissions
The app requires the following permissions:
- `ACCESS_FINE_LOCATION` - For prayer times based on location
- `ACCESS_COARSE_LOCATION` - City detection
- `VIBRATE` - Tasbeeh haptic feedback
- `POST_NOTIFICATIONS` - Prayer & Ramadan notifications
- `SCHEDULE_EXACT_ALARM` - Precise notification timing

### Moon Sighting Adjustment
For Pakistan region, the moon sighting is typically +1 day. Users can adjust in Islamic Calendar:
- **-1**: Subtract one day
- **0**: Default (calculated)
- **+1**: Add one day (Pakistan standard)

---

## Islamic Calculations

### Prayer Times
- Calculation method: Islamic Society of North America (ISNA)
- Asr calculation: Hanafi
- Fajr angle: 18°
- Isha angle: 18°

### Hijri Calendar
- Based on lunar calendar
- Day starts at Maghrib (sunset)
- Moon sighting adjustment available

### Zakat
- Nisab threshold: 87.249 grams of silver (PKR)
- Gold: 2.5% of wealth
- Cash: 2.5% of savings
- Business assets: 2.5% of inventory

---


## Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

### Reporting Bugs
1. Check existing issues
2. Create new issue with:
   - Device model
   - Android version
   - Steps to reproduce
   - Expected vs actual behavior

---

## License

This project is licensed under the MIT License.

---

## Acknowledgments

- Prayer times calculation: [Adhan](https://github.com/islamic-society/adhan-flutter)
- Hijri dates: [Hijri Package](https://pub.dev/packages/hijri)
- Islamic events: Pakistan-centric holidays

---

## Contact

For questions or suggestions:
- Email: chsajjadshahid@gmail.com
- instagram: https://www.instagram.com/suq00n_

---

<div align="center">

** JazakAllah Khair for using Sirat **

*May Allah guide us all to Sirat al-Mustaqeem* 🤲

</div>
