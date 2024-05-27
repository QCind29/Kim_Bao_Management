# Store Management

This is a Flutter project that utilizes Firebase Realtime Database for storing data objects such as Products, Tasks, and Notes. It also integrates Firebase Authentication for user authentication.

## Features
Firebase Realtime Database: Stores data objects such as Products, Tasks, and Notes.
Firebase Authentication: Provides user authentication functionality.
Flutter UI: Beautifully designed user interface using Flutter widgets.

## Requirements
Flutter SDK
Firebase account
Firebase CLI
## Getting Started
To get started with this project, follow these steps: 
### 1. Clone the repository to your local machine:
```bash
git clone https://github.com/QCind29/Store_Management.git
cd Store_Management

```
or download and install APK file at APK directory:
APK/Storage_Management
### 2. Set up the Flutter project
Navigate to the project directory and install dependencies:
```bash
flutter pub get
```
### 3. Set up Firebase for your project:
#### Create a Firebase Project
##### 1. Go to the Firebase Console and create a new project.
##### 2. Anable Firebase Authentication and configure your preferred sign-in methods.  
##### 3. Set up Firebase Realtime Database and configure security rules according to your project's requirements.
##### 4. Add an Android and/or iOS app to your Firebase project and follow the setup instructions to download the google-services.json (for Android).
##### 5. Place these files in the appropriate directories in your Flutter project:
     android/app for google-services.json
#### Configure Firebase in Flutter
#### Android Configuration
##### 1. Open android/build.gradle and add the following classpath to the dependencies section:
    classpath 'com.google.gms:google-services:4.3.10'
##### 2. Open android/app/build.gradle and apply the Google services plugin at the bottom of the file:
    apply plugin: 'com.google.gms.google-services'
### 4. Update and run project:
Navigate to the project directory and update dependencies and run project:
```bash
cd Storage_Management
flutter pub get
flutter run
```
## Demo
- You can login with user account:
- *user@gmail.com*
- *123456789*
          - - Please do not edit, update or do anything.
          - - Thank you.

