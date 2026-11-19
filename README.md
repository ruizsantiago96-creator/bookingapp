# Booking App

A Flutter hotel booking app built as a learning project. It follows the early UI stages of [Shivam Gupta's tutorial](https://www.youtube.com/watch?v=04k2G18ozPw). This repository contains independently written code.

## Current milestone: UI shells

- Home screen with a local image and a featured stay card.
- Hotel details screen with placeholder information and amenities.
- Sign-up screen with name, email, and password fields.
- Navigation from Home to both new screens.
- Booking and sign-up actions are disabled until their services exist.

The tutorial reaches Firebase setup around 1:43:40 and package installation around 1:48:18. That is approximately 30% of its running time. This app now initializes the `bookingapp-ff02b` Firebase project on Android, web, and Windows. Authentication screens are still placeholders: no account is created and no booking is stored.

## Run

Install the Flutter SDK, then run:

```sh
flutter pub get
flutter run
```

The local image is stored in `images/` and declared in `pubspec.yaml`.

## Next implementation stage

1. Enable Email/Password in Firebase Authentication if it is not already enabled.
2. Connect the sign-up screen and add a login screen using `firebase_auth`.
3. Connect hotel data and bookings to the backend.
4. Run `flutterfire configure` again when adding iOS, macOS, or another Firebase service.

The generated Firebase app configuration contains public identifiers. Do not commit service-account keys or private credentials.
