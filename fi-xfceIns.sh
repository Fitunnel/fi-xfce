#!/data/data/com.termux/files/usr/bin/bash
#######################################################
#  📱 AlfiStoreID XFCE Environment Installer v3.1
#  
#  Fitur & Catatan Perubahan (v3.1):
#  - Penghapusan Telegram Desktop dari manajer aplikasi
#  - Penambahan Synaptic Package Manager (Manager Aplikasi GUI)
#  - Penghapusan manager aplikasi yang tidak perlu
#  - Perbaiki daemon dan ada perintah penutup
#  - Fix Issue Android 15+ (Eksperimental)
#  
#  Pembuat : AlfiStoreID
#  No WA   : 085223659782
#  Versi   : 3.1
#######################################################

# ============== KONFIGURASI ==============
TOTAL_STEPS=9
CURRENT_STEP=0

# ============== WARNA TAMPILAN ==============
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
GRAY='\033[0;90m'
NC='\033[0m'
BOLD='\033[1m'

# ============== FUNGSI PROGRESS & SPINNER ==============
update_progress() {
    CURRENT_STEP=$((CURRENT_STEP + 1))
    PERCENT=$((CURRENT_STEP * 100 / TOTAL_STEPS))
    
    FILLED=$((PERCENT / 5))
    EMPTY=$((20 - FILLED))
    
    BAR="${GREEN}"
    for ((i=0; i<FILLED; i++)); do BAR+="█"; done
    BAR+="${GRAY}"
    for ((i=0; i<EMPTY; i++)); do BAR+="░"; done
    BAR+="${NC}"
    
    echo ""
    echo -e "${WHITE}─┴──────────────────────────────────────────────────────────┴─${NC}"
    echo -e "${CYAN}  📊 PROGRES UTAMA: ${WHITE}Langkah ${CURRENT_STEP}/${TOTAL_STEPS}${NC} ${BAR} ${WHITE}${PERCENT}%${NC}"
    echo -e "${WHITE}─┬──────────────────────────────────────────────────────────┬─${NC}"
    echo ""
}

spinner() {
    local pid=$1
    local message=$2
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) % 10 ))
        printf "\r  ${YELLOW}⏳${NC} ${message} ${CYAN}${spin:$i:1}${NC}  "
        LD_PRELOAD= sleep 0.1 2>/dev/null || true
    done
    
    wait $pid
    local exit_code=$?
    
    if [ $exit_code -eq 0 ]; then
        printf "\r  ${GREEN}✓${NC} ${message}                    \n"
    else
        printf "\r  ${RED}✗${NC} ${message} ${RED}(gagal)${NC}     \n"
    fi
    return $exit_code
}

install_pkg() {
    local pkg=$1
    local name=${2:-$pkg}
    (yes | pkg install $pkg -y > /dev/null 2>&1) &
    spinner $! "Menginstall ${name}..."
}

# ============== BANNER PENGELOLA ==============
show_banner() {
    clear
    echo -e "${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${CYAN}│${WHITE}             🚀 AlfiStoreID XFCE v3.1 🚀                 ${CYAN}│${NC}"
    echo -e "${CYAN}│${GRAY}        Desktop Environment Installer untuk Termux        ${CYAN}│${NC}"
    echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}"
    echo -e "  ${WHITE}Pembuat : ${GREEN}AlfiStoreID${NC}"
    echo -e "  ${WHITE}No WA   : ${GREEN}085223659782${NC}"
    echo -e "  ${WHITE}Versi   : ${CYAN}3.1${NC}"
    echo ""
}

# ============== DETEKSI PERANGKAT ==============
detect_device() {
    echo -e "${PURPLE}[*] Mendeteksi spesifikasi perangkat...${NC}"
    echo ""
    DEVICE_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Tidak Diketahui")
    DEVICE_BRAND=$(getprop ro.product.brand 2>/dev/null || echo "Tidak Diketahui")
    ANDROID_VERSION=$(getprop ro.build.version.release 2>/dev/null || echo "Tidak Diketahui")
    
    CPU_ABI=$(getprop ro.product.cpu.abi 2>/dev/null || uname -m)
    
    GPU_VENDOR=$(getprop ro.hardware.egl 2>/dev/null)
    if [ -z "$GPU_VENDOR" ]; then
        GPU_VENDOR=$(getprop ro.board.platform 2>/dev/null || echo "Hardware Tidak Diketahui")
    fi

    if [[ "${GPU_VENDOR,,}" == *"adreno"* ]] || [[ "${GPU_VENDOR,,}" == *"msm"* ]] || [[ "${GPU_VENDOR,,}" == *"qcom"* ]]; then
        GPU_INFO="Adreno (Qualcomm Snapdragon)"
    elif [[ "${GPU_VENDOR,,}" == *"mali"* ]] || [[ "${GPU_VENDOR,,}" == *"exynos"* ]] || [[ "${GPU_VENDOR,,}" == *"mt"* ]]; then
        GPU_INFO="Mali / MediaTek / Exynos"
    else
        GPU_INFO="$GPU_VENDOR"
    fi

    echo -e "  ${GREEN}📱${NC} Perangkat : ${WHITE}${DEVICE_BRAND} ${DEVICE_MODEL}${NC}"
    echo -e "  ${GREEN}🤖${NC} Android   : ${WHITE}${ANDROID_VERSION}${NC}"
    echo -e "  ${GREEN}⚙️${NC}  CPU       : ${WHITE}${CPU_ABI}${NC}"
    echo -e "  ${GREEN}🎮${NC} GPU       : ${WHITE}${GPU_INFO}${NC}"
    echo ""
    sleep 1
}

# ============== LANGKAH-LANGKAH INSTALLASI ==============
step_update() {
    update_progress
    echo -e "${PURPLE}[Langkah ${CURRENT_STEP}/${TOTAL_STEPS}] Memperbarui paket sistem...${NC}"
    echo ""
    (yes | pkg update -y > /dev/null 2>&1) &
    spinner $! "Memperbarui daftar paket..."
    (yes | pkg upgrade -y > /dev/null 2>&1) &
    spinner $! "Meningkatkan paket terpasang..."
}

step_repos() {
    update_progress
    echo -e "${PURPLE}[Langkah ${CURRENT_STEP}/${TOTAL_STEPS}] Menambahkan repositori tambahan...${NC}"
    echo ""
    install_pkg "x11-repo" "Repositori X11"
    install_pkg "tur-repo" "Repositori TUR"
}

step_x11() {
    update_progress
    echo -e "${PURPLE}[Langkah ${CURRENT_STEP}/${TOTAL_STEPS}] Menginstall Termux-X11...${NC}"
    echo ""
    install_pkg "termux-x11-nightly" "Termux-X11 Display Server"
    install_pkg "xorg-xrandr" "XRandR"
}

step_desktop() {
    update_progress
    echo -e "${PURPLE}[Langkah ${CURRENT_STEP}/${TOTAL_STEPS}] Menginstall XFCE4 Desktop...${NC}"
    echo ""
    install_pkg "xfce4" "Desktop XFCE4"
    install_pkg "xfce4-goodies" "XFCE4 Goodies"
    install_pkg "xfce4-terminal" "Terminal XFCE4"
    install_pkg "xfce4-whiskermenu-plugin" "Whisker Menu Plugin"
    install_pkg "xfce4-notifyd" "XFCE Notification Daemon"
    install_pkg "thunar" "Manajer Berkas Thunar"
    install_pkg "mousepad" "Editor Teks Mousepad"
    install_pkg "imagemagick" "ImageMagick Utilities"
    install_pkg "gtk3" "GTK+ 3 Library Engine"
    install_pkg "gtk4" "GTK+ 4 Library Engine"
}

step_gpu() {
    update_progress
    echo -e "${PURPLE}[Langkah ${CURRENT_STEP}/${TOTAL_STEPS}] Menginstall Driver GPU & Mesa...${NC}"
    echo ""
    install_pkg "mesa-zink" "Mesa Zink"
    install_pkg "vulkan-loader" "Vulkan Loader"
    install_pkg "mesa-vulkan-icd-freedreno" "Driver Adreno Turnip"
    install_pkg "mesa-vulkan-icd-swrast" "Driver Software Renderer"
    install_pkg "mesa-demos" "Mesa Demos (glxinfo/glxgears)"
}

step_audio() {
    update_progress
    echo -e "${PURPLE}[Langkah ${CURRENT_STEP}/${TOTAL_STEPS}] Menginstall Sistem Audio...${NC}"
    echo ""
    install_pkg "pulseaudio" "PulseAudio"
}

step_apps() {
    update_progress
    echo -e "${PURPLE}[Langkah ${CURRENT_STEP}/${TOTAL_STEPS}] Menginstall Aplikasi Dasar...${NC}"
    echo ""
    install_pkg "firefox" "Browser Firefox"
    install_pkg "git" "Git"
    install_pkg "wget" "Wget"
    install_pkg "curl" "cURL"
    install_pkg "dbus" "Layanan D-Bus"
}

# ============== PEMBUAT SKRIP MANAGER ==============
step_launchers() {
    update_progress
    echo -e "${PURPLE}[Langkah ${CURRENT_STEP}/${TOTAL_STEPS}] Membuat Skrip Manager fi-xfce.sh...${NC}"
    echo ""
    
    cat > /data/data/com.termux/files/usr/bin/fi-xfce.sh << 'ALFIEOF'
#!/data/data/com.termux/files/usr/bin/bash

CONFIG_FILE="$HOME/.config/alfi-gpu.sh"
WINE_GPU_FILE="$HOME/.config/alfi-wine-gpu.sh"
DESKTOP_DIR="$HOME/Desktop"

mkdir -p "$HOME/.config"
mkdir -p "$DESKTOP_DIR"

# Set default GPU XFCE
set_default_gpu() {
    cat > "$CONFIG_FILE" << 'CONF'
export MESA_LOADER_DRIVER_OVERRIDE=llvmpipe
export GALLIUM_DRIVER=llvmpipe
export ALFI_DRIVER_NAME="llvmpipe (Safe Mode)"
CONF
}

# Set default GPU Wine (Turnip ON secara bawaan)
set_default_wine_gpu() {
    cat > "$WINE_GPU_FILE" << 'CONF'
export WINE_GPU_MODE="ON"
CONF
}

if [ ! -f "$CONFIG_FILE" ]; then set_default_gpu; fi
if [ ! -f "$WINE_GPU_FILE" ]; then set_default_wine_gpu; fi

# Inisialisasi Script Launcher Wine-Turnip Global
setup_wine_turnip_script() {
    cat > ~/wine-turnip.sh << 'EOF'
#!/bin/bash
TARGET="$1"

if [ -z "$TARGET" ]; then
    echo "Penggunaan: wine-turnip /path/ke/aplikasi.exe"
    exit 1
fi

DIR="$(dirname "$TARGET")"
FILE="$(basename "$TARGET")"

if [ -d "$DIR" ]; then
    cd "$DIR" || exit 1
fi

source "$HOME/.config/alfi-wine-gpu.sh" 2>/dev/null

if [ "$WINE_GPU_MODE" == "ON" ]; then
    unset VK_DRIVER_FILES
    unset VK_ICD_FILENAMES
    export GALLIUM_DRIVER=zink
    export MESA_LOADER_DRIVER_OVERRIDE=zink
    export TU_DEBUG=noconform
    export MESA_NO_ERROR=1
    export MESA_GL_VERSION_OVERRIDE=4.6
    export MESA_GLES_VERSION_OVERRIDE=3.2
else
    unset VK_DRIVER_FILES
    unset VK_ICD_FILENAMES
    unset GALLIUM_DRIVER
    unset MESA_LOADER_DRIVER_OVERRIDE
    unset TU_DEBUG
    unset MESA_NO_ERROR
    unset MESA_GL_VERSION_OVERRIDE
    unset MESA_GLES_VERSION_OVERRIDE
fi

wine "$FILE"
EOF

    chmod +x ~/wine-turnip.sh
    ln -sf ~/wine-turnip.sh /data/data/com.termux/files/usr/bin/wine-turnip
    chmod +x /data/data/com.termux/files/usr/bin/wine-turnip
}

setup_wine_turnip_script

check_status() {
    local pkg=$1
    if dpkg -l | grep -q "^ii  $pkg "; then
        echo -e "\e[1;32m[Terpasang]\e[0m"
    else
        echo -e "\e[1;31m[Belum Terpasang]\e[0m"
    fi
}

create_desktop_pin() {
    local app_name="$1"
    local exec_cmd="$2"
    local icon_name="$3"
    
    local filename=$(echo "$app_name" | tr -d ' ')
    local desktop_file="$DESKTOP_DIR/${filename}.desktop"

    cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=$app_name
Comment=Jalankan $app_name
Exec=$exec_cmd
Icon=$icon_name
Terminal=false
StartupNotify=true
Categories=Utility;Application;AudioVideo;Player;Network;System;
EOF

    chmod +x "$desktop_file" 2>/dev/null
    echo -e "\e[1;32m📌 Shortcut berhasil dipasang: $desktop_file\e[0m"
}

remove_desktop_pin() {
    local app_name="$1"
    local filename=$(echo "$app_name" | tr -d ' ')
    local desktop_file="$DESKTOP_DIR/${filename}.desktop"
    
    if [ -f "$desktop_file" ]; then
        rm -f "$desktop_file"
        echo -e "\e[1;31m🗑️ Shortcut $app_name dihapus dari Desktop!\e[0m"
    fi
}

create_wine_gpu_shortcuts() {
    mkdir -p "$DESKTOP_DIR"

    cat > "$DESKTOP_DIR/Wine_GPU_Turnip_ON.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine GPU: Turnip Zink (ON)
Exec=bash -c "echo 'export WINE_GPU_MODE=\"ON\"' > ~/.config/alfi-wine-gpu.sh; notify-send 'Wine GPU' 'Akselerasi Turnip Zink + Mesa DIAKTIFKAN!' -i display"
Icon=display
Terminal=false
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/Wine_GPU_Turnip_OFF.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine GPU: Native Default (OFF)
Exec=bash -c "echo 'export WINE_GPU_MODE=\"OFF\"' > ~/.config/alfi-wine-gpu.sh; notify-send 'Wine GPU' 'Akselerasi Turnip Zink DIMATIKAN (Wine Native)!' -i display"
Icon=display
Terminal=false
Categories=Utility;
EOF

    chmod +x "$DESKTOP_DIR/Wine_GPU_Turnip_ON.desktop" "$DESKTOP_DIR/Wine_GPU_Turnip_OFF.desktop" 2>/dev/null
    echo -e "\e[1;32m📌 Shortcut Switcher Wine GPU berhasil dibuat di Desktop!\e[0m"
}

remove_wine_gpu_shortcuts() {
    rm -f "$DESKTOP_DIR/Wine_GPU_Turnip_ON.desktop" "$DESKTOP_DIR/Wine_GPU_Turnip_OFF.desktop"
}

create_wine_shortcuts() {
    mkdir -p "$DESKTOP_DIR"

    cat > "$DESKTOP_DIR/WineConfig.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Configuration
Exec=wine winecfg
Icon=wine
Terminal=false
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/WindowsExplorer.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Windows Explorer
Exec=wine winefile
Icon=folder-windows
Terminal=false
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/WineTaskManager.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Task Manager
Exec=wine taskmgr
Icon=utilities-system-monitor
Terminal=false
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/WineRegedit.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Regedit
Exec=wine regedit
Icon=wine
Terminal=false
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/WineUninstaller.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Uninstaller
Exec=wine uninstaller
Icon=wine
Terminal=false
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/WineControl.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Control Panel
Exec=wine control
Icon=wine
Terminal=false
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/WineCMD.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Command Prompt
Exec=wine cmd
Icon=utilities-terminal
Terminal=true
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/WineRunDLL32.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine RunDLL32
Exec=wine rundll32
Icon=wine
Terminal=false
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/WineNotepad.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Notepad
Exec=wine notepad
Icon=text-editor
Terminal=false
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/WineWordpad.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Wordpad
Exec=wine wordpad
Icon=text-editor
Terminal=false
Categories=Utility;
EOF

    cat > "$DESKTOP_DIR/WineReboot.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Wine Reboot Server
Exec=wine wineboot -r
Icon=system-reboot
Terminal=false
Categories=Utility;
EOF

    chmod +x "$DESKTOP_DIR"/Wine*.desktop "$DESKTOP_DIR"/Windows*.desktop 2>/dev/null
    create_wine_gpu_shortcuts
    echo -e "\e[1;32m📌 11 Shortcut Desktop Wine & 2 Switcher GPU berhasil dibuat!\e[0m"
}

remove_wine_shortcuts() {
    rm -f "$DESKTOP_DIR/WineConfig.desktop" \
          "$DESKTOP_DIR/WindowsExplorer.desktop" \
          "$DESKTOP_DIR/WineTaskManager.desktop" \
          "$DESKTOP_DIR/WineRegedit.desktop" \
          "$DESKTOP_DIR/WineUninstaller.desktop" \
          "$DESKTOP_DIR/WineControl.desktop" \
          "$DESKTOP_DIR/WineCMD.desktop" \
          "$DESKTOP_DIR/WineRunDLL32.desktop" \
          "$DESKTOP_DIR/WineNotepad.desktop" \
          "$DESKTOP_DIR/WineWordpad.desktop" \
          "$DESKTOP_DIR/WineReboot.desktop"
    remove_wine_gpu_shortcuts
    echo -e "\e[1;31m🗑️ Seluruh Shortcut Desktop Wine dihapus!\e[0m"
}

manage_wine() {
    if dpkg -l | grep -q "^ii  hangover-wine "; then
        echo -e "\n\e[1;33mStatus: Wine Environment (Hangover + Box64) SUDAH TERPASANG.\e[0m"
        echo -e " \e[1;31m1)\e[0m Uninstall Wine Environment (Bersihkan Prefix ~/.wine & Shortcut)"
        echo -e " \e[1;36m2)\e[0m Perbaiki / Buat Ulang Shortcut Desktop Wine"
        echo -e " \e[1;37m0)\e[0m Batal"
        read -p " Pilih tindakan [0-2]: " act
        if [ "$act" == "1" ]; then
            echo -e "\e[1;31mMenghapus Hangover Wine & Box64...\e[0m"
            pkg uninstall hangover-wine hangover-wowbox64 -y
            rm -f /data/data/com.termux/files/usr/bin/wine /data/data/com.termux/files/usr/bin/winecfg 2>/dev/null
            remove_wine_shortcuts
            
            if [ -d "$HOME/.wine" ]; then
                echo -e "\e[1;33m🧹 Menghapus folder ~/.wine untuk membebaskan penyimpanan...\e[0m"
                rm -rf "$HOME/.wine" 2>/dev/null
            fi
            
            echo -e "\e[1;32m✓ Wine Environment, Folder ~/.wine, & seluruh shortcut berhasil di-uninstall bersih!\e[0m"
        elif [ "$act" == "2" ]; then
            create_wine_shortcuts
            echo -e "\e[1;32m✓ Shortcut Desktop Wine berhasil diperbarui!\e[0m"
        fi
    else
        echo -e "\n\e[1;33mStatus: Wine Environment (Hangover + Box64) BELUM TERPASANG.\e[0m"
        echo -e " \e[1;32m1)\e[0m Install Wine Environment"
        echo -e " \e[1;37m0)\e[0m Batal"
        read -p " Pilih tindakan [0-1]: " act
        if [ "$act" == "1" ]; then
            clear
            echo -e "\e[1;31m┌─────────────────────────────────────────────────────────────────────────┐\e[0m"
            echo -e "\e[1;31m│                       ⚠️ PERINGATAN RISIKO WINE ⚠️                       │\e[0m"
            echo -e "\e[1;31m└─────────────────────────────────────────────────────────────────────────┘\e[0m"
            echo -e "\e[1;33mMohon dipikirkan lagi jika kamu meng-install ini harap penyimpanan kamu\e[0m"
            echo -e "\e[1;33myang tersedia 20GB+ karna wine ini bisa memakan banyak penyimpanan kamu,\e[0m"
            echo -e "\e[1;33mDan mohon jangan install apapun kayak directx, pengubah grafis dan lain\e[0m"
            echo -e "\e[1;33mlain jika wawasan kamu kurang tentang Wine takutnya aplikasi yang tadinya\e[0m"
            echo -e "\e[1;33mbisa di install jadi tidak bisa dijalankan! kalau ini ditujuan untuk\e[0m"
            echo -e "\e[1;33medukasi,pengetahuan ataupun pengembangan boleh saja jika kamu menyetujui\e[0m"
            echo -e "\e[1;33mresiko di atas!\e[0m"
            echo -e "\e[1;31m---------------------------------------------------------------------------\e[0m"
            echo -e "  \e[1;32m1)\e[0m Ya, Lanjut Installasi"
            echo -e "  \e[1;31m0)\e[0m Batal Installasi"
            echo ""
            read -p " Apakah Anda yakin ingin melanjutkan? [0/1]: " warn_choice
            
            if [ "$warn_choice" == "1" ]; then
                echo -e "\n\e[1;34mMengunduh & Menginstall Wine Environment...\e[0m"
                if pkg install hangover-wine hangover-wowbox64 -y; then
                    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/wine /data/data/com.termux/files/usr/bin/wine
                    ln -sf /data/data/com.termux/files/usr/opt/hangover-wine/bin/winecfg /data/data/com.termux/files/usr/bin/winecfg
                    wine reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v FontSmoothing /t REG_SZ /d 2 /f > /dev/null 2>&1
                    create_wine_shortcuts
                    echo -e "\e[1;32m✓ Wine Environment & Shortcut Desktop Berhasil Terpasang! 📌\e[0m"
                else
                    echo -e "\e[1;31m❌ Gagal menginstall Wine Environment.\e[0m"
                fi
            else
                echo -e "\e[1;31m❌ Instalasi Wine dibatalkan oleh pengguna.\e[0m"
            fi
        fi
    fi
    read -p "Tekan Enter untuk kembali..."
}

manage_app() {
    local app_name="$1"
    local pkg_name="$2"
    local exec_cmd="${3:-$pkg_name}"
    local icon_name="${4:-$pkg_name}"

    if dpkg -l | grep -q "^ii  $pkg_name "; then
        echo -e "\n\e[1;33mStatus: $app_name SUDAH TERPASANG.\e[0m"
        echo -e " \e[1;31m1)\e[0m Uninstall $app_name"
        echo -e " \e[1;36m2)\e[0m Perbaiki / Buat Ulang Shortcut Desktop"
        echo -e " \e[1;37m0)\e[0m Batal"
        read -p " Pilih tindakan [0-2]: " act
        if [ "$act" == "1" ]; then
            echo -e "\e[1;31mMenghapus $app_name...\e[0m"
            pkg uninstall "$pkg_name" -y
            remove_desktop_pin "$app_name"
            echo -e "\e[1;32m✓ Berhasil di-uninstall!\e[0m"
        elif [ "$act" == "2" ]; then
            create_desktop_pin "$app_name" "$exec_cmd" "$icon_name"
            echo -e "\e[1;32m✓ Shortcut Desktop diperbarui!\e[0m"
        fi
    else
        echo -e "\n\e[1;33mStatus: $app_name BELUM TERPASANG.\e[0m"
        echo -e " \e[1;32m1)\e[0m Install $app_name"
        echo -e " \e[1;37m0)\e[0m Batal"
        read -p " Pilih tindakan [0-1]: " act
        if [ "$act" == "1" ]; then
            echo -e "\e[1;34mMengunduh & Menginstall $app_name...\e[0m"
            if pkg install "$pkg_name" -y; then
                create_desktop_pin "$app_name" "$exec_cmd" "$icon_name"
                echo -e "\e[1;32m✓ $app_name Berhasil di-install & dipasang ke Desktop! 📌\e[0m"
            else
                echo -e "\e[1;31m❌ Gagal menginstall $app_name.\e[0m"
            fi
        fi
    fi
    read -p "Tekan Enter untuk kembali..."
}

deep_clean_system() {
    echo -e "\n\e[1;33m🧹 Memulai Pembersihan Mendalam (Deep Clean)...\e[0m"
    
    apt-get clean > /dev/null 2>&1
    apt-get autoclean > /dev/null 2>&1
    rm -rf /data/data/com.termux/files/usr/var/cache/apt/archives/* 2>/dev/null
    rm -rf /tmp/.X* /tmp/.X11-unix /tmp/PulseAudio* /tmp/dbus-* 2>/dev/null
    rm -rf ~/.cache/thumbnails/* 2>/dev/null
    rm -rf ~/.cache/sessions/* 2>/dev/null
    rm -rf ~/.cache/xfce4/desktop/* 2>/dev/null
    
    if [ -d "$HOME/.wine" ]; then
        rm -rf ~/.wine/drive_c/users/$USER/Temp/* 2>/dev/null
        rm -rf ~/.wine/drive_c/windows/temp/* 2>/dev/null
        rm -rf ~/.cache/wine* 2>/dev/null
    fi

    rm -rf ~/.cache/mozilla/firefox/*.default-release/cache2/* 2>/dev/null
    rm -rf ~/.cache/fontconfig/* 2>/dev/null
    
    echo -e "\e[1;32m✓ Seluruh sampah cache XFCE, Wine, APT, & X11 berhasil dibersihkan total!\e[0m"
    read -p "Tekan Enter untuk kembali..."
}

# ============== FUNGSI PILIH GPU XFCE & WINE ==============
menu_gpu_selection() {
    while true; do
        source "$CONFIG_FILE" 2>/dev/null
        source "$WINE_GPU_FILE" 2>/dev/null
        
        clear
        echo -e "\e[1;35m═════════════════════════════════════════════════════\e[0m"
        echo -e "\e[1;36m             🎮 PILIH AKSELERASI GPU 🎮              \e[0m"
        echo -e "\e[1;35m═════════════════════════════════════════════════════\e[0m"
        echo -e " Status Aktif saat ini:"
        echo -e "   • GPU XFCE : \e[1;32m[ ${ALFI_DRIVER_NAME:-Default} ]\e[0m"
        echo -e "   • GPU Wine : \e[1;33m[ Turnip Zink + Mesa: ${WINE_GPU_MODE:-ON} ]\e[0m"
        echo -e "\e[0;90m-----------------------------------------------------\e[0m"
        echo -e "  \e[1;32m1)\e[0m 🖥️  Pengaturan GPU untuk Desktop XFCE"
        echo -e "  \e[1;32m2)\e[0m 🍷 Pengaturan GPU untuk Environment Wine"
        echo -e "  \e[1;31m0)\e[0m ↩️  Kembali ke Menu Utama"
        echo ""
        read -p " Pilih kategori [0-2]: " cat_gpu
        
        case $cat_gpu in
            1)
                clear
                echo -e "\e[1;36m═════════════════════════════════════════════════════\e[0m"
                echo -e "\e[1;33m          🖥️  PILIH GPU DESKTOP XFCE4 🖥️              \e[0m"
                echo -e "\e[1;36m═════════════════════════════════════════════════════\e[0m\n"
                echo -e "  \e[1;37m1)\e[0m llvmpipe (Software Render - CPU)"
                echo -e "     \033[0;90m-> Rendisi penuh via CPU. Sangat stabil & anti-crash di semua HP.\033[0m"
                echo -e "  \e[1;37m2)\e[0m Turnip Zink + Mesa (Vulkan HW)"
                echo -e "     \033[0;90m-> Khusus Snapdragon. Menggunakan akselerasi Vulkan Turnip bawaan.\033[0m"
                echo -e "  \e[1;37m3)\e[0m Panfrost Native (Mali GPU)"
                echo -e "     \033[0;90m-> Khusus Chipset MediaTek / Exynos / Kirin dengan GPU Mali.\033[0m"
                echo -e "  \e[1;37m4)\e[0m Lavapipe (Vulkan CPU Emulator)"
                echo -e "     \033[0;90m-> Emulasi Vulkan software layer berbasis CPU.\033[0m"
                echo -e "  \e[1;37m5)\e[0m Reset GPU Config XFCE"
                echo -e "     \033[0;90m-> Mengembalikan setelan default XFCE ke Safe Mode (llvmpipe).\033[0m"
                echo ""
                read -p " Pilih opsi GPU XFCE [1-5]: " xfce_opt
                case $xfce_opt in
                    1) cat > "$CONFIG_FILE" << 'CONF'
export MESA_LOADER_DRIVER_OVERRIDE=llvmpipe
export GALLIUM_DRIVER=llvmpipe
export ALFI_DRIVER_NAME="llvmpipe (Safe Mode)"
CONF
                    ;;
                    2) cat > "$CONFIG_FILE" << 'CONF'
export MESA_NO_ERROR=1
export MESA_GL_VERSION_OVERRIDE=4.6
export MESA_GLES_VERSION_OVERRIDE=3.2
export GALLIUM_DRIVER=zink
export MESA_LOADER_DRIVER_OVERRIDE=zink
export TU_DEBUG=noconform
export ALFI_DRIVER_NAME="Turnip Zink + Mesa"
CONF
                    ;;
                    3) cat > "$CONFIG_FILE" << 'CONF'
export GALLIUM_DRIVER=panfrost
export MESA_GL_VERSION_OVERRIDE=3.3
export MESA_GLES_VERSION_OVERRIDE=3.1
export PAN_MESA_DEBUG=sync
export ALFI_DRIVER_NAME="Panfrost Native (Mali)"
CONF
                    ;;
                    4) cat > "$CONFIG_FILE" << 'CONF'
export VK_ICD_FILENAMES=$PREFIX/share/vulkan/icd.d/lvp_icd.aarch64.json
export GALLIUM_DRIVER=llvmpipe
export ALFI_DRIVER_NAME="Lavapipe"
CONF
                    ;;
                    5) rm -f "$CONFIG_FILE"; set_default_gpu ;;
                esac
                ;;
            2)
                clear
                echo -e "\e[1;36m═════════════════════════════════════════════════════\e[0m"
                echo -e "\e[1;33m          🍷 PILIH GPU ENVIRONMENT WINE 🍷           \e[0m"
                echo -e "\e[1;36m═════════════════════════════════════════════════════\e[0m\n"
                echo -e "  \e[1;37m1)\e[0m Turnip Zink + Mesa \e[1;32m[ ON ]\e[0m"
                echo -e "     \033[0;90m-> Mengaktifkan akselerasi 3D OpenGL 4.6 & Vulkan Turnip.\033[0m"
                echo -e "     \033[0;90m-> Terbaik untuk game 3D (Snapdragon) agar FPS lebih tinggi.\033[0m"
                echo -e "  \e[1;37m2)\e[0m Turnip Zink + Mesa \e[1;31m[ OFF ]\e[0m (Wine Native Standard)"
                echo -e "     \033[0;90m-> Mematikan Turnip & Zink, kembali ke driver bawaan Wine.\033[0m"
                echo -e "     \033[0;90m-> Gunakan mode ini jika game force-close atau error grafis.\033[0m"
                echo -e "  \e[1;37m3)\e[0m Buat / Perbarui Shortcut Switcher di Desktop XFCE"
                echo -e "     \033[0;90m-> Menambahkan 2 ikon shortcut di layar desktop agar bisa\033[0m"
                echo -e "     \033[0;90m   ganti mode Turnip (ON/OFF) dengan 1-klik tanpa keluar XFCE.\033[0m"
                echo ""
                read -p " Pilih opsi GPU Wine [1-3]: " wine_opt
                case $wine_opt in
                    1)
                        echo 'export WINE_GPU_MODE="ON"' > "$WINE_GPU_FILE"
                        echo -e "\e[1;32m✓ GPU Wine di-set ke Mode: Turnip Zink + Mesa (ON)\e[0m"
                        sleep 1
                        ;;
                    2)
                        echo 'export WINE_GPU_MODE="OFF"' > "$WINE_GPU_FILE"
                        echo -e "\e[1;33m✓ GPU Wine di-set ke Mode: Native Standard (OFF)\e[0m"
                        sleep 1
                        ;;
                    3)
                        create_wine_gpu_shortcuts
                        read -p "Tekan Enter untuk kembali..."
                        ;;
                esac
                ;;
            0) break ;;
        esac
    done
}

# ============== LOOP MENU UTAMA ==============
while true; do
    source "$CONFIG_FILE" 2>/dev/null
    source "$WINE_GPU_FILE" 2>/dev/null
    clear
    echo -e "\e[1;36m┌───────────────────────────────────────────┐\e[0m"
    echo -e "\e[1;36m│       \e[1;33m🚀 AlfiStoreID XFCE v3.1 🚀         \e[1;36m│\e[0m"
    echo -e "\e[1;36m├───────────────────────────────────────────┤\e[0m"
    echo -e "\e[1;36m│\e[0m \e[1;32m1)\e[0m 🎮 Pilih Akselerasi GPU (XFCE & Wine)  \e[1;36m│\e[0m"
    echo -e "\e[1;36m│\e[0m \e[1;32m2)\e[0m 🔍 Cek Status Rendisi GPU              \e[1;36m│\e[0m"
    echo -e "\e[1;36m│\e[0m \e[1;32m3)\e[0m 📦 Manajer Aplikasi (Auto-Pin)         \e[1;36m│\e[0m"
    echo -e "\e[1;36m│\e[0m \e[1;32m4)\e[0m 🧹 Bersihkan Cache Total (Deep Clean)  \e[1;36m│\e[0m"
    echo -e "\e[1;36m│\e[0m \e[1;32m5)\e[0m ℹ️  Tentang (About & ChangeLog)         \e[1;36m│\e[0m"
    echo -e "\e[1;36m│\e[0m \e[1;32m6)\e[0m ▶️  Mulai Desktop XFCE                  \e[1;36m│\e[0m"
    echo -e "\e[1;36m│\e[0m \e[1;32m7)\e[0m 🛑 Hentikan Desktop                     \e[1;36m│\e[0m"
    echo -e "\e[1;36m│\e[0m \e[1;31m0)\e[0m ❌ Keluar                              \e[1;36m│\e[0m"
    echo -e "\e[1;36m└───────────────────────────────────────────┘\e[0m"
    echo -e "   \e[1;35mGPU XFCE : [ ${ALFI_DRIVER_NAME:-Default} ]\e[0m"
    echo -e "   \e[1;33mGPU Wine : [ Turnip Zink: ${WINE_GPU_MODE:-ON} ]\e[0m"
    echo ""
    read -p " Pilih opsi [0-7]: " choice
    
    case $choice in
        1) 
            menu_gpu_selection
            ;;
        2) 
            echo ""
            source "$CONFIG_FILE" 2>/dev/null
            export DISPLAY=:0
            INFO=$(timeout 4 glxinfo -B 2>/dev/null)
            if [ -n "$INFO" ]; then
                echo "$INFO" | grep -E -i "Device|OpenGL vendor|OpenGL renderer|OpenGL version|Accelerated"
            else
                echo -e "\e[1;33m⚠️ Driver XFCE: $ALFI_DRIVER_NAME\e[0m"
                echo -e "\e[1;33m⚠️ Mode Wine GPU: Turnip Zink ($WINE_GPU_MODE)\e[0m"
            fi
            read -p "Tekan Enter untuk kembali..."
            ;;
        3)
            while true; do
                clear
                echo -e "\e[1;33m📦 MANAJER APLIKASI (Auto-Pin Desktop)\e[0m"
                echo -e "\e[0;90m-----------------------------------------------------\e[0m"
                printf " \e[1;35m1)\e[0m %-22s | %s\n" "Wine Environment (Box64)" "$(check_status hangover-wine)"
                printf " \e[1;37m2)\e[0m %-22s | %s\n" "Firefox Browser" "$(check_status firefox)"
                printf " \e[1;37m3)\e[0m %-22s | %s\n" "Synaptic Package Manager" "$(check_status synaptic)"
                printf " \e[1;37m4)\e[0m %-22s | %s\n" "VS Code (Code-OSS)" "$(check_status code-oss)"
                printf " \e[1;37m5)\e[0m %-22s | %s\n" "GIMP Photo Editor" "$(check_status gimp)"
                printf " \e[1;37m6)\e[0m %-22s | %s\n" "Parole Media Player" "$(check_status parole)"
                printf " \e[1;37m7)\e[0m %-22s | %s\n" "GLMark2 (Cek FPS GPU)" "$(check_status glmark2)"
                printf " \e[1;37m8)\e[0m %-22s | %s\n" "Htop System Monitor" "$(check_status htop)"
                printf " \e[1;37m9)\e[0m %-22s | %s\n" "Inkscape Vector" "$(check_status inkscape)"
                printf " \e[1;37m10)\e[0m %-21s | %s\n" "Geany IDE Text Editor" "$(check_status geany)"
                printf " \e[1;37m11)\e[0m %-21s | %s\n" "LibreOffice Suite" "$(check_status libreoffice)"
                printf " \e[1;37m12)\e[0m %-21s | %s\n" "Fastfetch SysInfo" "$(check_status fastfetch)"
                echo -e "\e[0;90m-----------------------------------------------------\e[0m"
                echo -e " \e[1;31m0)\e[0m Kembali ke Menu Utama"
                read -p " Pilih aplikasi [0-12]: " app_choice

                case $app_choice in
                    1) manage_wine ;;
                    2) manage_app "Firefox Browser" "firefox" "firefox" "firefox" ;;
                    3) manage_app "Synaptic Manager" "synaptic" "synaptic" "synaptic" ;;
                    4) manage_app "VS Code" "code-oss" "code-oss" "code-oss" ;;
                    5) manage_app "GIMP Editor" "gimp" "gimp" "gimp" ;;
                    6) manage_app "Parole Player" "parole" "parole" "parole" ;;
                    7) manage_app "GLMark2" "glmark2" "glmark2" "glmark2" ;;
                    8) manage_app "Htop Monitor" "htop" "xfce4-terminal -e htop" "utilities-system-monitor" ;;
                    9) manage_app "Inkscape" "inkscape" "inkscape" "inkscape" ;;
                    10) manage_app "Geany Editor" "geany" "geany" "geany" ;;
                    11) manage_app "LibreOffice" "libreoffice" "libreoffice" "libreoffice-main" ;;
                    12) manage_app "Fastfetch" "fastfetch" "xfce4-terminal -e 'fastfetch; read'" "utilities-terminal" ;;
                    0) break ;;
                esac
            done
            ;;
        4)
            deep_clean_system
            ;;
        5) 
            clear
            echo -e "\e[1;36m═════════════════════════════════════════════════════\e[0m"
            echo -e "\e[1;33m            ℹ️  TENTANG & CATATAN PERUBAHAN           \e[0m"
            echo -e "\e[1;36m═════════════════════════════════════════════════════\e[0m"
            echo -e "  \e[1;37mPembuat : \e[1;32mAlfiStoreID\e[0m"
            echo -e "  \e[1;37mNo WA   : \e[1;32m085223659782\e[0m"
            echo -e "  \e[1;37mVersi   : \e[1;36m3.1\e[0m"
            echo -e "\e[0;90m-----------------------------------------------------\e[0m"
            echo -e "  \e[1;33m📌 FITUR UTAMA & CHANGELOG v3.1:\e[0m"
            echo -e "  • \e[1;32m[Baru]\e[0m Penghapusan Telegram Desktop dari Manajer Aplikasi."
            echo -e "  • \e[1;32m[Baru]\e[0m Penambahan Synaptic Package Manager (Installer GUI Aplikasi)."
            echo -e "  • \e[1;32m[Baru]\e[0m Pembersihan sisa paket & manager aplikasi yang tidak perlu."
            echo -e "  • \e[1;32m[Baru]\e[0m Perbaiki daemon dan ada perintah penutup."
            echo -e "  • \e[1;32m[Baru]\e[0m Fix Issue Android 15+ (Eksperimental)."
            echo -e "\e[1;36m═════════════════════════════════════════════════════\e[0m"
            read -p "Tekan Enter untuk kembali..." 
            ;;
        6) 
            clear
            echo -e "\e[1;36m┌──────────────────────────────────────────────────────────┐\e[0m"
            echo -e "\e[1;36m│                \e[1;33m▶️  MEMULAI DESKTOP XFCE                  \e[1;36m│\e[0m"
            echo -e "\e[1;36m└──────────────────────────────────────────────────────────┘\e[0m"
            echo -e "\e[1;33m💡 INFORMASI MASALAH PERBAIKAN (Android 15+):\e[0m"
            echo -e "\e[0;37m Apabila Termux:X11 mengalami \e[1;31mBlack Screen\e[0;37m, \e[1;31mCrash\e[0;37m, atau XFCE\e[0m"
            echo -e "\e[0;37m gagal merender tampilan, disarankan untuk menggunakan mode\e[0m"
            echo -e "\e[1;32m Split Screen (Layar Berbagi)\e[0;37m antara Termux dan Termux:X11\e[0m"
            echo -e "\e[0;37m melalui Recent Apps sistem HP Anda untuk stabilitas penuh.\e[0m"
            echo -e "\e[0;90m----------------------------------------------------------\e[0m"
            echo -e "  \e[1;32m1)\e[0m Jalankan Desktop"
            echo -e "  \e[1;31m2)\e[0m Kembali ke Menu Utama"
            echo ""
            read -p " Pilih opsi [1-2]: " run_opt
            if [ "$run_opt" == "1" ]; then
                rm -rf /tmp/.X* /tmp/.X11-unix 2>/dev/null
                source "$CONFIG_FILE" 2>/dev/null
                export DISPLAY=:0
                termux-x11 :0 -ac > /dev/null 2>&1 &
                sleep 1.5
                am start --user 0 -n com.termux.x11/com.termux.x11.MainActivity > /dev/null 2>&1
                sleep 1
                eval $(dbus-launch --sh-syntax)
                export DBUS_SESSION_BUS_ADDRESS
                export DBUS_SESSION_BUS_PID
                echo -e "\e[1;32m✓ Desktop aktif!\e[0m"
                startxfce4 > /dev/null 2>&1 &
                echo ""
                read -p "Tekan Enter untuk kembali ke menu..."
            fi
            ;;
        7) 
            pkill -9 -f "termux.x11" 2>/dev/null
            pkill -9 -f "startxfce4" 2>/dev/null
            pkill -9 -f "xfce4-session" 2>/dev/null
            pkill -9 -f "xfwm4" 2>/dev/null
            pkill -9 -f "xfdesktop" 2>/dev/null
            pkill -9 -f "dbus-daemon" 2>/dev/null
            rm -rf /tmp/.X0-lock /tmp/.X11-unix 2>/dev/null
            echo -e "\e[1;32m✓ Desktop Dihentikan.\e[0m"
            echo ""
            read -p "Tekan Enter untuk kembali ke menu..."
            ;;
        0) exit 0 ;;
    esac
done
ALFIEOF

    chmod +x /data/data/com.termux/files/usr/bin/fi-xfce.sh
    ln -sf /data/data/com.termux/files/usr/bin/fi-xfce.sh /data/data/com.termux/files/usr/bin/fi-xfce 2>/dev/null
    echo -e "  ${GREEN}✓${NC} Berhasil membuat sistem menu fi-xfce.sh v3.1!"
}


# ============== BUAT SHORTCUT DESKTOP UTAMA ==============
step_shortcuts() {
    update_progress
    echo -e "${PURPLE}[Langkah ${CURRENT_STEP}/${TOTAL_STEPS}] Membuat Shortcut Desktop Utama...${NC}"
    echo ""
    mkdir -p ~/Desktop

    cat > ~/Desktop/FirefoxBrowser.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Firefox Browser
Exec=firefox
Icon=firefox
Terminal=false
StartupNotify=true
Categories=Utility;Application;
EOF

    cat > ~/Desktop/Terminal.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Terminal
Exec=xfce4-terminal
Icon=utilities-terminal
Terminal=false
StartupNotify=true
Categories=Utility;Application;
EOF

    chmod +x ~/Desktop/*.desktop 2>/dev/null
}

# ============== TAMPILAN SELESAI ==============
show_completion() {
    echo ""
    echo -e "${GREEN}┌──────────────────────────────────────────────────────────┐${NC}"
    echo -e "${GREEN}│${WHITE}              ✅ INSTALLASI SELESAI! ✅                  ${GREEN}│${NC}"
    echo -e "${GREEN}└──────────────────────────────────────────────────────────┘${NC}"
    echo -e "${WHITE}📱 Lingkungan Desktop dari AlfiStoreID siap digunakan!${NC}"
    echo ""
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${WHITE}🔥 CARA MENGGUNAKAN:${NC}"
    echo -e "Ketik perintah berikut di Termux:"
    echo -e "   ${GREEN}fi-xfce${NC}  atau  ${GREEN}fi-xfce.sh${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# ============== EKSEKUSI UTAMA ==============
main() {
    show_banner
    echo -e "${WHITE}  Skrip ini akan menginstall Lingkungan Desktop Linux XFCE${NC}"
    echo -e "${WHITE}  lengkap dengan Sistem Manager (fi-xfce.sh v3.1) by AlfiStoreID.${NC}"
    echo ""
    echo -e "${YELLOW}  Tekan Enter untuk memulai, atau Ctrl+C untuk membatalkan...${NC}"
    read
    
    detect_device
    step_update
    step_repos
    step_x11
    step_desktop
    step_gpu
    step_audio
    step_apps
    step_launchers
    step_shortcuts
    
    show_completion
}

main
