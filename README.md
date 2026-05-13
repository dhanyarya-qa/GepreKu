# GepreKu - Ultimate 3D AI Restaurant Ecosystem

GepreKu adalah ekosistem restoran digital berbasis Flutter yang dirancang untuk memberikan pengalaman "High-End" bagi pelanggan melalui interaksi **UI/UX 3D**. Sistem ini mengintegrasikan Pelanggan, Tim Dapur (KDS), dan Owner dalam satu aliran data real-time dengan dukungan multi-cabang (Multi-Outlet).

## 🚀 Features

### Customer App
- **3D Hero Carousel**: Menampilkan 5 menu Best Seller dalam carousel 3D interaktif
- **Interactive Spice Slider**: Slider level 1-10 dengan mascot cabai 3D yang berubah ekspresi
- **QR Table Mapping**: Auto-detect nomor meja melalui QR code
- **Group Order (Shared Cart)**: Sinkronisasi keranjang belanja real-time
- **AI Recommendations**: Upselling cerdas dengan karakter 3D
- **Digital Bell**: Panggil pelayan untuk permintaan tambahan
- **Customer Memory**: Welcome back dengan quick reorder
- **Offline Mode**: Caching dengan Hive untuk koneksi tidak stabil

### Kitchen Display System (KDS)
- **Real-time Order Display**: Pesanan baru muncul dalam <2 detik
- **Batch Cooking Logic**: Kelompokkan pesanan serupa untuk efisiensi
- **Visual Urgency**: Pulsating animation untuk pesanan >10 menit
- **Inventory Tracking**: Auto stock deduction
- **Thermal Printing**: ESC/POS via Bluetooth

### Owner Dashboard
- **Multi-Outlet Monitoring**: Real-time order tracking semua outlet
- **Inventory Management**: Per-outlet stock management
- **Analytics**: Order statistics dan revenue tracking
- **Bulk Updates**: CSV import untuk stock updates

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x (Dart)
- **State Management**: Riverpod 2.x
- **3D Rendering**: 
  - `model_viewer_plus` untuk 3D models (GLB/GLTF)
  - `rive` untuk character animations
- **Backend**: Firebase (Firestore, Auth, Cloud Functions, Storage)
- **Local Storage**: Hive
- **Maps**: Google Maps API
- **Payment**: Midtrans / Xendit
- **Printer**: ESC/POS Bluetooth

## 📁 Project Structure (Clean Architecture)

```
lib/
├── core/
│   ├── config/
│   │   ├── app_theme.dart
│   │   └── firebase_options.dart
│   └── router/
│       └── app_router.dart
├── data/
│   └── providers/
│       ├── auth_provider.dart
│       ├── product_provider.dart
│       └── service_request_provider.dart
├── domain/
│   └── entities/
│       ├── product.dart
│       ├── order.dart
│       ├── cart_item.dart
│       ├── shared_cart.dart
│       ├── outlet.dart
│       ├── service_request.dart
│       └── user.dart
└── presentation/
    ├── customer/
    │   ├── screens/
    │   │   ├── splash_screen.dart
    │   │   ├── home_screen.dart
    │   │   ├── qr_scanner_screen.dart
    │   │   ├── menu_screen.dart
    │   │   ├── cart_screen.dart
    │   │   ├── checkout_screen.dart
    │   │   ├── order_history_screen.dart
    │   │   └── store_locator_screen.dart
    │   └── widgets/
    │       ├── hero_carousel_3d.dart
    │       ├── product_3d_viewer.dart
    │       ├── product_card.dart
    │       ├── digital_bell_button.dart
    │       └── quick_reorder_section.dart
    ├── kds/
    │   └── screens/
    │       └── kds_home_screen.dart
    └── owner/
        └── screens/
            └── owner_dashboard_screen.dart
```

## 🔧 Setup Instructions

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- Firebase account
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/gepreku.git
cd gepreku
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Firestore, Authentication, Storage, and Cloud Functions
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`
   - Update `lib/core/config/firebase_options.dart` with your Firebase config

4. **Generate code**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. **Run the app**
```bash
flutter run
```

## 🔥 Firebase Configuration

### Firestore Collections

#### `products`
```json
{
  "id": "string",
  "name": "string",
  "description": "string",
  "category": "string",
  "price": "number",
  "model_3d_url": "string | null",
  "fallback_image_url": "string",
  "sales_count": "number",
  "is_spicy": "boolean",
  "stock_by_outlet": {
    "outlet_id": "number"
  },
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

#### `orders`
```json
{
  "id": "string",
  "outlet_id": "string",
  "table_id": "string | null",
  "user_id": "string",
  "items": "array",
  "total_amount": "number",
  "status": "enum",
  "payment_status": "enum",
  "payment_transaction_id": "string | null",
  "created_at": "timestamp",
  "updated_at": "timestamp"
}
```

### Firestore Indexes
Create these composite indexes in Firebase Console:
- `products`: `sales_count DESC`
- `orders`: `outlet_id ASC, status ASC, created_at ASC`
- `service_requests`: `outlet_id ASC, status ASC, created_at DESC`

### Security Rules
Deploy the security rules from `firestore.rules`:
```bash
firebase deploy --only firestore:rules
```

## 🎨 3D Assets

### Requirements
- Format: GLB or GLTF
- Max file size: 2MB per model
- Max polygons: 10,000
- Optimized for mobile rendering

### Asset Storage
Upload 3D models to Firebase Storage:
```
gs://your-bucket/3d_models/
  ├── product_001.glb
  ├── product_002.glb
  └── chili_mascot.riv
```

## 📱 QR Code Format

Table QR codes should contain JSON:
```json
{
  "outlet_id": "outlet_abc123",
  "table_id": "table_05"
}
```

Generate QR codes using any QR generator with this JSON format.

## 🔐 Authentication & RBAC

### User Roles
- **customer**: Access to Customer App
- **kitchen_staff**: Access to KDS
- **owner**: Access to Owner Dashboard

### Creating Users
Use Firebase Console or Cloud Functions to create users with custom claims:
```javascript
admin.auth().setCustomUserClaims(uid, { role: 'customer' });
```

## 🧪 Testing

Run tests:
```bash
flutter test
```

Run integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

## 📦 Build & Deploy

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web (Owner Dashboard)
```bash
flutter build web --release
```

## 🐛 Known Issues & Limitations

1. **3D Model Performance**: Requires device with minimum 2GB RAM and Android 8.0+
2. **Offline Mode**: Limited to read operations; write operations require internet
3. **Thermal Printer**: Requires Bluetooth 4.0+ and ESC/POS protocol support
4. **Payment Gateway**: Requires merchant account setup with Midtrans or Xendit

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Contributors

- Your Name - Initial work

## 📞 Support

For support, email aryatama0409@gmail.com or open an issue in this repository.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend infrastructure
- Rive for 2D/3D animation support
- Model Viewer Plus for 3D rendering capabilities
