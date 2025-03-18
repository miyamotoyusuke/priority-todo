# Priority Todo

A Flutter todo application with priority management features.

## Getting Started

This project uses Firebase for backend services. To set up the project locally, follow these steps:

### Prerequisites

- Flutter SDK
- Firebase account
- Android Studio or Xcode (for mobile development)

### Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android and/or iOS apps to your Firebase project
3. Download the configuration files:
   - For Android: `google-services.json` and place it in `android/app/`
   - For iOS: `GoogleService-Info.plist` and place it in `ios/Runner/`
4. Create a `firebase.json` file in the root directory with your Firebase configuration

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```
# Firebase Configuration
FIREBASE_IOS_API_KEY=your_ios_api_key
FIREBASE_IOS_APP_ID=your_ios_app_id
FIREBASE_IOS_MESSAGING_SENDER_ID=your_ios_messaging_sender_id
FIREBASE_IOS_PROJECT_ID=your_ios_project_id
FIREBASE_IOS_DATABASE_URL=your_ios_database_url
FIREBASE_IOS_STORAGE_BUCKET=your_ios_storage_bucket
FIREBASE_IOS_BUNDLE_ID=your_ios_bundle_id

FIREBASE_ANDROID_API_KEY=your_android_api_key
FIREBASE_ANDROID_APP_ID=your_android_app_id
FIREBASE_ANDROID_MESSAGING_SENDER_ID=your_android_messaging_sender_id
FIREBASE_ANDROID_PROJECT_ID=your_android_project_id
FIREBASE_ANDROID_DATABASE_URL=your_android_database_url
FIREBASE_ANDROID_STORAGE_BUCKET=your_android_storage_bucket
```

### Firebase Options

Create a `lib/firebase_options.dart` file based on the template in the repository, using the environment variables from your `.env` file.

### Installation

1. Clone the repository
2. Set up Firebase as described above
3. Install dependencies:
   ```
   flutter pub get
   ```
4. Run the app:
   ```
   flutter run
   ```

## Features

- Create and manage todos with priorities
- Set goals and track progress
- Organize tasks by priority
- Repeating tasks

## Security Note

The Firebase configuration files and environment variables contain sensitive information and should not be committed to public repositories. They are included in the `.gitignore` file to prevent accidental commits.
