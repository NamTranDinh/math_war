# 📜 Scripts Tiện Ích

Folder này chứa các script tự động hóa cho Math War project.

## 🎨 Icon Management

### `setup_icon.sh`
**Script chính** để generate app icons cho tất cả platforms.

**Sử dụng:**
```bash
./scripts/setup_icon.sh
```

**Chức năng:**
- Kiểm tra file `assets/app_icon.png` có tồn tại
- Install dependencies (flutter_launcher_icons)
- Generate icons cho Android, iOS, Web
- Clean build cache
- Hiển thị kết quả

**Yêu cầu:**
- File `assets/app_icon.png` phải tồn tại (≥1024x1024 px)

---

### `check_icons.sh`
Kiểm tra status của icons đã được generate.

**Sử dụng:**
```bash
./scripts/check_icons.sh
```

**Hiển thị:**
- ✅ Source icon có tồn tại không
- ✅ Android icons status
- ✅ iOS icons status  
- ✅ Web icons status
- 📊 Số lượng files đã được tạo

---

### `preview_icon_structure.sh`
Xem cấu trúc và thông tin về icons sẽ được generate.

**Sử dụng:**
```bash
./scripts/preview_icon_structure.sh
```

**Hiển thị:**
- 📱 Danh sách icon files cho Android (tất cả densities)
- 🍎 Danh sách icon files cho iOS (tất cả sizes)
- 🌐 Danh sách icon files cho Web (PWA + favicon)
- 📊 Tổng số files sẽ được tạo (~35 files)

---

## 🚀 Quy Trình Sử Dụng

```bash
# 1. Đặt icon vào assets/app_icon.png

# 2. Check hiện trạng
./scripts/check_icons.sh

# 3. Preview cấu trúc (optional)
./scripts/preview_icon_structure.sh

# 4. Generate icons
./scripts/setup_icon.sh

# 5. Check lại
./scripts/check_icons.sh

# 6. Test app
flutter run
```

---

## 📝 Notes

- Tất cả scripts cần được chạy từ **thư mục gốc** của project (math_war/)
- Scripts yêu cầu Flutter SDK đã được cài đặt
- Đảm bảo file `assets/app_icon.png` có kích thước phù hợp (≥1024x1024 px)

---

## 🔧 Thêm Scripts Mới

Khi thêm script mới vào folder này:

1. Đặt tên rõ ràng, mô tả chức năng
2. Thêm executable permission: `chmod +x scripts/ten_script.sh`
3. Update README này với mô tả script mới
4. Thêm comments trong script giải thích logic
