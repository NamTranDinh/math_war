# 🎯 CẬP NHẬT LOGIC TĂNG ĐỘ KHÓ - MATH WAR

## 📋 Tóm Tắt Thay Đổi

Logic tăng độ khó đã được **viết lại hoàn toàn** theo pattern mới:

### ❌ Logic Cũ (Deprecated)
- Tăng độ khó dựa trên số câu đúng liên tiếp
- Mỗi 5 câu đúng tăng complexity
- Pattern cố định: 1+1 → 1-1 → 1×1 → 1÷1 → 2+1 → 2+2...

### ✅ Logic Mới (Hiện Tại)
- Tăng độ khó dựa trên **điểm số** (score)
- **Mỗi 100 điểm** = 1 stage mới
- Pattern động theo công thức: **j số với i số**
- Không hardcode, tự sinh stages theo config

---

## 🧮 Công Thức Tăng Độ Khó

### Pattern Generation

```
For i from 1 to maxDifficultyLevel:
  For j from 1 to i:
    For each enabled operation (+, -, ×, ÷):
      Create stage: j-digit operand1, i-digit operand2
```

### Thứ Tự Phép Toán
1. Cộng (+)
2. Trừ (-)
3. Nhân (×)
4. Chia (÷)

---

## 📊 Ví Dụ Cụ Thể

### Ví Dụ 1: maxDifficulty = 2, Tất Cả Phép Toán

**Cấu hình:**
- Phép toán: +, -, ×, ÷
- Max Difficulty: 2

**Stages được sinh ra:**

```
i=1, j=1: 1 số với 1 số
  Stage 1  (0-99 điểm):    1 + 1
  Stage 2  (100-199):      1 - 1
  Stage 3  (200-299):      1 × 1
  Stage 4  (300-399):      1 ÷ 1

i=2, j=1: 1 số với 2 số
  Stage 5  (400-499):      1 + 2
  Stage 6  (500-599):      1 - 2
  Stage 7  (600-699):      1 × 2
  Stage 8  (700-799):      1 ÷ 2

i=2, j=2: 2 số với 2 số
  Stage 9  (800-899):      2 + 2
  Stage 10 (900-999):      2 - 2
  Stage 11 (1000-1099):    2 × 2
  Stage 12 (1100-1199):    2 ÷ 2

TỔNG: 12 stages
```

**Sau stage 12 (score ≥ 1200):** Không tăng nữa, giữ stage cuối

---

### Ví Dụ 2: maxDifficulty = 3, Tất Cả Phép Toán

**Cấu hình:**
- Phép toán: +, -, ×, ÷  
- Max Difficulty: 3

**Stages được sinh ra:**

```
i=1: (4 stages)
  1+1, 1-1, 1×1, 1÷1

i=2: (8 stages)
  1+2, 1-2, 1×2, 1÷2
  2+2, 2-2, 2×2, 2÷2

i=3: (12 stages)
  1+3, 1-3, 1×3, 1÷3
  2+3, 2-3, 2×3, 2÷3
  3+3, 3-3, 3×3, 3÷3

TỔNG: 24 stages (2400 điểm để hoàn thành)
```

---

### Ví Dụ 3: maxDifficulty = 2, Chỉ + và ×

**Cấu hình:**
- Phép toán: + và × (user tắt - và ÷)
- Max Difficulty: 2

**Stages được sinh ra:**

```
Stage 1  (0-99):     1 + 1
Stage 2  (100-199):  1 × 1
Stage 3  (200-299):  1 + 2
Stage 4  (300-399):  1 × 2
Stage 5  (400-499):  2 + 2
Stage 6  (500-599):  2 × 2

TỔNG: 6 stages
```

---

## 🎮 Cách Tính Stage Từ Score

### Công Thức
```dart
stageIndex = score ~/ 100
stageNumber = stageIndex + 1
```

### Ví Dụ
- Score 0-99: Stage 1
- Score 100-199: Stage 2  
- Score 200-299: Stage 3
- Score 1000-1099: Stage 11
- Score 2500+: Stage 26 (nếu có đủ stages)

---

## 💻 Code Implementation

### DifficultyManager Class

**Các Method Chính:**

1. **`generateStages(GameConfig)`**
   - Input: Game configuration
   - Output: List of DifficultyStage objects
   - Tự động sinh tất cả stages theo pattern

2. **`getCurrentStage(int score, GameConfig)`**
   - Input: Điểm hiện tại, config
   - Output: Stage hiện tại player đang ở
   - Tính stage dựa trên score / 100

3. **`getStageNumber(int score, GameConfig)`**
   - Trả về số thứ tự stage (1-based)

4. **`getTotalStages(GameConfig)`**
   - Trả về tổng số stages

5. **`hasCompletedAllStages(int score, GameConfig)`**
   - Check xem đã hoàn thành hết chưa

### DifficultyStage Class

```dart
class DifficultyStage {
  final int operand1Digits;  // Số chữ số của operand1
  final int operand2Digits;  // Số chữ số của operand2
  final OperationType operation;  // Phép toán
  
  const DifficultyStage({...});
}
```

---

## 🔄 Thay Đổi Trong MathGenerator

### Trước (Old)
```dart
generateEquation({
  required GameConfig config,
  required int consecutiveCorrect,  // ❌
})
```

### Sau (New)
```dart
generateEquation({
  required GameConfig config,
  required int currentScore,  // ✅
})
```

**Logic:**
1. Lấy current stage từ score
2. Dùng stage.operand1Digits và stage.operand2Digits
3. Dùng stage.operation (không random nữa)

---

## 🎯 Ưu Điểm Logic Mới

### 1. Dynamic & Scalable
- Không hardcode stages
- Tự động scale với bất kỳ maxDifficulty nào
- User config phép toán → stages tự thay đổi

### 2. Predictable
- Pattern rõ ràng, dễ hiểu
- User biết được sẽ phải trải qua bao nhiêu stages

### 3. Score-Based Progression
- Fairness: điểm cao = khó hơn
- Mỗi 100 điểm = 1 milestone
- Trả lời nhanh = lên stage nhanh hơn

### 4. Flexible
- Dễ config: user chọn phép toán, max difficulty
- Stages sinh ra hoàn toàn phù hợp với config

---

## 📈 Testing

### Test File: `test_difficulty.dart`

Chạy test để xem stages generated:

```dart
import 'core/services/test_difficulty.dart';

void main() {
  testDifficultyProgression();
}
```

**Output sẽ hiển thị:**
- Tất cả stages được generate
- Stage nào ở điểm nào
- Pattern theo từng i, j

---

## 🔧 Chia Luôn Không Dư

### Vấn Đề
Với pattern mới, cần đảm bảo phép chia luôn chính xác.

### Giải Pháp
Method `_adjustForDivision` trong MathGenerator:

1. Tìm tất cả ước của operand1
2. Filter ước có đúng số chữ số target
3. Random chọn 1 ước phù hợp
4. Nếu không có ước đúng digits → chọn ước gần nhất

**Ví Dụ:**
- Target: 1 ÷ 2 (1 digit ÷ 2 digits)
- operand1 = 144 (3 digits - sẽ re-generate)
- operand1 = 24 (2 digits - OK)
- Ước của 24 có 2 digits: 12, 24
- Random chọn: operand2 = 12
- Kết quả: 24 ÷ 12 = 2 ✓

---

## ✅ Checklist Hoàn Thành

- ✅ Viết lại DifficultyManager với pattern mới
- ✅ Cập nhật MathGenerator dùng currentScore
- ✅ Cập nhật GameCubit truyền score thay vì consecutiveCorrect
- ✅ Thêm methods helper: getStageNumber, getTotalStages, hasCompletedAllStages
- ✅ Chia luôn không dư với target digit count
- ✅ Code tuân theo conventions trong analysis_options.yaml
- ✅ Tạo test file để minh họa
- ✅ Viết documentation chi tiết

---

## 🎊 Kết Luận

Logic tăng độ khó mới:
- **Dynamic**: Tự sinh stages theo config
- **Fair**: Dựa trên score thực tế
- **Flexible**: User control được progression
- **Clean**: Không hardcode, dễ maintain
- **Fun**: Pattern rõ ràng, predictable

**Game giờ đã sẵn sàng với logic tăng độ khó thông minh!** 🚀🎮
