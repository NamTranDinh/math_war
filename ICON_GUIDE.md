# 🎮 Math War - Đổi App Icon

## 🚀 Quick Start (3 Bước)

### Bước 1: Lưu Icon
Lưu hình icon của bạn (file PNG đính kèm) vào:
```
assets/app_icon.png
```

**Yêu cầu:**
- Kích thước: Tối thiểu **1024x1024 px** (tốt nhất 2048x2048 px)
- Format: PNG
- Nền: Có thể trong suốt hoặc màu nền

### Bước 2: Chạy Script Tự Động
```bash
./scripts/setup_icon.sh
```

Script sẽ tự động:
- ✅ Cài đặt dependencies
- ✅ Generate icon cho Android, iOS, Web
- ✅ Clean build cache

### Bước 3: Test App
```bash
flutter run
```

---

## 📱 Icon Sẽ Được Tạo Ở Đâu?

### Android
- `android/app/src/main/res/mipmap-hdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-mdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xhdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xxhdpi/ic_launcher.png`
- `android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png`
- Adaptive icon (Android 8.0+): foreground + background

### iOS
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
  - Icon-App-20x20@2x.png
  - Icon-App-29x29@2x.png
  - Icon-App-40x40@2x.png
  - Icon-App-60x60@2x.png
  - Icon-App-60x60@3x.png
  - Icon-App-76x76@1x.png
  - Icon-App-76x76@2x.png
  - Icon-App-83.5x83.5@2x.png
  - Icon-App-1024x1024@1x.png

### Web
- `web/icons/Icon-192.png`
- `web/icons/Icon-512.png`
- `web/icons/Icon-maskable-192.png`
- `web/icons/Icon-maskable-512.png`
- `web/favicon.png`

---

## 🔧 Cách Manual (Không Dùng Script)

### 1. Install package
```bash
flutter pub add dev:flutter_launcher_icons
```

### 2. Generate icons
```bash
flutter pub get
dart run flutter_launcher_icons
```

### 3. Clean & rebuild
```bash
flutter clean
flutter run
```

---

## 🐛 Troubleshooting

### Icon không hiển thị trên Android?
```bash
# Uninstall app cũ
adb uninstall com.example.math_war

# Hoặc uninstall thủ công trên device
# Rồi chạy lại: flutter run
```

### Icon không hiển thị trên iOS?
```bash
cd ios
rm -rf Pods Podfile.lock Build
pod install
cd ..
flutter clean
flutter run
```

### Icon không hiển thị trên Web?
- Clear browser cache (Ctrl+Shift+Del)
- Hard refresh (Ctrl+Shift+R hoặc Cmd+Shift+R)

### Icon bị mờ/vỡ?
- Đảm bảo icon gốc có kích thước đủ lớn (≥1024x1024)
- Sử dụng file PNG chất lượng cao
- Không resize từ file nhỏ lên lớn

---

## 🎨 Tips Cho Icon Đẹp

1. **Thiết kế đơn giản:** Icon nhỏ nên tránh quá nhiều chi tiết
2. **Màu sắc nổi bật:** Dễ nhận diện trên nhiều nền khác nhau
3. **Không dùng text:** Text khó đọc khi icon nhỏ
4. **Safe zone:** Để margin 10% xung quanh, tránh bị crop
5. **Test nhiều kích thước:** Xem icon ở 16px, 48px, 512px

---

## 📝 Cấu Hình Hiện Tại

File `pubspec.yaml` đã được cấu hình:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  web:
    generate: true
    image_path: "assets/app_icon.png"
    background_color: "#ffffff"
    theme_color: "#FF6B00"
  image_path: "assets/app_icon.png"
  adaptive_icon_background: "#ffffff"
  adaptive_icon_foreground: "assets/app_icon.png"
  remove_alpha_ios: true
```

**Thay đổi màu nền:** Sửa `adaptive_icon_background` và `background_color`

---

## ⚡ Commands Tóm Tắt

```bash
# Tất cả trong 1 command:
./setup_icon.sh

# Hoặc từng bước:
flutter pub get
dart run flutter_launcher_icons
flutter clean
flutter run
```

---

## 📚 Tài Liệu Tham Khảo

- [flutter_launcher_icons package](https://pub.dev/packages/flutter_launcher_icons)
- [Android Adaptive Icons](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive)
- [iOS App Icon Guidelines](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [PWA Icon Guidelines](https://web.dev/add-manifest/)
