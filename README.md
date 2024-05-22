# Store Management

This is a Flutter project that utilizes Firebase Realtime Database for storing data objects such as Products, Tasks, and Notes. It also integrates Firebase Authentication for user authentication.

## Features
Firebase Realtime Database: Stores data objects such as Products, Tasks, and Notes.
Firebase Authentication: Provides user authentication functionality.
Flutter UI: Beautifully designed user interface using Flutter widgets.

## Getting Started
To get started with this project, follow these steps:

1. Clone the repository to your local machine:

  git clone https://github.com/QCind29/Kim_Bao_Management.git
or download and install APK file:
APK/Storage_Management
  
3. Set up Firebase for your project:

  Create a Firebase project on the Firebase Console.
  Anable Firebase Authentication and configure your preferred sign-in methods.  
  Set up Firebase Realtime Database and configure security rules according to your project's requirements.
  
5. Add Firebase configuration to your Flutter project:
 
  Add the Firebase configuration files (google-services.json for Android and GoogleService-Info.plist for iOS) to your Flutter project's android/app and ios/Runner directories, respectively.
  
6. Install dependencies:

  flutter pub get
  
8. Run the app:
   
   flutter run
## Demo
You can install apk file at APK folder for trial. Login with qcuong account above.
Please do not edit, update or do anything.
Thank you.
  ## Project Structure
  flutter_firebase_project/
├── android/
├── ios/
├── lib/
│   ├── models/
│   │   ├── Product.dart
│   │   ├── Task.dart
│   │   └── Note.dart
│   ├── page/
│   │   ├── Product/
|   |   |   ├── Product_Page.dart
|   |   |   ├── Product_Edit_Page.dart
│   │   ├── Note/
|   |   |   ├── Note_Page.dart
|   |   |   ├── Note_Edit_Page.dart
│   │   ├── Task/
|   |   |   ├── Task_Page.dart
|   |   |   ├── Task_Edit_Page.dart
│   │   ├── Login/
|   |   |   ├── Login_Page.dart
│   │   ├── CheckAuthState.dart
│   ├── services/
│   │   ├── Auth_Service.dart
│   │   └── Product_Service.dart
|   |   |__ Note_Service.dart
|   |   |__ Task_Service.dart
│   ├── provider/
│   │   ├── Product_Provider.dart
│   │   ├── Task_Provider.dart
│   │   └── Note_Provider.dart
│   ├── widget/
│   │   ├── EmptyUI.dart
│   │   ├── LoadingUI.dart
│   │   ├── field.dart
│   │   └── image_button.dart
│   │   └── Notification.dart
│   │   └── Searchbar.dart
│   │   └── text_button.dart
│   │   └── UpdateFormDialog.dart
│   └── main.dart
│   └── theme.dart
│   └── Util.dart
├── test/
├── pubspec.yaml
└── README.md
