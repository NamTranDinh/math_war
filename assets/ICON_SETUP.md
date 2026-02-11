# 🎨 Hướng Dẫn Đổi App Icon

## Bước 1: Chuẩn bị hình ảnh

1. Lưu hình icon của bạn vào thư mục `assets/` với tên `app_icon.png`
2. Yêu cầu:
   - **Kích thước:** Tối thiểu 1024x1024 px (khuyến nghị 2048x2048 px)
   - **Format:** PNG với nền trong suốt hoặc nền màu
   - **Chất lượng:** Cao, không bị mờ

## Bước 2: Cài đặt flutter_launcher_icons

Package này sẽ tự động generate icon cho tất cả platforms.

```bash
flutter pub add dev:flutter_launcher_icons
```

## Bước 3: Generate Icons

Chạy script tự động:

```bash
./scripts/setup_icon.sh
```

Hoặc manual:

```bash
dart run flutter_launcher_icons
```

## Bước 4: Rebuild App

```bash
# Android
flutter clean
flutter run

# iOS (cần clean build folder)
cd ios
rm -rf Pods Podfile.lock
cd ..
flutter clean
flutter run
```

## 📝 Cấu Hình Trong pubspec.yaml

Package đã được cấu hình để:
- ✅ Android: Tạo adaptive icon với background và foreground
- ✅ iOS: Tạo tất cả kích thước icon cần thiết
- ✅ Web: Tạo favicon và PWA icons

## 🎯 Kết Quả

Sau khi chạy `dart run flutter_launcher_icons`, các file sau sẽ được tạo:

### Android
- `android/app/src/main/res/mipmap-*/ic_launcher.png` (tất cả densities)
- `android/app/src/main/res/mipmap-*/ic_launcher_foreground.png`
- `android/app/src/main/res/mipmap-*/ic_launcher_background.png`

### iOS
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/*.png` (tất cả sizes)

### Web
- `web/icons/Icon-192.png`
- `web/icons/Icon-512.png`
- `web/icons/Icon-maskable-*.png`
- `web/favicon.png`

## 🔥 Tips

1. **Icon đẹp nhất:** Sử dụng hình vuông 1024x1024px, design đơn giản, rõ ràng
2. **Adaptive Icon (Android):** Nếu muốn custom riêng foreground/background, tạo 2 file:
   - `assets/app_icon_foreground.png` (phần chính)
   - `assets/app_icon_background.png` (background)
3. **Test trước:** Xem preview icon trên nhiều kích thước khác nhau

## 🚀 Quick Start

```bash
# 1. Đặt icon vào assets/app_icon.png
# 2. Chạy:
./scripts/setup_icon.sh

# Hoặc manual:
flutter pub get
dart run flutter_launcher_icons

# 3. Test:
flutter clean && flutter run
```
