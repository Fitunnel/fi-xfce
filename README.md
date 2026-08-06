cat << 'EOF' > README.md
# 🚀 Fi-XFCE v2.9 - Termux XFCE4 & Wine Environment Installer

Auto installer dan management tool untuk mengonfigurasi **XFCE4 Desktop Environment**, **Termux-X11**, dan **Wine (Hangover)** di Termux dengan kontrol akselerasi GPU Turnip/Zink interaktif.

---

## 📱 Kompatibilitas Versi Android

- **Android 7.1.2 – Android 15**: Support Penuh (Dukungan optimal untuk sebagian besar arsitektur perangkat).
- **Android 16 – 17+**: Support Terbatas / Eksperimental (Dukungan bergantung pada batasan keamanan API baru dan kebijakan sistem Android terbaru).

---

## 🔗 Unduhan Aplikasi yang Dibutuhkan

Pastikan Anda menginstal aplikasi Termux dan Termux-X11 langsung dari repositori resmi GitHub (jangan gunakan versi Google Play Store karena sudah tidak diperbarui):

* **Termux App**: [Download Termux APK (GitHub Releases)](https://github.com/termux/termux-app/releases)
* **Termux-X11 Companion**: [Download Termux-X11 APK (GitHub Releases)](https://github.com/termux/termux-x11/releases)

---

## ✨ Fitur Utama

- **XFCE4 Desktop Custom**: Tampilan desktop Linux yang ringan, responsif, dan siap pakai di Android.
- **Wine / Hangover Support**: Menjalankan aplikasi dan game Windows (`.exe`) langsung dari Android.
- **Dual-Mode GPU Control**: Atur akselerasi GPU Turnip/Zink secara terpisah untuk Desktop XFCE dan Wine, dilengkapi *1-click switcher* di desktop saat game/aplikasi mengalami *crash*.
- **Interactive App Manager**: Pasang, hapus, dan pin aplikasi populer (VS Code, GIMP, LibreOffice, dll.) ke desktop kapan saja via CLI `fi-xfce`.
- **Deep Clean Utility**: Fitur pembersih otomatis untuk menghapus *cache* APT, log XFCE, dan berkas sementara Wine agar penyimpanan tidak membengkak.
- **PulseAudio Native**: Konfigurasi audio stabil *out-of-the-box* tanpa *lag* atau suara pecah.

---

## 📋 Persyaratan Sistem

* **Penyimpanan Minimum**:
  * **5 GB** bebas (instalasi dasar XFCE4).
  * **15–20 GB** bebas (jika menginstal paket Wine/Hangover lengkap).
* **Chipset**: Dioptimalkan untuk Qualcomm Snapdragon (Adreno GPU untuk Driver Turnip).

---

## 📥 Cara Instalasi di Termux

Jalankan satu baris perintah berikut di aplikasi **Termux**:

```bash
pkg update && pkg upgrade -y && pkg install wget -y && wget [https://raw.githubusercontent.com/Fitunnel/YOUR_REPO_NAME/main/fi-xfceIns.sh](https://raw.githubusercontent.com/Fitunnel/YOUR_REPO_NAME/main/fi-xfceIns.sh) && chmod +x fi-xfceIns.sh && ./fi-xfceIns.sh
