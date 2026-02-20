# Math War

Math War là ứng dụng Flutter luyện toán nhanh cho trẻ em theo dạng câu hỏi **Đúng/Sai** với nhịp chơi ngắn, phản xạ nhanh và giao diện vui nhộn.

## 1. Mục tiêu dự án

- Tạo trải nghiệm học toán thân thiện cho trẻ nhỏ.
- Kết hợp học và chơi: trả lời nhanh, ghi điểm, phá kỷ lục.
- Giao diện trực quan, nút lớn, màu pastel, dễ thao tác trên điện thoại.
- Hỗ trợ cả Light Mode và Dark Mode để dùng ban ngày/ban đêm.

## 2. Tính năng chính

- Trò chơi toán học dạng **True/False**.
- Các phép tính hỗ trợ:
  - Cộng
  - Trừ
  - Nhân
  - Chia
- Độ khó tăng theo điểm hiện tại.
- Giới hạn thời gian cho mỗi câu hỏi.
- Chấm điểm theo tốc độ phản hồi.
- Lưu dữ liệu cục bộ:
  - Best Score
  - Total Score
  - Cấu hình game
  - Tùy chọn theme (system/light/dark)

## 3. Thiết kế giao diện

Dự án hiện dùng phong cách UI vui nhộn cho trẻ em:

- Màu pastel tươi sáng, bo góc lớn.
- Icon minh họa và mascot xuyên suốt.
- Nút bấm to, dễ nhìn, dễ chạm.
- Hiệu ứng tương tác:
  - Nhấn nút có scale animation
  - Trả lời đúng có hiệu ứng ăn mừng
  - Trả lời sai có rung nhẹ và nhắc nhở thân thiện
  - Chuyển màn hình mượt bằng custom route transition

## 4. Hỗ trợ Theme

- `ThemeMode.system`
- `ThemeMode.light`
- `ThemeMode.dark`

Theme được quản lý bằng `ThemeCubit` và lưu vào `SharedPreferences`.

## 5. Kiến trúc dự án

### 5.1 State management

- `flutter_bloc`
  - `GameCubit`: điều phối logic game và score
  - `ThemeCubit`: quản lý chế độ sáng/tối

### 5.2 Data persistence

- `StorageService` dùng `SharedPreferences` để lưu trạng thái game.

### 5.3 Core domain

- `GameConfig`: cấu hình game.
- `MathEquation`/`OperationType`: mô hình phép toán.
- `MathGenerator`: sinh câu hỏi theo độ khó.
- `ScoreCalculator`: tính điểm.

### 5.4 UI layer

- `lib/screens/`
  - `home_screen.dart`
  - `game_screen.dart`
  - `countdown_overlay.dart`
  - `game_over_screen.dart`
  - `settings_screen.dart`
- `lib/widgets/`
  - `neumorphic/neumorphic_widgets.dart`
  - `celebration_overlay.dart`
- `lib/theme/`
  - `app_theme.dart`
  - `app_text_styles.dart`
  - `neumorphic_theme_extension.dart`

## 6. Cấu trúc thư mục tiêu biểu

```text
lib/
  common/
  core/
    cubit/
    models/
    services/
  screens/
  theme/
  widgets/
assets/
  icons/
  images/
  illustrations/
```

## 7. Công nghệ sử dụng

- Flutter / Dart
- flutter_bloc
- shared_preferences
- flutter_svg
- google_fonts
- vibration

## 8. Cách chạy dự án

### Yêu cầu

- Flutter SDK phù hợp với `pubspec.yaml`
- Android Studio hoặc VS Code + Flutter extension

### Cài đặt và chạy

```bash
flutter pub get
flutter run
```

### Kiểm tra mã nguồn

```bash
flutter analyze
```

## 9. Dòng chảy gameplay

1. Người chơi bấm bắt đầu.
2. Hiện countdown trước khi vào game.
3. Câu toán xuất hiện cùng đáp án hiển thị.
4. Người chơi chọn **ĐÚNG** hoặc **SAI** trước khi hết giờ.
5. Trả lời đúng: cộng điểm, sang câu mới.
6. Trả lời sai hoặc hết giờ: kết thúc ván, hiển thị Game Over.

## 10. Tùy chỉnh nhanh

- Đổi màu/chủ đề: chỉnh trong `lib/theme/`.
- Đổi style button/card: chỉnh trong `lib/widgets/neumorphic/neumorphic_widgets.dart`.
- Đổi luật tính điểm: chỉnh `lib/core/services/score_calculator.dart`.
- Đổi thuật toán sinh đề: chỉnh `lib/core/services/math_generator.dart`.

## 11. Ghi chú

- Dự án ưu tiên trải nghiệm trên thiết bị dọc (portrait).
- Có thể mở rộng thêm:
  - Reward/sticker theo mốc điểm
  - Bảng xếp hạng
  - Nhiều mascot và chủ đề theo độ tuổi
