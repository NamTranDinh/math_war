# 🎨 ĐỔI APP ICON CHO MATH WAR

## ⚡ CÁCH NHANH NHẤT (3 bước)

### 1️⃣ Lưu Icon
Lưu file icon của bạn (hình đính kèm) vào:
```
assets/app_icon.png
```

**⚠️ Lưu ý:**
- Tên file phải là: `app_icon.png` (chính xác!)
- Kích thước tối thiểu: **1024x1024 px**
- Format: PNG

### 2️⃣ Chạy Script
```bash
./scripts/setup_icon.sh
```

Script sẽ tự động:
- Install dependencies
- Generate icons cho Android, iOS, Web
- Clean build cache

### 3️⃣ Test
```bash
flutter run
```

---

## 📋 Scripts Có Sẵn

### `./scripts/setup_icon.sh`
Tự động generate icons cho tất cả platforms

### `./scripts/check_icons.sh`
Kiểm tra status của icons

---

## 🔧 Cách Manual

Nếu không muốn dùng script:

```bash
# 1. Đặt icon vào assets/app_icon.png

# 2. Generate icons
flutter pub get
dart run flutter_launcher_icons

# 3. Clean & run
flutter clean
flutter run
```

---

## 📂 Cấu Trúc File

```
math_war/
├── assets/
│   ├── app_icon.png          ← Đặt icon của bạn vào đây!
│   ├── README.md             ← Hướng dẫn chi tiết
│   └── ICON_SETUP.md         ← Setup guide
│
├── scripts/                  ← Các script tiện ích
│   ├── setup_icon.sh         ← Script tự động
│   ├── check_icons.sh        ← Check status
│   └── preview_icon_structure.sh
│
├── ICON_GUIDE.md             ← Tài liệu đầy đủ
│
├── android/
│   └── app/src/main/res/
│       ├── mipmap-hdpi/
│       ├── mipmap-mdpi/
│       ├── mipmap-xhdpi/
│       ├── mipmap-xxhdpi/
│       └── mipmap-xxxhdpi/
│
├── ios/
│   └── Runner/Assets.xcassets/
│       └── AppIcon.appiconset/
│
└── web/
    ├── icons/
    └── favicon.png
```

---

## 🎯 Icon Được Generate Cho

### ✅ Android
- All densities (hdpi, mdpi, xhdpi, xxhdpi, xxxhdpi)
- Adaptive icons (Android 8.0+)
- Launcher icons

### ✅ iOS
- All sizes (20x20 → 1024x1024)
- All scales (@1x, @2x, @3x)
- iPhone & iPad

### ✅ Web
- PWA icons (192px, 512px)
- Maskable icons
- Favicon

---

## 🐛 Troubleshooting

### Icon không thay đổi?

**Android:**
```bash
# Uninstall app cũ
adb uninstall com.example.math_war
# Hoặc xóa thủ công trên device
flutter run
```

**iOS:**
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter clean
flutter run
```

**Web:**
- Clear browser cache (Ctrl+Shift+Del)
- Hard reload (Ctrl+Shift+R)

### Icon bị mờ?
- Đảm bảo icon gốc ≥ 1024x1024 px
- Sử dụng PNG chất lượng cao
- Không scale từ ảnh nhỏ

---

## 📚 Tài Liệu

Xem thêm: [ICON_GUIDE.md](ICON_GUIDE.md)

---

## ✅ Checklist

- [ ] Đã lưu icon vào `assets/app_icon.png`
- [ ] Icon có kích thước ≥ 1024x1024 px
- [ ] Đã chạy `./setup_icon.sh`
- [ ] Đã test `flutter run`
- [ ] Icon hiển thị đúng trên device

---

**💡 Tip:** Icon trong tin nhắn của bạn rất đẹp! Hãy save nó với tên `app_icon.png` vào folder `assets/` rồi chạy `./setup_icon.sh`
