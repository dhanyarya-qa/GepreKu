# GepreKu - Setup Guide

Panduan lengkap untuk setup dan menjalankan aplikasi GepreKu.

## Prerequisites

Sebelum memulai, pastikan Anda sudah menginstall:

1. **Flutter SDK** (3.0 atau lebih tinggi)
   - Download dari: https://flutter.dev/docs/get-started/install
   - Verifikasi instalasi: `flutter --version`

2. **Dart SDK** (3.0 atau lebih tinggi)
   - Biasanya sudah termasuk dalam Flutter SDK

3. **Android Studio** atau **VS Code**
   - Android Studio: https://developer.android.com/studio
   - VS Code: https://code.visualstudio.com/

4. **Git**
   - Download dari: https://git-scm.com/downloads

5. **Firebase CLI** (opsional, untuk deployment)
   ```bash
   npm install -g firebase-tools
   ```

## Step 1: Clone Repository

```bash
git clone https://github.com/yourusername/gepreku.git
cd gepreku
```

## Step 2: Install Dependencies

```bash
flutter pub get
```

## Step 3: Firebase Setup

### 3.1 Create Firebase Project

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik "Add project" atau "Create a project"
3. Masukkan nama project: `gepreku-restaurant`
4. Ikuti wizard setup hingga selesai

### 3.2 Enable Firebase Services

Di Firebase Console, enable services berikut:

1. **Authentication**
   - Go to: Authentication > Sign-in method
   - Enable: Email/Password

2. **Firestore Database**
   - Go to: Firestore Database
   - Click "Create database"
   - Start in **test mode** (untuk development)
   - Choose location terdekat

3. **Storage**
   - Go to: Storage
   - Click "Get started"
   - Start in **test mode**

4. **Cloud Functions** (opsional)
   - Go to: Functions
   - Click "Get started"

### 3.3 Add Android App

1. Di Firebase Console, klik icon Android
2. Masukkan package name: `com.gepreku.app`
3. Download `google-services.json`
4. Copy file ke: `android/app/google-services.json`

### 3.4 Add iOS App (jika develop untuk iOS)

1. Di Firebase Console, klik icon iOS
2. Masukkan bundle ID: `com.gepreku.app`
3. Download `GoogleService-Info.plist`
4. Copy file ke: `ios/Runner/GoogleService-Info.plist`

### 3.5 Update Firebase Config

Edit file `lib/core/config/firebase_options.dart` dan update dengan config dari Firebase Console:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'YOUR_ANDROID_API_KEY',
  appId: 'YOUR_ANDROID_APP_ID',
  messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
  projectId: 'gepreku-restaurant',
  storageBucket: 'gepreku-restaurant.appspot.com',
);
```

## Step 4: Setup Firestore Collections

### 4.1 Create Collections

Di Firestore Console, buat collections berikut:

1. **products**
2. **orders**
3. **shared_carts**
4. **service_requests**
5. **outlets**
6. **users**
7. **inventory_log**

### 4.2 Add Sample Data

#### Sample Product:
```json
{
  "name": "Ayam Geprek Original",
  "description": "Ayam goreng crispy dengan sambal geprek level 1-10",
  "category": "Main Course",
  "price": 25000,
  "model_3d_url": null,
  "fallback_image_url": "https://example.com/ayam-geprek.jpg",
  "sales_count": 150,
  "is_spicy": true,
  "stock_by_outlet": {
    "outlet_001": 50
  },
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z"
}
```

#### Sample Outlet:
```json
{
  "name": "GepreKu Sudirman",
  "address": "Jl. Sudirman No. 123, Jakarta",
  "location": {
    "_latitude": -6.2088,
    "_longitude": 106.8456
  },
  "operating_hours": {
    "monday": {
      "open": "09:00",
      "close": "22:00"
    },
    "tuesday": {
      "open": "09:00",
      "close": "22:00"
    }
  },
  "status": "open",
  "created_at": "2024-01-01T00:00:00Z"
}
```

### 4.3 Setup Firestore Indexes

Di Firestore Console > Indexes, buat composite indexes:

1. **products**
   - Field: `sales_count` (Descending)

2. **orders**
   - Field: `outlet_id` (Ascending)
   - Field: `status` (Ascending)
   - Field: `created_at` (Ascending)

3. **service_requests**
   - Field: `outlet_id` (Ascending)
   - Field: `status` (Ascending)
   - Field: `created_at` (Descending)

### 4.4 Setup Security Rules

Copy security rules berikut ke Firestore Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    function isAuthenticated() {
      return request.auth != null;
    }
    
    function getUserRole() {
      return get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role;
    }
    
    match /products/{productId} {
      allow read: if isAuthenticated();
      allow write: if getUserRole() == 'owner';
    }
    
    match /orders/{orderId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if getUserRole() in ['kitchen_staff', 'owner'];
    }
    
    match /shared_carts/{cartId} {
      allow read, write: if isAuthenticated();
    }
    
    match /service_requests/{requestId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated();
      allow update: if getUserRole() in ['kitchen_staff', 'owner'];
    }
    
    match /outlets/{outletId} {
      allow read: if isAuthenticated();
      allow write: if getUserRole() == 'owner';
    }
    
    match /users/{userId} {
      allow read: if isAuthenticated();
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update: if isAuthenticated() && request.auth.uid == userId;
    }
  }
}
```

## Step 5: Generate Code

Generate code untuk Freezed dan JSON serialization:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Step 6: Setup Google Maps API (untuk Store Locator)

1. Buka [Google Cloud Console](https://console.cloud.google.com/)
2. Enable **Maps SDK for Android** dan **Maps SDK for iOS**
3. Create API Key
4. Update `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest>
  <application>
    <meta-data
      android:name="com.google.android.geo.API_KEY"
      android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
  </application>
</manifest>
```

5. Update `ios/Runner/AppDelegate.swift`:

```swift
import GoogleMaps

GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

## Step 7: Run the App

### Android

```bash
flutter run
```

### iOS (Mac only)

```bash
cd ios
pod install
cd ..
flutter run
```

### Web (Owner Dashboard)

```bash
flutter run -d chrome
```

## Step 8: Create Test User

Gunakan Firebase Console untuk membuat test user:

1. Go to: Authentication > Users
2. Click "Add user"
3. Email: `customer@test.com`
4. Password: `test123456`

Kemudian tambahkan user document di Firestore:

```json
{
  "id": "USER_UID_FROM_AUTH",
  "name": "Test Customer",
  "email": "customer@test.com",
  "phone": "+6281234567890",
  "role": "customer",
  "outlet_id": null,
  "created_at": "2024-01-01T00:00:00Z"
}
```

## Troubleshooting

### Error: "MissingPluginException"

```bash
flutter clean
flutter pub get
flutter run
```

### Error: "Gradle build failed"

Update `android/build.gradle`:

```gradle
buildscript {
    ext.kotlin_version = '1.9.0'
    dependencies {
        classpath 'com.android.tools.build:gradle:7.4.0'
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

### Error: "CocoaPods not installed"

```bash
sudo gem install cocoapods
pod setup
```

### Error: "Firebase not initialized"

Pastikan `google-services.json` (Android) dan `GoogleService-Info.plist` (iOS) sudah ada di lokasi yang benar.

## Next Steps

1. **Upload 3D Models**: Upload file GLB/GLTF ke Firebase Storage
2. **Setup Payment Gateway**: Daftar merchant account di Midtrans/Xendit
3. **Test QR Scanner**: Generate QR code dengan format JSON yang benar
4. **Deploy Cloud Functions**: Deploy business logic ke Firebase Functions

## Development Tips

1. **Hot Reload**: Tekan `r` di terminal untuk hot reload
2. **Hot Restart**: Tekan `R` di terminal untuk hot restart
3. **Debug Mode**: Gunakan VS Code debugger atau Android Studio debugger
4. **Logs**: Gunakan `flutter logs` untuk melihat logs real-time

## Production Deployment

### Android

```bash
flutter build apk --release
flutter build appbundle --release
```

Upload ke Google Play Console.

### iOS

```bash
flutter build ios --release
```

Upload ke App Store Connect via Xcode.

### Web

```bash
flutter build web --release
firebase deploy --only hosting
```

## Support

Jika mengalami masalah, buka issue di GitHub repository atau hubungi tim development.

---

**Happy Coding! 🚀**
