# AI Verification & Technical Decisions (Modul 07: Clean Architecture)

Dokumen ini mendokumentasikan verifikasi teknis terhadap usulan AI coding assistant, evaluasi keputusan arsitektur, bukti verifikasi perintah `grep`, serta diagram arah panah dependensi Clean Architecture untuk persiapan demonstrasi codelab.

---

## 1. Tabel Usulan AI vs Keputusan Final

| Komponen Arsitektur | Usulan Awal AI | Keputusan Final Pengembang | Alasan & Argumen Teknis |
| :--- | :--- | :--- | :--- |
| **Pola Pengorganisasian** | Feature-First (`lib/features/{auth, announcements, notes}`) dengan sublayer `presentation`, `domain`, dan `data`. | **Diterima Penuh** | Mengelompokkan kode per fitur membuat kode sangat kohesif, mempermudah pelacakan dependensi, dan mencegah *god directory* saat aplikasi bertumbuh. |
| **Separasi Repository** | Interface disimpan di `domain/repositories/` dan implementasi konkret disimpan di `data/repositories/`. | **Diterima Penuh** | Menerapkan *Dependency Inversion Principle* (DIP). Domain mendikte kebutuhan kontrak, sedangkan data layer bertindak sebagai detail implementasi. |
| **Penggunaan Use Case pada CRUD** | Menghilangkan class Use Case 1-baris untuk pengambilan pengumuman (`GetAnnouncements`), langsung menghubungkan `announcementsProvider` ke `AnnouncementRepository`. | **Diterima Penuh** | Mencegah *over-engineering* dan *useless abstraction*. Class usecase yang hanya mem-forward pemanggilan 1 baris adalah kode redundan (*boilerplate passthrough*). |
| **Use Case pada Fitur Kompleks** | Menyediakan Use Case khusus untuk orkestrasi bisnis (misal `LoginUseCase` atau `LogoutUseCase` yang melibatkan multiple data sources). | **Diterima Penuh** | Use case benar-benar bernilai tinggi saat melakukan validasi domain khusus, enkripsi/token management, atau koordinasi lintas repository (auth, storage, FCM). |
| **Separasi Entity vs Model** | `Entity` murni (tanpa method mapping), sedangkan `Model` mewarisi `Entity` dan menampung `fromJson`, `toJson`, `toMap`, `fromMap`. | **Diterima Penuh** | Memastikan domain layer tidak memiliki keterikatan terhadap skema JSON backend maupun database lokal. Perubahan format API tidak merusak core entity. |
| **Dependency Injection** | Menggunakan Riverpod bawaan (`Provider<Interface>((ref) => Impl(...))`) tanpa package tambahan seperti `get_it`. | **Diterima Penuh** | Menghindari kompleksitas library luar, memanfaatkan kemudahan testing via `ProviderScope(overrides: [...])`, dan mencegah kebocoran instansiasi manual di UI. |

---

## 2. Checklist Verifikasi AI

| No | Kriteria Verifikasi | Status | Catatan Evaluasi |
| :---: | :--- | :---: | :--- |
| 1 | **Interface repository tinggal di domain dan implementasi di data?** | ✅ **Lolos** | Interface `NoteRepository` berada di `domain/repositories/`, sedangkan `NoteRepositoryImpl` berada di `data/repositories/`. Tidak ada pencampuran dalam satu folder. |
| 2 | **Domain bebas import Flutter/Dio/SQLite/Firebase?** | ✅ **Lolos** | Diverifikasi dengan `grep`. File pada domain hanya bergantung pada core failure dan pustaka murni Dart (`dart:async`, `dart:core`). |
| 3 | **AI tidak membuat use case untuk tiap CRUD satu-baris?** | ✅ **Lolos** | Ditandai secara eksplisit bahwa usecase passthrough satu baris adalah over-engineering dan dihindari untuk query sederhana. |
| 4 | **Entity bebas mapping (`toMap`/`fromMap`/`toJson`)?** | ✅ **Lolos** | Entity `Note` hanya berisi immutable field murni. Seluruh logic serialisasi diisolasi di `NoteModel` pada data layer. |
| 5 | **Wiring DI terpusat di provider dan widget tidak `new Repository()` sendiri?** | ✅ **Lolos** | Instansiasi dikelola oleh Riverpod Provider. Widget UI hanya mengonsumsi state via `ref.watch()`. |

---

## 3. Bukti Tiga Verifikasi Grep

Verifikasi kode dilakukan secara otomatis menggunakan perintah pencarian `git grep` pada terminal:

### Verifikasi 1: Memastikan Domain Bersih dari Framework & Third-Party Libs
**Perintah**:
```bash
git grep -E "import.*(flutter|dio|sqflite|firebase)" lib/features/notes/domain/
```
**Output**:
```text
(0 matches found - Exit code 1)
```
> **Interpretasi**: Domain layer 100% murni Dart dan sama sekali tidak bergantung pada Flutter UI, Dio HTTP, Sqflite, atau Firebase.

---

### Verifikasi 2: Memastikan Entity Bebas dari Serialisasi / Mapping
**Perintah**:
```bash
git grep -E "(toJson|fromJson|toMap|fromMap)" lib/features/notes/domain/entities/
```
**Output**:
```text
(0 matches found - Exit code 1)
```
> **Interpretasi**: Seluruh entity terbebas dari format database atau JSON API eksternal. Logika mapping hanya berada di `data/models/`.

---

### Verifikasi 3: Memastikan Widget Tidak Melakukan Instansiasi Manual (Bebas `new Repository()`)
**Perintah**:
```bash
git grep -E "new [A-Za-z]+Repository|[A-Za-z]+Repository\(" lib/features/notes/presentation/pages/
```
**Output**:
```text
(0 matches found - Exit code 1)
```
> **Interpretasi**: Tidak ada instansiasi manual repository pada presentation widget. Seluruh dependensi disuntikkan secara deklaratif melalui Riverpod.

---

## 4. Diagram Arah Panah Dependensi (The Dependency Rule)

Untuk persiapan sesi demonstrasi dan evaluasi, aturan utama Clean Architecture adalah:
> **"Dependencies can only point INWARDS towards higher-level policies (Domain)."**

### Diagram Arsitektur & Arah Panah

```mermaid
graph TD
    subgraph Presentation Layer ["Presentation Layer (Flutter / UI)"]
        UI[Pages & Widgets] -->|ref.watch / ref.read| Notifier[Riverpod Notifiers / Providers]
    end

    subgraph Domain Layer ["Domain Layer (Core Business - Pure Dart)"]
        UseCase[Use Cases (Orkestrasi)]
        Entity[Entities (Enterprise Rules)]
        RepoInterface[Repository Interfaces (Kontrak)]
    end

    subgraph Data Layer ["Data Layer (Infrastructure & DB)"]
        RepoImpl[Repository Implementations]
        Model[Models (JSON / SQLite Mapping)]
        DataSource[Remote / Local Data Sources]
    end

    %% Dependency Arrows
    Notifier -->|Memanggil| UseCase
    Notifier -->|Memanggil langsung jika simple CRUD| RepoInterface
    UseCase -->|Mengakses| RepoInterface
    UseCase -->|Mengolah| Entity
    
    RepoImpl -.->|Implements (Inversi Dependensi)| RepoInterface
    RepoImpl -->|Konversi Model ke Entity| Entity
    RepoImpl -->|Menggunakan| DataSource
    DataSource -->|Menghasilkan| Model
    Model --|>|Extends / Maps to| Entity
```

### Visualisasi Ringkas Arah Panah (Wajib Hafal untuk Demo)

```text
    [ Presentation ]  ------------------->  [ Domain ]  <-------------------  [ Data ]
(Pages, Widgets, Providers)             (Entities, Interfaces)          (Models, DataSources, RepoImpl)
           |                                       ^                                    |
           |                                       |                                    |
           +---------------- Mengakses ------------+                                    |
                                                   |                                    |
                                                   +------ Mengimplementasi (DIP) ------+
```

### 3 Prinsip Utama Arah Panah:
1. **Presentation -> Domain**: UI hanya mengetahui entity dan interface kontrak, tidak pernah mengetahui detail HTTP atau SQL.
2. **Data -> Domain**: Data layer mengimplementasikan kontrak interface domain (*Dependency Inversion*), bukan domain yang bergantung pada data.
3. **Domain -> Nobody**: Domain layer berada di lingkaran terdalam (*Core*), memiliki derajat kemandirian tertinggi, dan tidak mengimpor layer luar manapun.
