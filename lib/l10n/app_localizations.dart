import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('vi')];

  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    _AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _values = {
    'en': {
      'appTitle': 'Math War',
      'mathPlayground': 'Math Playground',
      'tagline': 'Learn math with Buddy Bear!',
      'unlockStars': 'Answer quickly to unlock star points!',
      'best': 'BEST',
      'total': 'TOTAL',
      'startGame': 'START GAME',
      'home': 'Home',
      'settings': 'Settings',
      'wrongTryAgain': 'Not quite right, try again!',
      'score': 'SCORE',
      'youCanDoIt': 'You can do it!',
      'falseLabel': 'FALSE',
      'trueLabel': 'TRUE',
      'results': 'Results',
      'outOfTurns': 'Round finished!',
      'newRecordMsg': 'Awesome! You just made a new record.',
      'retryMsg': 'No worries, play another round!',
      'playAgain': 'PLAY AGAIN',
      'points': 'Points',
      'highest': 'Highest',
      'status': 'Status',
      'newLabel': 'New',
      'okLabel': 'OK',
      'ready': 'READY',
      'start': 'START',
      'ui': 'Interface',
      'operations': 'Operations',
      'chooseOperation':
          'Select which operations appear in questions. Keep at least one enabled. Example: if only Add (+) is on, questions will be like 7 + 5.',
      'maxDifficulty': 'Max difficulty',
      'difficultyHint':
          'Controls how large numbers can get. Higher levels use bigger numbers and are harder. Example: Level 1 usually has 1-digit numbers, Level 5 can reach multi-digit numbers.',
      'level': 'Level {value}',
      'timeLimit': 'Time limit',
      'timeHint':
          'Time you have to answer each question. Shorter time is more challenging. Example: 3.0 sec is relaxed, 1.5 sec is fast-paced.',
      'seconds': '{value} sec',
      'saveSettings': 'SAVE SETTINGS',
      'system': 'System',
      'light': 'Light',
      'dark': 'Dark',
      'language': 'Language',
      'english': 'English',
      'vietnamese': 'Vietnamese',
      'close': 'Close',
      'opAdd': 'Add (+)',
      'opSub': 'Sub (-)',
      'opMul': 'Mul (×)',
      'opDiv': 'Div (÷)',
    },
    'vi': {
      'appTitle': 'Math War',
      'mathPlayground': 'Sân Chơi Toán Học',
      'tagline': 'Học toán cùng Gấu Buddy!',
      'unlockStars': 'Trả lời nhanh để mở khóa điểm sao!',
      'best': 'CAO NHẤT',
      'total': 'TỔNG',
      'startGame': 'BẮT ĐẦU CHƠI',
      'home': 'Trang chủ',
      'settings': 'Cài đặt',
      'wrongTryAgain': 'Ôi chưa đúng rồi, thử lại nhé!',
      'score': 'ĐIỂM',
      'youCanDoIt': 'Bạn làm được mà!',
      'falseLabel': 'SAI',
      'trueLabel': 'ĐÚNG',
      'results': 'Kết quả',
      'outOfTurns': 'Hết lượt rồi!',
      'newRecordMsg': 'Tuyệt vời! Bạn vừa lập kỷ lục mới.',
      'retryMsg': 'Không sao cả, làm lại thêm một ván nhé.',
      'playAgain': 'CHƠI LẠI',
      'points': 'Điểm',
      'highest': 'Cao nhất',
      'status': 'Trạng thái',
      'newLabel': 'Mới',
      'okLabel': 'Ổn',
      'ready': 'SẴN SÀNG',
      'start': 'BẮT ĐẦU',
      'ui': 'Giao diện',
      'operations': 'Phép tính',
      'chooseOperation':
          'Chọn phép tính sẽ xuất hiện trong câu hỏi. Cần bật ít nhất 1 phép. Ví dụ: chỉ bật Cộng (+) thì bài sẽ có dạng 7 + 5.',
      'maxDifficulty': 'Độ khó tối đa',
      'difficultyHint':
          'Điều chỉnh độ lớn của số trong phép tính. Cấp càng cao thì số càng lớn và khó hơn. Ví dụ: Cấp 1 thường là số 1 chữ số, Cấp 5 có thể lên nhiều chữ số.',
      'level': 'Cấp độ {value}',
      'timeLimit': 'Giới hạn thời gian',
      'timeHint':
          'Thời gian bạn có để trả lời mỗi câu. Thời gian càng ngắn thì càng thử thách. Ví dụ: 3.0 giây là dễ chịu, 1.5 giây là rất nhanh.',
      'seconds': '{value} giây',
      'saveSettings': 'LƯU CÀI ĐẶT',
      'system': 'Hệ thống',
      'light': 'Sáng',
      'dark': 'Tối',
      'language': 'Ngôn ngữ',
      'english': 'Tiếng Anh',
      'vietnamese': 'Tiếng Việt',
      'close': 'Đóng',
      'opAdd': 'Cộng (+)',
      'opSub': 'Trừ (-)',
      'opMul': 'Nhân (×)',
      'opDiv': 'Chia (÷)',
    },
  };

  String _t(String key) =>
      _values[locale.languageCode]?[key] ?? _values['en']![key] ?? key;

  String tr(String key, [Map<String, String> args = const {}]) {
    var value = _t(key);
    for (final entry in args.entries) {
      value = value.replaceAll('{${entry.key}}', entry.value);
    }
    return value;
  }

  String get appTitle => _t('appTitle');
  String get mathPlayground => _t('mathPlayground');
  String get tagline => _t('tagline');
  String get unlockStars => _t('unlockStars');
  String get best => _t('best');
  String get total => _t('total');
  String get startGame => _t('startGame');
  String get home => _t('home');
  String get settings => _t('settings');
  String get wrongTryAgain => _t('wrongTryAgain');
  String get score => _t('score');
  String get youCanDoIt => _t('youCanDoIt');
  String get falseLabel => _t('falseLabel');
  String get trueLabel => _t('trueLabel');
  String get results => _t('results');
  String get outOfTurns => _t('outOfTurns');
  String get newRecordMsg => _t('newRecordMsg');
  String get retryMsg => _t('retryMsg');
  String get playAgain => _t('playAgain');
  String get points => _t('points');
  String get highest => _t('highest');
  String get status => _t('status');
  String get newLabel => _t('newLabel');
  String get okLabel => _t('okLabel');
  String get ready => _t('ready');
  String get start => _t('start');
  String get ui => _t('ui');
  String get operations => _t('operations');
  String get chooseOperation => _t('chooseOperation');
  String get maxDifficulty => _t('maxDifficulty');
  String get difficultyHint => _t('difficultyHint');
  String level(int value) => tr('level', {'value': '$value'});
  String get timeLimit => _t('timeLimit');
  String get timeHint => _t('timeHint');
  String seconds(String value) => tr('seconds', {'value': value});
  String get saveSettings => _t('saveSettings');
  String get system => _t('system');
  String get light => _t('light');
  String get dark => _t('dark');
  String get language => _t('language');
  String get english => _t('english');
  String get vietnamese => _t('vietnamese');
  String get close => _t('close');
  String get opAdd => _t('opAdd');
  String get opSub => _t('opSub');
  String get opMul => _t('opMul');
  String get opDiv => _t('opDiv');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'vi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}

extension AppLocalizationX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
