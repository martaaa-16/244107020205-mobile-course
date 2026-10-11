# AI Challenge - Output Awal AI (Modul 07: Clean Architecture)

Dokumen ini memuat draf usulan teknis awal yang dihasilkan oleh AI coding assistant untuk refactoring proyek **campus_notify** ke arsitektur **Feature-First Clean Architecture**.

---

## 1. Usulan Struktur Direktori Feature-First Clean Architecture

```text
lib/
├── core/
│   ├── error/
│   │   ├── failure.dart                   # Definisi Failure & subclass (NetworkFailure, etc.)
│   │   └── api_errors.dart                # Mapper DioException -> user-friendly message
│   ├── network/
│   │   └── api_client.dart                # Instance Dio & auth interceptor
│   ├── routes/
│   │   └── routes.dart                    # Konfigurasi GoRouter & route helper
│   └── services/
│       └── push_service.dart              # Platform messaging & local notifications
│
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── auth_session.dart      # Pure Dart Entity (access & refresh token)
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart    # Abstract contract (Interface)
│   │   │   └── usecases/
│   │   │       └── login_usecase.dart     # (Opsional) Validasi format email institusi & password
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_data_source.dart # HTTP request Dio (POST /auth/login)
│   │   │   │   └── token_local_data_source.dart # FlutterSecureStorage storage
│   │   │   ├── models/
│   │   │   │   └── auth_session_model.dart     # Serialisasi JSON & mapping ke Entity
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart   # Implementasi AuthRepository konkret
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── login_page.dart             # UI form login
│   │       └── providers/
│   │           └── auth_providers.dart         # Riverpod Notifier & DI provider
│   │
│   ├── announcements/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── announcement.dart           # Pure Dart Entity (id, title, content, date)
│   │   │   └── repositories/
│   │   │       └── announcement_repository.dart# Abstract contract (Interface)
│   │   │   # (Catatan: Tanpa Use Case 1-baris untuk read-only CRUD)
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── announcement_remote_data_source.dart # HTTP request (GET /announcements)
│   │   │   ├── models/
│   │   │   │   └── announcement_model.dart     # fromJson & toMap
│   │   │   └── repositories/
│   │   │       └── announcement_repository_impl.dart # Implementasi konkret
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── home_page.dart              # Daftar pengumuman + banner FCM
│   │       │   └── announcement_detail_page.dart # Detail pengumuman
│   │       └── providers/
│   │           └── announcements_providers.dart# State list & detail pengumuman
│   │
│   └── notes/ (Praktikum 2 & 3)
│       ├── domain/
│       │   ├── entities/note.dart
│       │   ├── repositories/note_repository.dart
│       │   └── usecases/get_notes.dart, add_note.dart
│       ├── data/
│       │   ├── models/note_model.dart
│       │   └── repositories/note_repository_impl.dart
│       └── presentation/
│           ├── pages/notes_page.dart
│           └── providers/notes_providers.dart
│
└── main.dart
```

---

## 2. Pemetaan File Lama ke Tujuan Baru

| File Lama | Status | Tujuan Baru | Alasan Refactor |
| :--- | :---: | :--- | :--- |
| `lib/data/auth_repository.dart` | **Pecah & Pindah** | - `features/auth/domain/entities/auth_session.dart`<br>- `features/auth/domain/repositories/auth_repository.dart`<br>- `features/auth/data/models/auth_session_model.dart`<br>- `features/auth/data/repositories/auth_repository_impl.dart` | Kontrak `AuthRepository` dan data class `AuthSession` sebelumnya digabung dalam 1 file tanpa interface abstrak terpisah. Clean Architecture mengharuskan interface di domain dan implementasi di data. |
| `lib/data/token_store.dart` | **Pindah** | `features/auth/data/datasources/token_local_data_source.dart` | Berperan sebagai local data source berbasis `FlutterSecureStorage` untuk fitur auth. |
| `lib/data/api_client.dart` | **Pindah** | `core/network/api_client.dart` | Client HTTP Dio bersama (shared) yang dipakai lintas fitur di layer data. |
| `lib/data/api_errors.dart` | **Pindah** | `core/error/api_errors.dart` | Utilitas penerjemah `DioException` ke teks ramah pengguna bersifat cross-cutting. |
| `lib/providers/auth_provider.dart` | **Pecah & Pindah** | `features/auth/presentation/providers/auth_providers.dart` | Memisahkan DI manual dan state notifier agar terisolasi di presentation layer fitur auth. |
| `lib/providers/fcm_provider.dart` | **Pecah & Pindah** | - `core/network/api_client.dart` (`apiClientProvider`)<br>- `core/services/push_service.dart` (`fcmTokenProvider`) | `apiClientProvider` salah tempat karena dideklarasikan di file FCM. Harus dipisah ke shared core. |
| `lib/pages/login_page.dart` | **Pindah** | `features/auth/presentation/pages/login_page.dart` | Masuk ke presentation layer fitur auth. |
| `lib/pages/home_page.dart` | **Pecah & Pindah** | `features/announcements/presentation/pages/home_page.dart` | Mengganti data dummy statis di widget menjadi konsumsi `announcementsProvider`. |
| `lib/pages/announcement_page.dart` | **Pindah** | `features/announcements/presentation/pages/announcement_detail_page.dart` | Halaman detail pengumuman ditempatkan di presentation layer pengumuman. |
| `lib/messaging/push_service.dart` | **Pindah** | `core/services/push_service.dart` | Layanan infrastruktur notifikasi background/foreground level aplikasi. |
| `lib/routes.dart` | **Pindah** | `core/routes/routes.dart` | Konfigurasi rute GoRouter aplikasi diletakkan pada direktori core. |

---

## 3. Analisis Bagian Over-Engineering vs Kapan Use Case Dibutuhkan

### A. Over-Engineering pada CRUD Sederhana
Membuat class *Use Case* untuk operasi pengambilan data satu-baris (misal `GetAnnouncementsUseCase` yang hanya memanggil `_repo.getAnnouncements()`) adalah **Over-Engineering**:
- **Alasan**: Tidak ada logika bisnis, transformasi data, atau validasi yang dilakukan. Class tersebut hanya menjadi pembungkus redundan (*boilerplate passthrough*) yang menambah beban komputasi dan kompleksitas navigasi file.
- **Rekomendasi**: Notifier (State Provider) pada presentation layer dapat langsung mengonsumsi abstraksi `AnnouncementRepository`.

### B. Kapan Use Case Benar-Benar Dibutuhkan
Use Case wajib dibuat bila memenuhi kondisi berikut:
1. **Validasi & Aturan Bisnis Domain Kompleks**: Misal `LoginUseCase` yang memvalidasi format email institusi (`@campus.ac.id`), ketentuan minimal panjang password, dan pembatasan percobaan gagal.
2. **Orkestrasi Multi-Repository (Cross-Boundary Coordination)**: Misal `LogoutUseCase` yang mengoordinasikan:
   - Pembersihan session lokal (`TokenLocalDataSource`).
   - Pemanggilan endpoint logout di server (`AuthRepository`).
   - Pembersihan tabel lokal (`NoteRepository`).
   - Pembatalan langganan topic push (`PushService`).
3. **Logika yang Reusable**: Logika bisnis yang dipanggil oleh lebih dari satu UI atau background task.

---

## 4. Wiring Dependency Injection (DI) dengan Riverpod

Riverpod digunakan sebagai DI Container murni tanpa perlu library pihak ketiga seperti `get_it`:

```dart
// ==================== CORE / DATA SOURCES ====================
final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

final apiClientProvider = Provider<Dio>((ref) {
  final store = ref.watch(tokenStoreProvider);
  return buildApiClient(store);
});

final announcementRemoteDataSourceProvider =
    Provider<AnnouncementRemoteDataSource>((ref) {
  return AnnouncementRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

// ==================== REPOSITORY (DI INTERFACE -> IMPL) ====================
// Return type adalah Interface di Domain, instance konkret di Data
final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepositoryImpl(
    remoteDataSource: ref.watch(announcementRemoteDataSourceProvider),
  );
});

// ==================== PRESENTATION STATE ====================
// Widget hanya watch provider ini, TIDAK PERNAH memanggil 'new Repository()'
final announcementsProvider = FutureProvider<List<Announcement>>((ref) async {
  final repository = ref.watch(announcementRepositoryProvider);
  return repository.getAnnouncements();
});
```

---

## 5. Trade-off Setiap Keputusan

1. **Feature-First vs Layer-First**:
   - *Kelebihan*: File terkait fitur tertentu berkumpul dalam satu folder, mempermudah refactor atau penghapusan fitur tanpa menyebar ke seluruh proyek.
   - *Trade-off*: Struktur folder menjadi lebih dalam dengan repetisi subfolder (`presentation`, `domain`, `data`).
2. **Pragmatic Use Case vs Strict Use Case**:
   - *Kelebihan*: Mengurangi duplikasi kode dan file *boilerplate* untuk query baca sederhana.
   - *Trade-off*: Apabila di kemudian hari diperlukan logika tambahan, presentation notifier harus diubah untuk memanggil use case baru.
3. **Pure Riverpod DI vs GetIt**:
   - *Kelebihan*: Menyatu secara reaktif dengan widget tree, kemudahan *override* saat testing via `ProviderScope(overrides: [...])`, dan siklus hidup aman (*garbage collection* terkelola).
   - *Trade-off*: Membutuhkan passing `ref` atau `WidgetRef` pada seluruh rantai dependency.
