# Requirements Document

## Introduction

GepreKu adalah ekosistem restoran digital berbasis Flutter yang menyediakan pengalaman 3D immersive untuk pelanggan, sistem display dapur untuk tim operasional, dan dashboard manajemen untuk pemilik multi-outlet. Sistem ini mengintegrasikan pemesanan real-time, manajemen inventori, dan pengalaman interaktif 3D untuk meningkatkan efisiensi operasional dan kepuasan pelanggan.

## Glossary

- **Customer_App**: Aplikasi mobile Flutter untuk pelanggan yang menyediakan antarmuka pemesanan dengan elemen 3D interaktif
- **KDS**: Kitchen Display System - sistem display untuk tim dapur yang menampilkan pesanan real-time
- **Owner_Dashboard**: Dashboard manajemen untuk pemilik restoran yang mengelola multi-outlet
- **3D_Model**: Representasi tiga dimensi dari objek menu atau karakter yang dapat dirotasi dan diinteraksikan
- **Firestore**: Database real-time Firebase untuk sinkronisasi data
- **Hive**: Local storage untuk offline caching
- **QR_Scanner**: Komponen yang membaca QR code untuk identifikasi meja
- **Shared_Cart**: Keranjang belanja yang dapat diakses dan dimodifikasi oleh multiple pengguna secara bersamaan
- **Spice_Slider**: Kontrol interaktif untuk memilih tingkat kepedasan (1-10) dengan feedback visual 3D
- **Digital_Bell**: Fitur untuk memanggil pelayan dengan kategori permintaan spesifik
- **Batch_Cooking_Engine**: Komponen yang mengelompokkan pesanan serupa untuk efisiensi dapur
- **Inventory_Tracker**: Sistem yang melacak stok produk secara real-time
- **Payment_Gateway**: Integrasi dengan Midtrans/Xendit untuk pemrosesan pembayaran
- **RBAC_Manager**: Role-Based Access Control manager untuk otorisasi pengguna
- **Thermal_Printer**: Printer ESC/POS yang terhubung via Bluetooth
- **Geopoint**: Koordinat geografis (latitude, longitude) untuk lokasi outlet
- **StreamProvider**: Riverpod provider yang menyediakan data real-time dari Firestore
- **Optimistic_UI**: Teknik UI yang menampilkan perubahan sebelum konfirmasi server
- **Skeleton_Loader**: Placeholder animasi yang ditampilkan saat loading konten

## Requirements

### Requirement 1: 3D Hero Carousel Display

**User Story:** Sebagai pelanggan, saya ingin melihat 5 menu Best Seller dalam carousel 3D yang interaktif, sehingga saya dapat mengeksplorasi produk dengan pengalaman visual yang menarik.

#### Acceptance Criteria

1. THE Customer_App SHALL display a carousel containing exactly 5 3D_Models of best-selling menu items
2. WHEN a user swipes the carousel, THE Customer_App SHALL rotate to the next 3D_Model with smooth animation within 300ms
3. WHEN a user touches a 3D_Model, THE Customer_App SHALL allow 360-degree rotation via drag gesture
4. THE Customer_App SHALL load 3D_Models from model_3d_url field in Firestore products collection
5. WHEN a 3D_Model fails to load, THE Customer_App SHALL display a fallback 2D image from the same product record
6. THE Customer_App SHALL determine best sellers by sorting products by sales_count field in descending order
7. WHEN the carousel is displayed, THE Customer_App SHALL preload adjacent 3D_Models to ensure smooth transitions

### Requirement 2: Interactive Spice Level Selection

**User Story:** Sebagai pelanggan, saya ingin memilih tingkat kepedasan dengan slider interaktif yang menampilkan mascot cabai 3D, sehingga saya dapat menyesuaikan pesanan sesuai preferensi saya dengan cara yang menyenangkan.

#### Acceptance Criteria

1. WHEN a user selects a spicy menu item, THE Customer_App SHALL display a Spice_Slider with range 1 to 10
2. WHEN the slider value changes, THE Customer_App SHALL update the 3D chili mascot expression within 100ms to reflect the spice level
3. THE Customer_App SHALL store the selected spice level (1-10) in the order item metadata
4. THE Customer_App SHALL display 10 distinct 3D mascot expressions corresponding to spice levels 1 through 10
5. WHEN a user confirms the spice level, THE Customer_App SHALL include the spice_level value in the order document sent to Firestore

### Requirement 3: QR-Based Table Identification

**User Story:** Sebagai pelanggan yang makan di tempat, saya ingin memindai QR code di meja untuk otomatis teridentifikasi, sehingga pesanan saya terhubung dengan nomor meja yang benar.

#### Acceptance Criteria

1. WHEN a user scans a QR code, THE QR_Scanner SHALL extract the table_id and outlet_id from the QR payload
2. THE Customer_App SHALL validate that the outlet_id exists in the outlets collection before proceeding
3. WHEN table identification succeeds, THE Customer_App SHALL store table_id and outlet_id in the active session
4. WHEN an order is placed, THE Customer_App SHALL include the table_id in the order document
5. IF the QR code format is invalid, THEN THE Customer_App SHALL display an error message "QR Code tidak valid"
6. THE Customer_App SHALL support QR codes containing JSON format: {"outlet_id": "string", "table_id": "string"}

### Requirement 4: Group Order with Shared Cart

**User Story:** Sebagai pelanggan yang makan bersama teman, saya ingin berbagi keranjang belanja secara real-time, sehingga semua orang dapat menambahkan pesanan mereka sendiri.

#### Acceptance Criteria

1. WHEN a user creates a group order, THE Customer_App SHALL generate a unique shared_cart_id and store it in Firestore
2. WHEN another user joins via shared link or QR, THE Customer_App SHALL subscribe to the Shared_Cart using StreamProvider
3. WHEN any user adds an item to the Shared_Cart, THE Customer_App SHALL update Firestore and all connected clients SHALL receive the update within 2 seconds
4. WHEN any user removes an item from the Shared_Cart, THE Customer_App SHALL update Firestore and reflect changes across all clients within 2 seconds
5. THE Customer_App SHALL display each cart item with the username of who added it
6. WHEN the cart owner submits the order, THE Customer_App SHALL convert the Shared_Cart to a single order document with all items
7. THE Customer_App SHALL prevent non-owner users from submitting the final order

### Requirement 5: AI-Powered Recommendations

**User Story:** Sebagai pelanggan, saya ingin menerima rekomendasi menu yang cerdas berdasarkan pesanan saya, sehingga saya dapat menemukan produk tambahan yang relevan.

#### Acceptance Criteria

1. WHEN a user adds an item to cart, THE Customer_App SHALL query Firestore for complementary products based on category and sales_count
2. THE Customer_App SHALL display up to 3 recommended products with 3D_Model previews
3. THE Customer_App SHALL prioritize recommendations from products with sales_count above the median
4. WHEN a user views the cart, THE Customer_App SHALL display upsell recommendations with a 3D character mascot
5. THE Customer_App SHALL track recommendation acceptance rate in Firestore analytics collection

### Requirement 6: Digital Bell Service

**User Story:** Sebagai pelanggan, saya ingin memanggil pelayan untuk permintaan tambahan tanpa harus melambaikan tangan, sehingga saya dapat mendapatkan layanan dengan cepat dan sopan.

#### Acceptance Criteria

1. THE Customer_App SHALL provide a Digital_Bell button accessible from the main order screen
2. WHEN a user taps the Digital_Bell, THE Customer_App SHALL display service categories: "Tisu", "Alat Makan", "Air", "Bantuan Lain"
3. WHEN a user selects a category, THE Customer_App SHALL create a service_request document in Firestore with table_id, outlet_id, category, and timestamp
4. THE KDS SHALL subscribe to service_request collection and display new requests within 2 seconds
5. WHEN staff marks a request as completed in KDS, THE Customer_App SHALL display a confirmation notification
6. THE Customer_App SHALL prevent duplicate requests by disabling the Digital_Bell for 30 seconds after submission

### Requirement 7: Customer Memory and Quick Reorder

**User Story:** Sebagai pelanggan yang kembali, saya ingin disambut dengan nama dan dapat memesan ulang pesanan favorit saya dengan cepat, sehingga pengalaman saya lebih personal dan efisien.

#### Acceptance Criteria

1. WHEN a returning user opens the Customer_App, THE Customer_App SHALL display "Welcome Back [username]" message
2. THE Customer_App SHALL query the user's last 5 completed orders from Firestore orders collection
3. THE Customer_App SHALL display a "Quick Reorder" section with the 3 most frequently ordered items
4. WHEN a user taps a quick reorder item, THE Customer_App SHALL add the item to cart with previously selected customizations
5. THE Customer_App SHALL calculate frequently ordered items by counting item occurrences across the user's order history

### Requirement 8: Kitchen Display System Order Management

**User Story:** Sebagai staff dapur, saya ingin melihat pesanan baru secara real-time dengan prioritas visual, sehingga saya dapat memasak dengan efisien dan tepat waktu.

#### Acceptance Criteria

1. THE KDS SHALL subscribe to Firestore orders collection filtered by status "Pending" and current outlet_id
2. WHEN a new order arrives, THE KDS SHALL display the order with items, table_id, and timestamp within 2 seconds
3. WHEN an order has been pending for more than 10 minutes, THE KDS SHALL apply a pulsating red border animation to the order card
4. WHEN staff taps an order, THE KDS SHALL update the order status to "Cooking" in Firestore
5. WHEN staff marks an order as ready, THE KDS SHALL update the order status to "Ready" and trigger a notification to the Customer_App
6. THE KDS SHALL display orders sorted by timestamp in ascending order (oldest first)

### Requirement 9: Batch Cooking Logic

**User Story:** Sebagai staff dapur, saya ingin pesanan dengan item yang sama dikelompokkan secara otomatis, sehingga saya dapat memasak secara batch dan meningkatkan efisiensi.

#### Acceptance Criteria

1. THE Batch_Cooking_Engine SHALL analyze all "Pending" orders and group items by product_id
2. WHEN multiple orders contain the same product_id, THE KDS SHALL display a batch summary showing "Item X: 5 portions across 3 orders"
3. THE KDS SHALL allow staff to mark entire batches as completed, which SHALL update all related orders to "Cooking" status
4. THE Batch_Cooking_Engine SHALL recalculate batches every 30 seconds or when a new order arrives
5. THE KDS SHALL display batch groups with visual indicators showing which orders are included

### Requirement 10: Real-Time Inventory Tracking

**User Story:** Sebagai sistem, saya ingin mengurangi stok produk secara otomatis saat pesanan dibuat, sehingga inventori selalu akurat dan mencegah overselling.

#### Acceptance Criteria

1. WHEN an order status changes to "Cooking", THE Inventory_Tracker SHALL decrement stock_quantity in Firestore products collection for each item
2. WHEN stock_quantity reaches zero, THE Customer_App SHALL mark the product as "Sold Out" and prevent new orders
3. THE Inventory_Tracker SHALL use Firestore transactions to ensure atomic stock updates
4. WHEN stock_quantity falls below 10, THE Owner_Dashboard SHALL display a low-stock warning
5. THE Inventory_Tracker SHALL log all stock changes in an inventory_log collection with timestamp, product_id, quantity_change, and reason

### Requirement 11: Thermal Printer Integration

**User Story:** Sebagai staff dapur, saya ingin mencetak pesanan ke thermal printer via Bluetooth, sehingga saya memiliki backup fisik untuk referensi.

#### Acceptance Criteria

1. WHEN an order status changes to "Cooking", THE KDS SHALL send the order data to the connected Thermal_Printer
2. THE KDS SHALL format the print output using ESC/POS commands with order_id, table_id, items, quantities, and special instructions
3. THE KDS SHALL support Bluetooth printer discovery and pairing within the app
4. IF the Thermal_Printer is offline, THEN THE KDS SHALL queue the print job and retry when connection is restored
5. THE KDS SHALL display printer connection status (Connected/Disconnected) in the settings panel

### Requirement 12: Multi-Outlet Store Locator

**User Story:** Sebagai pelanggan, saya ingin menemukan outlet terdekat menggunakan peta interaktif, sehingga saya dapat memilih lokasi yang paling nyaman.

#### Acceptance Criteria

1. THE Customer_App SHALL display a map using Google Maps API showing all outlets from the outlets collection
2. THE Customer_App SHALL retrieve the user's current location using device GPS
3. WHEN the map loads, THE Customer_App SHALL display outlet markers using custom 3D pin icons
4. WHEN a user taps an outlet marker, THE Customer_App SHALL display outlet details: name, address, operating hours, and distance from user
5. THE Customer_App SHALL calculate distance using the Geopoint field in the outlets collection and user's current location
6. THE Customer_App SHALL allow users to filter outlets by status "Open" or "Closed"
7. WHEN a user selects an outlet, THE Customer_App SHALL set the outlet_id for the current session

### Requirement 13: Per-Outlet Inventory Management

**User Story:** Sebagai pemilik restoran, saya ingin mengelola inventori setiap outlet secara independen, sehingga setiap lokasi dapat memiliki stok yang berbeda.

#### Acceptance Criteria

1. THE Owner_Dashboard SHALL display inventory grouped by outlet_id
2. WHEN the owner updates stock_quantity for a product at a specific outlet, THE Owner_Dashboard SHALL update the products collection with outlet-specific stock data
3. THE Owner_Dashboard SHALL support bulk stock updates via CSV import with columns: outlet_id, product_id, stock_quantity
4. THE Owner_Dashboard SHALL display real-time stock levels using StreamProvider subscriptions to Firestore
5. WHEN stock_quantity is updated, THE Owner_Dashboard SHALL log the change in inventory_log collection with user_id and timestamp

### Requirement 14: Payment Processing

**User Story:** Sebagai pelanggan, saya ingin membayar pesanan saya melalui berbagai metode pembayaran digital, sehingga saya memiliki fleksibilitas dalam bertransaksi.

#### Acceptance Criteria

1. WHEN a user proceeds to checkout, THE Customer_App SHALL display payment options: "Transfer Bank", "E-Wallet", "QRIS"
2. WHEN a user selects a payment method, THE Customer_App SHALL create a payment transaction via Payment_Gateway API
3. THE Customer_App SHALL receive payment status callbacks from Payment_Gateway and update order payment_status field to "Paid" or "Failed"
4. WHEN payment succeeds, THE Customer_App SHALL update order status to "Pending" and send the order to Firestore
5. WHEN payment fails, THE Customer_App SHALL display an error message and allow the user to retry
6. THE Customer_App SHALL store payment transaction_id in the order document for reconciliation

### Requirement 15: Role-Based Access Control

**User Story:** Sebagai sistem, saya ingin membatasi akses fitur berdasarkan peran pengguna, sehingga keamanan dan integritas data terjaga.

#### Acceptance Criteria

1. THE RBAC_Manager SHALL support three roles: "customer", "kitchen_staff", "owner"
2. WHEN a user authenticates via Firebase Auth, THE RBAC_Manager SHALL retrieve the user's role from Firestore users collection
3. THE Customer_App SHALL only be accessible to users with role "customer"
4. THE KDS SHALL only be accessible to users with role "kitchen_staff" or "owner"
5. THE Owner_Dashboard SHALL only be accessible to users with role "owner"
6. THE RBAC_Manager SHALL enforce Firestore security rules that prevent unauthorized read/write operations based on user role

### Requirement 16: Offline Mode with Local Caching

**User Story:** Sebagai pelanggan dengan koneksi internet tidak stabil, saya ingin tetap dapat melihat menu dan menyusun pesanan, sehingga pengalaman saya tidak terganggu.

#### Acceptance Criteria

1. WHEN the Customer_App detects no internet connection, THE Customer_App SHALL load product data from Hive local storage
2. THE Customer_App SHALL cache the products collection in Hive whenever data is fetched from Firestore
3. WHEN a user adds items to cart while offline, THE Customer_App SHALL store the cart in Hive
4. WHEN internet connection is restored, THE Customer_App SHALL sync the cart to Firestore and proceed with order submission
5. THE Customer_App SHALL display an offline indicator banner when operating in offline mode
6. THE Customer_App SHALL prevent order submission while offline and display message "Pesanan akan dikirim saat koneksi tersedia"

### Requirement 17: Optimistic UI Updates

**User Story:** Sebagai pelanggan, saya ingin melihat perubahan UI secara instan saat saya berinteraksi, sehingga aplikasi terasa responsif meskipun menunggu konfirmasi server.

#### Acceptance Criteria

1. WHEN a user adds an item to cart, THE Customer_App SHALL immediately update the cart UI before Firestore write completes
2. WHEN a user removes an item from cart, THE Customer_App SHALL immediately update the cart UI before Firestore write completes
3. IF a Firestore write fails, THEN THE Customer_App SHALL revert the optimistic UI change and display an error message
4. THE Customer_App SHALL apply Optimistic_UI pattern to cart operations, favorite toggles, and spice level selections
5. WHEN an optimistic operation fails, THE Customer_App SHALL log the error to Firestore error_log collection

### Requirement 18: Skeleton Loading States

**User Story:** Sebagai pelanggan, saya ingin melihat placeholder animasi saat konten sedang dimuat, sehingga saya tahu aplikasi sedang bekerja dan tidak mengalami freeze.

#### Acceptance Criteria

1. WHEN the Customer_App loads the product list, THE Customer_App SHALL display Skeleton_Loader placeholders until data arrives
2. WHEN the 3D_Model is loading, THE Customer_App SHALL display a rotating skeleton placeholder with shimmer effect
3. THE Customer_App SHALL replace Skeleton_Loader with actual content within 100ms of data arrival
4. THE Customer_App SHALL use Skeleton_Loader for: product lists, 3D carousel, order history, and outlet map
5. THE Skeleton_Loader SHALL match the layout dimensions of the actual content to prevent layout shift

### Requirement 19: 3D Micro-Animations

**User Story:** Sebagai pelanggan, saya ingin melihat animasi 3D yang halus saat berinteraksi dengan elemen UI, sehingga pengalaman saya lebih engaging dan premium.

#### Acceptance Criteria

1. WHEN a user taps an "Add to Cart" button, THE Customer_App SHALL play a 3D pop animation with scale effect from 1.0 to 1.2 to 1.0 over 300ms
2. WHEN a user taps a neumorphic button, THE Customer_App SHALL animate the shadow depth to create a pressed effect
3. WHEN a product is added to cart, THE Customer_App SHALL animate a 3D cart icon with bounce effect
4. THE Customer_App SHALL use Rive animations for character mascot expressions and transitions
5. THE Customer_App SHALL limit animation frame rate to 60fps to ensure smooth performance on mid-range devices

### Requirement 20: Real-Time Order Sync Across Outlets

**User Story:** Sebagai pemilik restoran, saya ingin melihat pesanan dari semua outlet secara real-time, sehingga saya dapat memantau operasional bisnis saya.

#### Acceptance Criteria

1. THE Owner_Dashboard SHALL subscribe to Firestore orders collection across all outlets using StreamProvider
2. THE Owner_Dashboard SHALL display orders grouped by outlet_id with real-time updates
3. WHEN a new order is created at any outlet, THE Owner_Dashboard SHALL display the order within 2 seconds
4. THE Owner_Dashboard SHALL display order statistics: total orders, total revenue, average order value per outlet
5. THE Owner_Dashboard SHALL allow filtering orders by outlet_id, status, and date range
6. THE Owner_Dashboard SHALL display a real-time chart showing order volume per outlet updated every 5 seconds

## Notes

- Semua 3D models harus dioptimasi untuk mobile (target <2MB per model, <10k polygons)
- Firestore security rules harus dikonfigurasi sesuai RBAC requirements
- Payment gateway integration memerlukan merchant account setup dengan Midtrans atau Xendit
- Google Maps API key harus dikonfigurasi dengan restrictions untuk keamanan
- Thermal printer harus mendukung ESC/POS protocol dan Bluetooth 4.0+
- Offline mode terbatas pada read operations; write operations memerlukan koneksi internet
- 3D animations harus di-test pada device dengan spesifikasi minimum (Android 8.0, 2GB RAM)
