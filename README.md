# Booking App

A Flutter hotel booking app built as a learning project. It follows the early UI stages of [Shivam Gupta's tutorial](https://www.youtube.com/watch?v=04k2G18ozPw). This repository contains independently written code.

## Current milestone: authentication and home

- Home screen with a local image and a featured stay card.
- Hotel details screen with placeholder information and amenities.
- Sign-up and sign-in with email and password through Firebase Authentication.
- Password reset email, form validation, and account error messages.
- Home responds to the current user and offers sign-out.
- Navigation from Home to hotel details and authentication.
- Booking remains disabled until its service exists.

This app initializes the `bookingapp-ff02b` Firebase project on Android, web, and Windows. Account creation and login use Firebase Authentication. No booking is stored yet.

## Run

Install the Flutter SDK, then run:

```sh
flutter pub get
flutter run
```

The local image is stored in `images/` and declared in `pubspec.yaml`.

In the [Firebase console](https://console.firebase.google.com/project/bookingapp-ff02b/authentication/providers), enable **Authentication → Sign-in method → Email/Password** before trying the forms. The **Users** page alone does not enable this provider.

## Next implementation stage

1. Connect hotel data and bookings to the backend.
2. Add email verification and any additional sign-in providers you need.
3. Run `flutterfire configure` again when adding iOS, macOS, or another Firebase service.

The generated Firebase app configuration contains public identifiers. Do not commit service-account keys or private credentials.
