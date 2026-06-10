#!/bin/bash

# ==================================================
# SCRIPT BY SRS TEAM MODS
# Telegram CH: t.me/SARASUKCH
# TG: @SARASUK17
# ==================================================

# 🎨 การตั้งค่าสีสันหน้าเมนู (ANSI Colors)
BLUE="\033[1;34m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
PURPLE="\033[1;35m"
RESET="\033[0m"

# 📂 การตั้งค่าพาธโฟลเดอร์ทำงานหลัก (Storage Paths)
IMG_INPUT="/storage/emulated/0/Image/"
IMG_WHITE_OUTPUT="/storage/emulated/0/White_Image/"
H_OUTPUT="/storage/emulated/0/PNG2H/"
FONT_INPUT="/storage/emulated/0/Fonts/"

# ⚙️ ฟังก์ชันสำหรับสร้างโฟลเดอร์เริ่มต้นอัตโนมัติ
init_folders() {
    mkdir -p "$IMG_INPUT"
    mkdir -p "$IMG_WHITE_OUTPUT"
    mkdir -p "$H_OUTPUT"
    mkdir -p "$FONT_INPUT"
}

# 🖼️ ฟังก์ชันจำลอง Progress Bar เพื่อความสวยงามเท่ๆ
show_progress() {
    local duration=1
    local col=$(tput cols)
    local bar_size=$((col / 2))
    echo -ne " ${YELLOW}กำลังประมวลผล: [${RESET}"
    for ((i=0; i<bar_size; i++)); do
        echo -ne "${GREEN}▓${RESET}"
        sleep 0.01
    done
    echo -e "${YELLOW}] 100% ✅${RESET}"
}

# 📱 หน้ากากเมนูหลัก (Main UI Menu)
show_menu() {
    clear
    echo -e "${BLUE}==================================================${RESET}"
    echo -e "${RED}  ____  ____  ____   _____ _____    _    __  __ "
    echo " / ___||  _ \/ ___| |_   _| ____|  / \  |  \/  |"
    echo " \___ \| |_) \___ \   | | |  _|   / _ \ | |\/| |"
    echo "  ___) |  _ < ___) |  | | | |___ / ___ \| |  | |"
    echo " |____/|_| \_\____/   |_| |_____/_/   \_\_|  |_| ${RESET}"
    echo -e "${BLUE}==================================================${RESET}"
    echo -e "${PURPLE}           SRS TEAM MODS - MULTI TOOL v2.0        ${RESET}"
    echo -e "${BLUE}==================================================${RESET}"
    echo -e " ${YELLOW}[1]${RESET} ย้อมสีรูปภาพ PNG ให้เป็นสีขาวล้วน (Silhouette)"
    echo -e " ${YELLOW}[2]${RESET} แปลงรูปภาพ PNG เป็นไฟล์โค้ด (.h) ฐานสิบหก"
    echo -e " ${YELLOW}[3]${RESET} แปลงไฟล์ฟอนต์ (.ttf) เป็นไฟล์โค้ด (.h)"
    echo -e " ${RED}[4]${RESET} ล้างไฟล์ขยะชั่วคราวในโฟลเดอร์ทั้งหมด"
    echo -e " ${CYAN}[5]${RESET} ตรวจสอบและอัปเดตเครื่องมือผ่าน GitHub"
    echo -e " ${GREEN}[6]${RESET} ตรวจสอบ/ติดตั้งเครื่องมือที่จำเป็น (Setup Env)"
    echo -e " ${RED}[0]${RESET} ออกจากโปรแกรม"
    echo -e "${BLUE}==================================================${RESET}"
    echo -n "กรุณากรอกตัวเลขเลือกเมนู [0-6]: "
}

# 🛠️ [เมนู 1] ย้อมรูปขาวล้วน (แต่หลังโปร่งใส)
menu_convert_white() {
    clear
    echo -e "${BLUE}=== [1] ย้อมสีรูปภาพเป็นสีขาวล้วน ===${RESET}"
    if ! command -v convert &> /dev/null; then
        echo -e "${RED}❌ ไม่พบแพ็กเกจ ImageMagick! กรุณากดเมนู 6 เพื่อติดตั้งก่อน${RESET}"
        read -p "กด Enter เพื่อกลับ..." && return
    fi
    
    local count=0
    echo -e "${CYAN}กำลังดึงรูปภาพจาก: $IMG_INPUT ...${RESET}"
    
    for image_file in "$IMG_INPUT"*.png; do
        if [ -f "$image_file" ]; then
            file_name=$(basename "$image_file")
            convert "$image_file" -fill white -colorize 100% "$IMG_WHITE_OUTPUT$file_name"
            echo -e "${GREEN}สำเร็จ：$file_name -> เปลี่ยนเป็นสีขาวแล้ว ✅${RESET}"
            ((count++))
        fi
    done
    
    if [ $count -eq 0 ]; then
        echo -e "${RED}❌ ไม่พบไฟล์รูปภาพ .png ในโฟลเดอร์ $IMG_INPUT${RESET}"
    else
        show_progress
        echo -e "${GREEN}\n🎉 ย้อมรูปภาพเสร็จสิ้นจำนวน $count รูป! ไฟล์อยู่ที่: $IMG_WHITE_OUTPUT${RESET}"
    fi
    read -p "กด Enter เพื่อกลับหน้าเมนูหลัก..."
}

# 💾 [เมนู 2] แปลงรูปภาพ PNG เป็น .h (xxd)
menu_convert_image_h() {
    clear
    echo -e "${BLUE}=== [2] แปลงรูปภาพ PNG เป็นไฟล์โค้ด .h ===${RESET}"
    
    echo -e "${YELLOW}เลือกแหล่งรูปภาพต้นทางที่ต้องการแปลง:${RESET}"
    echo " 1) ใช้รูปภาพดั้งเดิม (โฟลเดอร์ Image)"
    echo " 2) ใช้รูปภาพที่ย้อมสีขาวแล้ว (โฟลเดอร์ White_Image)"
    echo -n "เลือก [1 หรือ 2]: "
    read source_choice

    local SOURCE_DIR="$IMG_INPUT"
    if [ "$source_choice" == "2" ]; then
        SOURCE_DIR="$IMG_WHITE_OUTPUT"
    fi

    # เคลียร์และสร้างไฟล์สารบัญใหม่
    > "$H_OUTPUT/include.txt"
    > "$H_OUTPUT/createtexture.txt"
    > "$H_OUTPUT/TextureInfo.h"

    local count=0
    for image_file in "$SOURCE_DIR"*.png; do
        if [ -f "$image_file" ]; then
            binary_data=$(xxd -i -c 16 "$image_file")
            file_name=$(basename "$image_file" .png)
            variable_name="${file_name}_data"
            output_file="$H_OUTPUT${file_name}.h"
            
            header_content="unsigned char $variable_name[] = {
$binary_data
};

"
            echo "$header_content" > "$output_file"
            echo -e "${GREEN}Done：$file_name -> ${file_name}.h ✅${RESET}"

            # บันทึกลงไฟล์อำนวยความสะดวกฝั่ง C++
            echo "#include \"IMAGE/${file_name}.h\"" >> "$H_OUTPUT/include.txt"
            echo "${file_name} = CreateTexture($variable_name, sizeof($variable_name));" >> "$H_OUTPUT/createtexture.txt"
            echo "TextureInfo ${file_name};" >> "$H_OUTPUT/TextureInfo.h"
            ((count++))
        fi
    done

    if [ $count -eq 0 ]; then
        echo -e "${RED}❌ ไม่พบไฟล์รูปภาพในโฟลเดอร์ปลายทางที่เลือก!${RESET}"
    else
        show_progress
        echo -e "${GREEN}\n🎉 เข้ารหัสไฟล์สำเร็จจำนวน $count ไฟล์! สรุปโค้ดอยู่ที่: $H_OUTPUT${RESET}"
    fi
    read -p "กด Enter เพื่อกลับหน้าเมนูหลัก..."
}

# 🔤 [เมนู 3] แปลงฟอนต์ .ttf เป็น .h
menu_convert_font_h() {
    clear
    echo -e "${BLUE}=== [3] แปลงไฟล์ฟอนต์ .ttf เป็น .h ===${RESET}"
    local count=0
    
    for font_file in "$FONT_INPUT"*.ttf; do
        if [ -f "$font_file" ]; then
            f_name=$(basename "$font_file" .ttf)
            xxd -i -c 16 "$font_file" > "${FONT_INPUT}${f_name}.h"
            echo -e "${GREEN}สำเร็จ: $f_name.ttf -> $f_name.h ✅${RESET}"
            ((count++))
        fi
    done

    if [ $count -eq 0 ]; then
        echo -e "${RED}❌ ไม่พบไฟล์ฟอนต์ .ttf ในโฟลเดอร์ $FONT_INPUT${RESET}"
    else
        show_progress
        echo -e "${GREEN}\n🎉 แปลงไฟล์ฟอนต์สำเร็จจำนวน $count ฟอนต์!${RESET}"
    fi
    read -p "กด Enter เพื่อกลับหน้าเมนูหลัก..."
}

# 🗑️ [เมนู 4] ล้างไฟล์ขยะชั่วคราว
menu_clean_garbage() {
    clear
    echo -e "${RED}=== [4] กำลังล้างระบบและไฟล์ขยะชั่วคราว ===${RESET}"
    
    # ล้างไฟล์ .tmp หากมีหลงเหลืออยู่
    rm -rf "$IMG_INPUT"*.tmp.png
    rm -rf "$IMG_WHITE_OUTPUT"*.tmp.png
    
    show_progress
    echo -e "${GREEN}✅ ล้างไฟล์แคชและขยะในระบบเสร็จสมบูรณ์!${RESET}"
    read -p "กด Enter เพื่อกลับหน้าเมนูหลัก..."
}

# 🔄 [เมนู 5] ระบบอัปเดต Pull จาก GitHub ตัวเองอัตโนมัติ
menu_update_git() {
    clear
    echo -e "${YELLOW}=== [5] ระบบตรวจสอบการอัปเดตจาก GitHub ===${RESET}"
    if [ -d ".git" ]; then
        echo -e "${CYAN}กำลังเชื่อมต่อไปยัง Repository เพื่อตรวจสอบเวอร์ชันใหม่...${RESET}"
        git pull origin main
        chmod +x tool.sh
        echo -e "${GREEN}✅ ซิงค์ข้อมูลกับ GitHub เป็นเวอร์ชันล่าสุดเรียบร้อยแล้ว!${RESET}"
    else
        echo -e "${RED}❌ สคริปต์นี้ไม่ได้เปิดผ่านคำสั่ง 'git clone' ไม่สามารถดึงอัปเดตแบบอัตโนมัติได้${RESET}"
    fi
    read -p "กด Enter เพื่อกลับหน้าเมนูหลัก..."
}

# 📦 [เมนู 6] ติดตั้งสภาพแวดล้อม Termux สำหรับผู้ใช้ใหม่
menu_setup_env() {
    clear
    echo -e "${CYAN}=== [6] เริ่มต้นตั้งค่าและติดตั้งความต้องการของระบบ ===${RESET}"
    echo -e "${YELLOW}กรุณารอระบบทำการอัปเดตและลงแพ็กเกจสักครู่...${RESET}"
    
    pkg update && pkg upgrade -y
    pkg install git imagemagick build-essential ncurses-utils -y
    termux-setup-storage
    
    init_folders
    echo -e "${GREEN}\n✅ สภาพแวดล้อมระบบและโฟลเดอร์ทั้งหมดถูกเปิดสิทธิ์และตั้งค่าพร้อมลุยแล้ว!${RESET}"
    read -p "กด Enter เพื่อกลับหน้าเมนูหลัก..."
}

# 🔄 ลูปการทำงานหลัก (Main Life-Cycle Loop)
init_folders
while true; do
    show_menu
    read choice
    case $choice in
        1) menu_convert_white ;;
        2) menu_convert_image_h ;;
        3) menu_convert_font_h ;;
        4) menu_clean_garbage ;;
        5) menu_update_git ;;
        6) menu_setup_env ;;
        0) 
            echo -e "${GREEN}\nขอบคุณที่ใช้บริการเครื่องมือจาก SRS TEAM MODS! แล้วเจอกันใหม่ครับ 👋${RESET}"
            exit 0 
            ;;
        *) 
            echo -e "${RED}\n❌ ป้อนตัวเลขไม่ถูกต้อง! กรุณาเลือกเมนูที่มีอยู่ (0-6)${RESET}"
            sleep 1.2
            ;;
    esac
done
