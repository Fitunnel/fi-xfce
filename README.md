🚀 Fi-XFCE v3.0

**Fi-XFCE** adalah automated installer & environment manager tingkat lanjut untuk menjalankan **XFCE4 Desktop Environment**, **Termux-X11 Display Server**, dan **Wine (Hangover + Box64)** di Termux secara efisien, responsif, dan mudah dikelola.

Dilengkapi antarmuka CLI interaktif untuk mengelola akselerasi GPU, instalasi aplikasi desktop, dan pemeliharaan sistem hanya dari 1 panel kontrol.

---

📌 Catatan Rilis v3.0

- **Aplikasi Baru**: Integrasi Telegram Desktop di App Manager + perbaikan file launcher `.desktop`
- **Manajemen Modul**: Optimasi App Manager. Utilitas non-esensial dihapus untuk hemat ruang
- **Peningkatan Daemon**: Penanganan `process termination` lebih baik + perintah penutup daemon lebih bersih saat keluar desktop
- **Kompatibilitas Android 15+ [Eksperimental]**: Penyesuaian skrip untuk meminimalisir black screen & isu alokasi memori

---

⚙️ Kompatibilitas Sistem & Driver

📱 Dukungan Android
| Versi Android | Status | Catatan |
| --- | --- | --- |
| Android 7.1.2 - 14 | ✅ Penuh | Stabil untuk ARM64 / x86_64 |
| Android 15+ | 🧪 Eksperimental | Gunakan Split Screen Termux + Termux-X11 jika terjadi rendering stall |

🎮 Akselerasi Grafis - GPU Switcher
Pilih rendering pipeline via menu `fi-xfce` sesuai hardware:

- `llvmpipe` : CPU Software Render. Fallback paling stabil untuk semua device
- `Turnip Zink + Mesa` : Vulkan HW. Khusus GPU Adreno Qualcomm Snapdragon
- `Panfrost Native` : Native OpenGL. Khusus GPU Mali MediaTek / Exynos / Kirin
- `Lavapipe` : Emulasi layer Vulkan berbasis software

---

🛠️ Persyaratan

Pastikan Termux & Termux-X11 dari rilis GitHub resmi, bukan Play Store:

- [Termux App](https://github.com/termux/termux-app/releases)
- [Termux-X11 Companion](https://github.com/termux/termux-x11/releases)

**Spesifikasi Minimum:**
- **Penyimpanan**:
    - 5 GB untuk instalasi standar XFCE4
    - 20 GB+ jika pakai Wine / Hangover
- **Arsitektur**: ARM64 `aarch64`

---

📥 Panduan Instalasi

Jalankan di terminal Termux:

```bash
pkg update && pkg upgrade -y && pkg install wget -y && \
wget https://raw.githubusercontent.com/Fitunnel/fi-xfce/main/fi-xfceIns.sh && \
chmod +x fi-xfceIns.sh && \
./fi-xfceIns.sh
```

🚀 Penggunaan

Setelah instalasi selesai, buka environment manager kapan saja:
```
fi-xfce
```

✨ Fitur Unggulan

- *Multi-GPU Switcher*: Konfigurasi GPU terpisah antara desktop XFCE4 dan lingkungan Wine
- *Wine GPU Switcher Shortcuts*: Toggle ON/OFF Turnip Zink langsung dari desktop untuk akselerasi aplikasi Windows
- *Auto-Pin Application Manager*: Instal/hapus aplikasi populer: VS Code, GIMP, LibreOffice, Telegram, dll + auto buat shortcut desktop
- *Deep Clean Utility*: Bersihkan cache APT, log XFCE, thumbnail, dan file sementara Wine untuk hemat memori

---

👨‍💻 Developer

- *Developer*: AlfiStoreID / Fitunnel
- *Versi*: 3.0
- *WhatsApp*: https://wa.me/6285223659782

---

⚠️ Disclaimer
Skrip ini dimodifikasi untuk Termux. Penggunaan Wine/Hangover di Android masih eksperimental dan performa tergantung device. Gunakan dengan bijak.

Jika suka project ini, kasih ⭐ di repo!

Tinggal copy ke `README.md` di repo kamu.

Mau sekalian aku tambahin badge `GitHub release`, `License`, atau screenshot demo biar lebih menarik?
