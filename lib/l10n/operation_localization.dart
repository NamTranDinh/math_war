import 'package:flutter/widgets.dart';
import 'package:math_war/core/models/math_operation.dart';
import 'package:math_war/l10n/app_localizations.dart';

extension OperationTypeLocalization on OperationType {
  String localizedLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case OperationType.add:
        return l10n.opAdd;
      case OperationType.subtract:
        return l10n.opSub;
      case OperationType.multiply:
        return l10n.opMul;
      case OperationType.divide:
        return l10n.opDiv;
    }
  }
}
