# UTD Store - Salsabila Wali Datussyuhada

**Mata Kuliah:** Mobile Programming Lanjut  
**NIM:** 20123017  
**Nama:** Salsabila Wali Datussyuhada  
**Dosen:** Ir. Mamok Andri Senubekti, S.Kom., M.Kom.

---

<<<<<<< HEAD
## Analisis Logika Personal (Berdasarkan NIM 20123017)

| NIM | Digit Terakhir | Parity | Splash Delay | Label Produk |
|-----|---------------|--------|-------------|-------------|
| 20123017 | **7** | **Ganjil** | **7 detik** | **[Diskon 10%]** |

| NIM | 2 Digit Terakhir | Isolate Loop |
|-----|-----------------|-------------|
| 20123017 | **17** | **17 × 10.000.000 = 170.000.000 iterasi** |

---

## Arsitektur: Clean Architecture
=======
## Analisis Logika Personal (Berdasarkan NIM 20123017)

| NIM      | Digit Terakhir | Parity | Splash Delay| Label Produk |
|----------|----------------|--------|-------------|--------------|
| 20123017 |        7       | Ganjil |   7 detik   | [Diskon 10%] |

|    NIM   | 2 Digit Terakhir |                 Isolate Loop              |
|----------|------------------|-------------------------------------------|
| 20123017 |         17       | **17 × 10.000.000 = 170.000.000 iterasi** |

---

## Arsitektur: Clean Architecture
>>>>>>> fba67f8481eee2ed4e5aa6739913c42b39d80007

```
lib/
├── core/               # Infrastruktur (DI, Router, Network)
<<<<<<< HEAD
│   ├── di/             → injection.dart (GetIt)
│   ├── router/         → app_router.dart (GoRouter)
│   └── network/        → dio_client.dart (Dio + Interceptor)
│
├── domain/             # Business Logic (Pure Dart)
│   ├── entities/       → product_entity.dart
│   ├── repositories/   → abstract interfaces
│   └── usecases/       → get_products_usecase.dart, splash_service.dart
│
├── data/               # Implementasi (API, DB)
│   ├── models/         → product_model.dart, bookmark_model.dart (Isar)
│   ├── datasources/    → product_remote_datasource.dart, crypto_remote_datasource.dart
│   └── repositories/   → implementasi konkret
│
└── presentation/       # UI Layer
    ├── screens/        → splash, home, bookmark, crypto
    ├── widgets/        → product_card.dart
    └── cubits/         → product, bookmark, crypto cubits
=======
│   ├── di/              injection.dart (GetIt)
│   ├── router/          app_router.dart (GoRouter)
│   └── network/         dio_client.dart (Dio + Interceptor)
│
├── domain/             # Business Logic (Pure Dart)
│   ├── entities/        product_entity.dart
│   ├── repositories/    abstract interfaces
│   └── usecases/        get_products_usecase.dart, splash_service.dart
│
├── data/               # Implementasi (API, DB)
│   ├── models/          product_model.dart, bookmark_model.dart (Isar)
│   ├── datasources/     product_remote_datasource.dart, crypto_remote_datasource.dart
│   └── repositories/    implementasi konkret
│
└── presentation/       # UI Layer
    ├── screens/         splash, home, bookmark, crypto
    ├── widgets/         product_card.dart
    └── cubits/          product, bookmark, crypto cubits
>>>>>>> fba67f8481eee2ed4e5aa6739913c42b39d80007
```

---

<<<<<<< HEAD
## Logika Personal Per Fitur

### 1. Splash Screen
- **File:** `lib/domain/usecases/splash_service.dart`
- Delay = digit terakhir NIM = **7 detik**
- Logika delay di level Domain/Service, BUKAN di UI

### 2. Manipulasi Data Produk
- **File:** `lib/data/repositories/product_repository_impl.dart`
- Digit terakhir = 7 (Ganjil) → tambahkan **"[Diskon 10%]"** di belakang nama produk
=======
## Logika Personal Per Fitur

### 1. Splash Screen
- File: `lib/domain/usecases/splash_service.dart`
- Delay = digit terakhir NIM = 7 detik
- Logika delay di level Domain/Service, BUKAN di UI

### 2. Manipulasi Data Produk
- File: `lib/data/repositories/product_repository_impl.dart`
- Digit terakhir = 7 (Ganjil) → tambahkan "[Diskon 10%]" di belakang nama produk
>>>>>>> fba67f8481eee2ed4e5aa6739913c42b39d80007
- Dilakukan di layer Repository, BUKAN di Widget UI

### 3. Timestamp Bookmark
- **File:** `lib/data/models/bookmark_model.dart`
- Field `savedAt: DateTime` wajib ada di koleksi Isar
- Ditampilkan di UI dengan format **"Disimpan pada HH:mm"**

### 4. Isolate Crypto Tax
- **File:** `lib/presentation/cubits/crypto/crypto_cubit.dart`
- 2 digit terakhir NIM = **17** → loop **170.000.000 kali**
- Dijalankan di Isolate terpisah via `compute()` → animasi harga TIDAK FREEZE

### 5. Platform Channel
- **Dart:** `lib/presentation/screens/crypto/crypto_screen.dart`
- **Kotlin:** `android/app/src/main/kotlin/.../MainActivity.kt`
- Channel: `com.utdstore.salsabila/native`
- Methods: `getBatteryLevel`, `showToast`

---

## Rencana Commit GitHub (Minimal 10 commit berbeda waktu)

```bash
# Commit 1 (Hari 1 pagi)
git commit -m "feat: setup clean architecture folder structure"

# Commit 2 (Hari 1 siang)
git commit -m "feat: add go_router and get_it dependency injection"

# Commit 3 (Hari 1 sore)
git commit -m "feat: add splash screen with 7s delay from SplashService NIM-based"

# Commit 4 (Hari 2 pagi)
git commit -m "feat: add dio client with pretty logger interceptor"

# Commit 5 (Hari 2 siang)
git commit -m "feat: add product cubit state management loading/loaded/error"

# Commit 6 (Hari 2 sore)
git commit -m "feat: add product repository with [Diskon 10%] label for odd NIM"

# Commit 7 (Hari 3 pagi)
git commit -m "feat: add isar database bookmark with savedAt timestamp"

# Commit 8 (Hari 3 siang)
git commit -m "feat: add reactive bookmark stream using isar watch()"

# Commit 9 (Hari 3 sore)
git commit -m "feat: add websocket bitcoin price and isolate compute tax 170M loops"

# Commit 10 (Hari 4)
git commit -m "feat: add platform channel kotlin for battery level and native toast"

# Commit 11 (Hari 4)
git commit -m "fix: isolate does not freeze bitcoin price animation"

# Commit 12 (Hari 4)
git commit -m "chore: build release apk and final cleanup"
```

---

##  Cara Menjalankan

```bash
# Install dependencies
flutter pub get

# Generate Isar schema (WAJIB sebelum run)
dart run build_runner build --delete-conflicting-outputs

# Run aplikasi
flutter run

# Build APK release
flutter build apk --release
```

---

##  Fitur Utama

1. Splash Screen → Nama + NIM + delay 7 detik
2. Katalog Produk → FakeStore API via Dio, semua produk bertuliskan "[Diskon 10%]"
3. Bookmark → Isar Database, reaktif real-time via watch(), ada timestamp
4. Crypto Hub → Bitcoin real-time via WebSocket CoinCap
5. Kalkulasi Pajak → Isolate compute 170 juta iterasi tanpa freeze UI
6. Native → Baca baterai + Toast Android via MethodChannel Kotlin
