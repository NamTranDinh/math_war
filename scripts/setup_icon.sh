#!/bin/bash

# 🎨 Math War - Icon Setup Script
# Script tự động generate app icon cho Android, iOS và Web

set -e  # Exit on error

echo "🎮 MATH WAR - Icon Generator"
echo "================================"
echo ""

# Check if icon file exists
ICON_FILE="assets/app_icon.png"

if [ ! -f "$ICON_FILE" ]; then
    echo "❌ Error: Icon file not found!"
    echo ""
    echo "📝 Cần làm:"
    echo "1. Lưu icon của bạn vào: $ICON_FILE"
    echo "2. Kích thước đề xuất: 1024x1024 px hoặc lớn hơn"
    echo "3. Format: PNG"
    echo ""
    echo "💡 Sau khi có file icon, chạy lại script này."
    exit 1
fi

# Get icon dimensions
if command -v identify &> /dev/null; then
    DIMENSIONS=$(identify -format "%wx%h" "$ICON_FILE")
    echo "✅ Tìm thấy icon: $ICON_FILE"
    echo "📐 Kích thước: $DIMENSIONS"
    echo ""
else
    echo "✅ Tìm thấy icon: $ICON_FILE"
    echo ""
fi

# Step 1: Install dependencies
echo "📦 Step 1/4: Installing dependencies..."
flutter pub get

echo ""
echo "🎨 Step 2/4: Generating app icons..."
dart run flutter_launcher_icons

echo ""
echo "🧹 Step 3/4: Cleaning build cache..."
flutter clean

echo ""
echo "✅ Step 4/4: Done!"
echo ""
echo "================================"
echo "🎉 Icon đã được generate thành công!"
echo ""
echo "📱 Platform:"
echo "  ✅ Android: android/app/src/main/res/mipmap-*/"
echo "  ✅ iOS: ios/Runner/Assets.xcassets/AppIcon.appiconset/"
echo "  ✅ Web: web/icons/ và web/favicon.png"
echo ""
echo "🚀 Để test:"
echo "  flutter run"
echo ""
echo "💡 Nếu icon không hiển thị:"
echo "  - Android: Uninstall app và install lại"
echo "  - iOS: Clean build folder: cd ios && rm -rf Pods Podfile.lock && cd .."
echo "  - Web: Clear browser cache"
echo ""
