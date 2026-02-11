# 📍 Đặt Icon Của Bạn Vào Đây

## Hướng dẫn:

1. **Lưu file icon** với tên: `app_icon.png` (chính xác tên này)
2. **Đặt trong thư mục này** (assets/)
3. **Chạy lệnh:** `./setup_icon.sh` từ thư mục gốc project

## Yêu cầu file icon:

- ✅ Tên file: `app_icon.png`
- ✅ Format: PNG
- ✅ Kích thước: Tối thiểu 1024x1024 px (khuyến nghị 2048x2048 px)
- ✅ Nền: Trong suốt HOẶC màu solid
- ✅ Chất lượng: Cao, không bị mờ

## File cần có:

```
math_war/
  assets/
    app_icon.png  ← Đặt icon của bạn vào đây!
```

## Sau khi đã có icon:

```bash
# Chạy từ thư mục gốc (math_war/)
./scripts/setup_icon.sh

# Hoặc manual:
flutter pub get
dart run flutter_launcher_icons
flutter clean
flutter run
```

---

💡 **Tip:** Icon đính kèm trong tin nhắn của bạn có vẻ rất đẹp! 
Hãy lưu nó với tên `app_icon.png` vào thư mục này.
