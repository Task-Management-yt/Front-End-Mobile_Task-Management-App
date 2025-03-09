# Task Management App (Flutter)

## Deskripsi

Task Management App (Flutter) aplikasi ini berbasis Flutter yang membantu pengguna mengelola tugas mereka dengan mudah. Aplikasi ini memungkinkan pengguna untuk menambah, mengedit, mencari, dan mengkategorikan tugas berdasarkan status. anda bisa mengunduh aplikasi ini di [Github Release]([https://github.com/Task-Management-yt/react-task-management/releases/tag/flutter](https://github.com/Task-Management-yt/Front-End-Mobile_Task-Management-App/releases/tag/flutter)).

## Fitur

- **Autentikasi Pengguna**: Login, daftar, dan logout menggunakan Supabase Auth yang diakes melalui backend fast-API.
- **Manajemen Tugas**:
  - Membuat tugas baru
  - Mengedit dan menghapus tugas
  - Menandai tugas sebagai selesai
  - Pencarian tugas berdasarkan judul atau deskripsi
- **Filter Tugas**:
  - Semua tugas
  - Tugas belum selesai
  - Tugas sedang berjalan
  - Tugas selesai
- **State Management**: Menggunakan Provider untuk manajemen state.
- **UI Responsif**: Tampilan modern dan responsif dengan Material Design.

## Teknologi yang Digunakan

- **Flutter**: Framework utama
- **Fast API**: Mengelola back-end
- **Supabase**: Sebagai database
- **Provider**: State management

## Instalasi dan Menjalankan Aplikasi

### Prasyarat

Pastikan Anda sudah menginstal:

- Flutter SDK
- Android Studio atau VS Code dengan Flutter Plugin

### Langkah-langkah

1. Clone repository ini:
   ```bash
   git clone https://github.com/Task-Management-yt/Front-End-Mobile_Task-Management-App.git
   cd Front-End-Mobile_Task-Management-App
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Jalankan aplikasi:
   ```bash
   flutter run
   ```

## Struktur Proyek

```
Task-Management-App-Flutter/
│── lib/
│   │── constants/
│   │── models/
│   │── providers/
│   │── services/
│   │── views/
│   │── main.dart
│── pubspec.yaml
│── README.md
```
