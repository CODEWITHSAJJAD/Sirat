Noor Pakistan – Islamic Companion App

1. Project Overview

Noor Pakistan is a Flutter-based Islamic lifestyle and productivity mobile application designed specifically for Pakistani Muslims.

The app will support both:

Ramazan usage

Non-Ramazan daily usage

It must work offline-first and be optimized for low-end Android devices.

2. Target Audience

Pakistani Muslims

Hanafi fiqh majority

Urdu & English users

Age group: 15–60

Low to mid-range Android devices

3. Technical Stack

Frontend:

Flutter (latest stable)

State Management:

Riverpod or Provider (Agent can choose best scalable option)

Local Database:

Hive (Primary storage)

SharedPreferences (Settings only)

Location:

Geolocator package

Prayer Time Calculation:

Adhan Dart package (Hanafi method default)

Hijri Calendar:

Hijri package (adjustable)

Notifications:

Flutter Local Notifications

Architecture:

Clean Architecture (Feature-based folder structure)

Modular

Scalable

4. Core Features
4.1 Prayer Times Module

Features:

Auto-detect location

Manual city selection (Major Pakistani cities)

Hanafi calculation method default

Manual minute offset adjustment

Next prayer countdown timer

Azan notification

Highlight current prayer

Data to store:

Selected city

Calculation method

Offset adjustments

Notification preferences

4.2 Namaz Streak Module 🔥

Features:

5 daily prayer checkboxes:

Fajr

Dhuhr

Asr

Maghrib

Isha

If all 5 completed → full-day streak

Missed day resets streak (optional toggle)

Current streak

Longest streak

Monthly performance analytics

Motivational Islamic quote on streak increase

Database fields:

Date

Each prayer completion (bool)

Daily completed status

Current streak counter

Longest streak

4.3 Tasbeeh Counter Module 📿

Features:

Manual counter

Vibration toggle

Sound toggle

Preset tasbeeh sets:

33/33/34

Custom tasbeeh with custom target

Save tasbeeh history

Daily tasbeeh statistics

Database:

Tasbeeh name

Target count

Current count

Date

Completed (bool)

4.4 Ramazan Mode 🌙

Automatically activates during Ramadan (Hijri detection).

Features:

Sehr & Iftar timings

Countdown timer

Roza completion toggle

Roza streak counter

Ramazan calendar view

Taraweeh tracker

Database:

Ramazan date

Roza completed (bool)

Taraweeh completed (bool)

Roza streak

Longest roza streak

4.5 Roza Streak System 🌙🔥

Features:

Daily fast marking

Current Ramazan streak

Lifetime fast count

Badge system:

7 days

15 days

30 days

4.6 Islamic Lunar Calendar 📅

Features:

Hijri + Gregorian dual display

Highlight Islamic events

Manual moon adjustment (+/- 1 day)

Pakistan-based Islamic holidays

Event reminders

4.7 Zakat Calculator 💰

Features:

Gold nisab PKR calculation

Silver nisab PKR calculation

Assets input:

Cash

Gold

Silver

Business

Auto calculate 2.5%

Save yearly record

4.8 Daily Islamic Content

Features:

Daily Ayah

Daily Hadith

Daily Dua

Share functionality

Offline static JSON dataset required.

5. UI/UX Requirements

Theme:

Dark emerald + gold accent

Islamic geometric minimal design

Clean card-based UI

Responsive for small screens

Smooth animations

Lightweight

Home Dashboard must show:

Current Hijri date

Next prayer

Namaz streak

Roza streak (in Ramazan)

Daily ayah

6. Non-Functional Requirements

Offline-first

Low battery usage

Optimized for 2GB RAM devices

No heavy background services

Clean error handling

Null safety

Scalable architecture

7. Future Scalability

Architecture must allow:

Adding AI Islamic Q&A

Cloud sync

Multi-language expansion

Premium subscription model

8. Deliverables

Clean Flutter project

Modular structure

Well-documented code

No hardcoded logic

Configurable constants

Production-ready
