# Booking App

A Flutter hotel booking app built as a learning project. It follows the early UI stages of [Shivam Gupta's tutorial](https://www.youtube.com/watch?v=04k2G18ozPw). This repository contains independently written code.

## Current milestone: UI shells

- Home screen with a local image and a featured stay card.
- Hotel details screen with placeholder information and amenities.
- Sign-up screen with name, email, and password fields.
- Navigation from Home to both new screens.
- Booking and sign-up actions are disabled until their services exist.

The tutorial reaches Firebase setup around 1:43:40 and package installation around 1:48:18. That is approximately 30% of its running time. These UI shells prepare for that stage, but **Firebase is not configured yet**. No account is created and no booking is stored.

## Run

Install the Flutter SDK, then run:

```sh
flutter pub get
flutter run
```

The local image is stored in `images/` and declared in `pubspec.yaml`.

## Next implementation stage

1. Create your own Firebase project and register the Android and iOS apps.
2. Configure FlutterFire for this project and add the generated options file locally.
3. Add Firebase packages, initialize Firebase, and implement authentication.
4. Connect hotel data and bookings to the backend.

Do not commit API secrets or private service credentials.
