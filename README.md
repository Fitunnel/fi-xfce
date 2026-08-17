# 🚀 Fi-XFCE v2.9 - Termux XFCE4 & Wine Environment Installer

Auto installer dan management tool untuk mengonfigurasi **XFCE Desktop Environment**, **Termux-X11**, dan **Wine (Hangover)** di Termux dengan kontrol akselerasi GPU interaktif.

---

## 📱 Kompatibilitas Versi Android

- **Android 7.1.2 – Android 14**: Support Penuh (Dukungan optimal untuk sebagian besar arsitektur perangkat).
- **Android 15+**: Support Terbatas / Eksperimental (Dukungan bergantung pada batasan keamanan API baru dan kebijakan sistem Android terbaru).

---

## ⚡ Supported GPU Drivers & Acceleration

Kamu bisa berganti-ganti driver akselerasi GPU (*GPU Switcher*) langsung dari CLI `fi-xfce` jika mengalami *crash*, *blackscreen*, atau ketidakcocokan hardware:

1. **llvmpipe (Software Render - CPU)**
   * Rendisi penuh via CPU. Sangat stabil & anti-crash di semua HP.
2. **Turnip Zink + Mesa (Vulkan HW)**
   * Khusus Snapdragon. Menggunakan akselerasi Vulkan Turnip bawaan.
3. **Panfrost Native (Mali GPU)**
   * Khusus Chipset MediaTek / Exynos / Kirin dengan GPU Mali.
4. **Lavapipe (Vulkan CPU Emulator)**
   * Emulasi Vulkan software layer berbasis CPU.

---

## 🔗 Unduhan Aplikasi yang Dibutuhkan

Pastikan Anda menginstal aplikasi Termux dan Termux-X11 langsung dari repositori resmi GitHub (jangan gunakan versi Google Play Store karena sudah tidak diperbarui):

* **Termux App**: [Download Termux APK (GitHub Releases)](https://github.com/termux/termux-app/releases)
* **Termux-X11 Companion**: [Download Termux-X11 APK (GitHub Releases)](https://github.com/termux/termux-x11/releases)

---

## ✨ Fitur Utama

- **XFCE4 Desktop Custom**: Tampilan desktop Linux yang ringan, responsif, dan siap pakai di Android.
- **Wine / Hangover Support**: Menjalankan aplikasi dan game Windows (`.exe`) langsung dari Android.
- **Multi-Driver GPU Switcher**: Pilih driver GPU (llvmpipe, Turnip Zink + Mesa, Panfrost Native, Lavapipe) secara terpisah untuk XFCE maupun Wine.
- **Interactive App Manager**: Pasang, hapus, dan pin aplikasi populer (VS Code, GIMP, LibreOffice, dll.) ke desktop kapan saja via CLI `fi-xfce`.
- **Deep Clean Utility**: Fitur pembersih otomatis untuk menghapus *cache* APT, log XFCE, dan berkas sementara Wine agar penyimpanan tidak membengkak.
- **PulseAudio Native**: Konfigurasi audio stabil *out-of-the-box* tanpa *lag* atau suara pecah.

---

## 📋 Persyaratan Sistem

* **Penyimpanan Minimum**:
  * **5 GB** bebas (instalasi dasar XFCE4).
  * **20+ GB** bebas (jika menginstal paket Wine/Hangover lengkap).
* **Chipset**: Snapdragon (Adreno) atau MediaTek/Exynos/Kirin (Mali).

---

## 📥 Cara Instalasi di Termux

Jalankan satu baris perintah berikut di aplikasi **Termux**:

```bash
pkg update && pkg upgrade -y && pkg install wget -y && wget https://raw.githubusercontent.com/Fitunnel/fi-xfce/main/fi-xfceIns.sh && chmod +x fi-xfceIns.sh && ./fi-xfceIns.sh
