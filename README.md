# 🧠⚔️ MATH WAR - TRUE OR FALSE MATH BATTLE

A fast-paced mobile math game built with Flutter where players must quickly determine if math equations are correct or incorrect. Features stunning **Liquid Glass UI** with modern, Apple-inspired design!

## 🎨 UI Design

**✨ NEW!** Math War now features a completely redesigned UI using **Liquid Glass Effects**:
- 🫧 **Frosted Glass Elements**: Beautiful glass-morphism design
- ✨ **Interactive Glow**: Touch-responsive glow effects
- 🤸 **Stretch Animations**: Organic squash and stretch on interaction
- 🎨 **Dynamic Gradients**: Color-changing backgrounds based on score
- 💎 **Premium Look**: Apple-inspired liquid glass aesthetics

📖 **[Read: LIQUID_GLASS_DESIGN.md](LIQUID_GLASS_DESIGN.md)** for full design documentation.

---

## 📱 Đổi App Icon

Muốn thay icon của app? Rất đơn giản!

```bash
# 1. Đặt icon vào assets/app_icon.png (PNG, 1024x1024 px)
# 2. Chạy script tự động:
./scripts/setup_icon.sh

# 3. Test:
flutter run
```

📖 Xem chi tiết: [HOW_TO_CHANGE_ICON.md](HOW_TO_CHANGE_ICON.md)

---

## 🎮 Game Features

### Core Gameplay
- **Quick Decision Making**: Choose TRUE or FALSE for randomly generated math equations
- **Time Pressure**: Default 2-second countdown (configurable 1-5 seconds)
- **Progressive Difficulty**: Equations become more complex as you progress
- **Score Based on Speed**: Faster answers earn more points (max 20 per question)
- **Game Over on Wrong Answer**: One mistake ends the game!

### Math Operations
- ✅ Addition (+)
- ✅ Subtraction (-)
- ✅ Multiplication (×)
- ✅ Division (÷) - Always exact division, no remainders

### Difficulty Scaling
The game intelligently increases difficulty based on your consecutive correct answers:
- **Levels 0-4**: 1-digit numbers
- **Levels 5-9**: 1-digit operations with increasing complexity
- **Levels 10+**: Progressively larger numbers (up to 5 digits configurable)

Difficulty scales across all four operations in sequence, then increases digit count.

### Dynamic UI
- **Color-Changing Background**: Changes from blue → green → yellow → orange → red → purple based on score
- **Smooth Animations**: 
  - Scale effects on buttons
  - Shake animation on wrong answers
  - Fade and scale transitions on game over
  - Progress bar countdown animation
- **Haptic Feedback**: Vibration on button press

## 🎨 Screens

### 1. Home Screen
- Displays best score and total score
- "START BATTLE" button to begin
- Settings icon for configuration

### 2. War Room (Settings)
Configure your battle preferences:
- **Operations**: Toggle which math operations to include
- **Max Difficulty**: Slider from Level 1-5 (controls max digit count)
- **Time Limit**: Slider from 1.0s to 5.0s

### 3. Game Screen
- Live math equation display
- Animated countdown timer
- FALSE and TRUE buttons
- Real-time score updates
- Dynamic background based on performance

### 4. Game Over Screen
- Final score display
- "NEW RECORD" badge if best score achieved
- "RE-ENGAGE" button to play again

## 🏗️ Architecture

The project follows **Clean Architecture** principles:

```
lib/
├── core/
│   ├── models/              # Data models
│   │   ├── game_config.dart
│   │   ├── game_state.dart
│   │   └── math_operation.dart
│   ├── services/            # Business logic
│   │   ├── difficulty_manager.dart
│   │   ├── math_generator.dart
│   │   ├── score_calculator.dart
│   │   └── storage_service.dart
│   └── cubit/               # State management
│       └── game_cubit.dart
├── screens/                 # UI screens
│   ├── home_screen.dart
│   ├── settings_screen.dart
│   ├── game_screen.dart
│   └── game_over_screen.dart
└── main.dart
```

### Key Components

#### Models
- **MathEquation**: Represents a single math problem with operands, operation, and results
- **GameConfig**: Stores user preferences (operations, difficulty, time)
- **GameState**: Current game state including score, status, and equation

#### Services
- **MathGenerator**: Creates random math equations with configurable difficulty
- **DifficultyManager**: Calculates appropriate difficulty based on progress
- **ScoreCalculator**: Determines points based on reaction time
- **StorageService**: Persists best score, total score, and settings

#### State Management
- **GameCubit**: Manages game flow using the BLoC/Cubit pattern
  - Handles timer countdown
  - Processes answers
  - Updates scores
  - Manages game state transitions

## 🔧 Technology Stack

- **Flutter**: 3.x+
- **Dart**: Null Safety enabled
- **State Management**: flutter_bloc (Cubit)
- **Local Storage**: shared_preferences
- **Haptic Feedback**: vibration
- **Architecture**: Clean Architecture with separated layers

## 📊 Scoring System

Points are calculated based on reaction time:

```dart
score = maxScore * (remainingTime / totalTime)
```

- **Max Score**: 20 points per question
- **Fast Answer (>90% time remaining)**: ~18-20 points
- **Quick Answer (70-90%)**: ~14-18 points
- **Good Answer (50-70%)**: ~10-14 points
- **Slow Answer (<50%)**: ~1-10 points

## 🎯 Game Logic Highlights

### Math Generation
- Numbers are generated with specified digit counts
- Division ensures exact results (no remainders)
- 50% chance of displaying correct vs incorrect answers
- Incorrect answers are within a reasonable error range (not obviously wrong)

### Difficulty Progression
- Every 5 correct answers increases complexity
- First 20 questions cycle through operations: + → - → × → ÷
- Then digit count increases progressively
- User can cap max difficulty in settings

### Timer System
- 50ms tick rate for smooth progress bar animation
- Timeout treated as wrong answer
- Configurable from 1-5 seconds

## 🚀 Running the Project

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run on Device/Emulator**
   ```bash
   flutter run
   ```

3. **Build for Release**
   ```bash
   # Android
   flutter build apk --release
   
   # iOS
   flutter build ios --release
   ```

## 📱 Supported Platforms

- ✅ Android
- ✅ iOS
- Portrait orientation only

## 🎨 Color Scheme

- **Primary**: #5B52E8 (Purple Blue)
- **Secondary**: #4A3FD8 (Deep Blue)
- **Dynamic Backgrounds**: Progressive color transitions based on score

## 💾 Data Persistence

The game automatically saves:
- 🏆 Best Score (highest score in a single game)
- 📊 Total Score (cumulative score across all games)
- ⚙️ User Settings (operations, difficulty, time limit)

All data persists between app launches using SharedPreferences.

## 🎮 Gameplay Tips

1. **Focus on Speed**: The faster you answer, the more points you earn
2. **Learn Patterns**: Common operations become easier to recognize quickly
3. **Use Settings Wisely**: Start with lower difficulty and shorter time to build confidence
4. **Stay Calm**: One wrong answer ends the game - accuracy is essential!

## 📝 Code Quality

- ✅ Null Safety enabled
- ✅ Clean Architecture
- ✅ Commented code explaining key logic
- ✅ Proper state management
- ✅ 60fps stable animations
- ✅ Responsive design
- ✅ No hardcoded values for scaling logic

## 🤝 Contributing

This is a complete, production-ready game. Feel free to:
- Add new operation types
- Implement sound effects
- Add dark mode
- Create leaderboards
- Add achievements

## 📄 License

This project is created for educational and entertainment purposes.

---

**Built with ❤️ using Flutter**


- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
