#!/bin/bash

# 🔍 Script kiểm tra status của app icons

echo "🔍 KIỂM TRA APP ICON STATUS"
echo "================================"
echo ""

# Check if source icon exists
ICON_FILE="assets/app_icon.png"

if [ -f "$ICON_FILE" ]; then
    echo "✅ Source icon: FOUND ($ICON_FILE)"
    if command -v identify &> /dev/null; then
        DIMS=$(identify -format "%wx%h" "$ICON_FILE" 2>/dev/null)
        SIZE=$(identify -format "%b" "$ICON_FILE" 2>/dev/null)
        echo "   📐 Size: $DIMS"
        echo "   💾 File size: $SIZE"
    fi
else
    echo "❌ Source icon: NOT FOUND"
    echo "   📝 Cần đặt icon vào: $ICON_FILE"
fi

echo ""

# Check Android icons
echo "📱 Android Icons:"
ANDROID_ICON="android/app/src/main/res/mipmap-hdpi/ic_launcher.png"
if [ -f "$ANDROID_ICON" ]; then
    echo "   ✅ Generated"
    COUNT=$(find android/app/src/main/res/mipmap-* -name "ic_launcher.png" 2>/dev/null | wc -l)
    echo "   📊 Found $COUNT icon files across densities"
else
    echo "   ❌ Not generated yet"
    echo "   💡 Run: ./setup_icon.sh"
fi

echo ""

# Check iOS icons
echo "🍎 iOS Icons:"
IOS_ICON="ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png"
if [ -f "$IOS_ICON" ]; then
    echo "   ✅ Generated"
    COUNT=$(find ios/Runner/Assets.xcassets/AppIcon.appiconset -name "*.png" 2>/dev/null | wc -l)
    echo "   📊 Found $COUNT icon files"
else
    echo "   ❌ Not generated yet"
    echo "   💡 Run: ./setup_icon.sh"
fi

echo ""

# Check Web icons
echo "🌐 Web Icons:"
WEB_ICON="web/icons/Icon-512.png"
if [ -f "$WEB_ICON" ]; then
    echo "   ✅ Generated"
    if [ -f "web/favicon.png" ]; then
        echo "   ✅ Favicon generated"
    fi
    COUNT=$(find web/icons -name "*.png" 2>/dev/null | wc -l)
    echo "   📊 Found $COUNT icon files"
else
    echo "   ❌ Not generated yet"
    echo "   💡 Run: ./setup_icon.sh"
fi

echo ""
echo "================================"

# Summary
if [ -f "$ANDROID_ICON" ] && [ -f "$IOS_ICON" ] && [ -f "$WEB_ICON" ]; then
    echo "✅ All icons generated successfully!"
    echo ""
    echo "🚀 Ready to run:"
    echo "   flutter run"
elif [ ! -f "$ICON_FILE" ]; then
    echo "⚠️  Next step: Place your icon at $ICON_FILE"
    echo ""
    echo "📝 Then run:"
    echo "   ./setup_icon.sh"
else
    echo "⚠️  Icons need to be generated"
    echo ""
    echo "🚀 Run:"
    echo "   ./setup_icon.sh"
fi

echo ""
