import 'package:flutter/widgets.dart';

import 'string_list_editor_localizations_en.dart';
import 'string_list_editor_localizations_zh_cn.dart';
import 'string_list_editor_localizations_zh_tw.dart';

/// 字串列表編輯器的本地化字串介面。
///
/// 預設內建英文、簡體中文、繁體中文三套實作；宿主應用可直接透過
/// [StringListEditorLocalizations.of] 依環境語系自動選取，或把自訂實作傳入
/// 對話框函式的 [localizations] 參數覆寫。
abstract class StringListEditorLocalizations {
  const StringListEditorLocalizations();

  /// 語言代碼（例如 'en'、'zh_CN'、'zh_TW'）。
  String get languageCode;

  // ---- 工具提示 ----
  String get add;
  String get delete;
  String get moveUp;
  String get moveDown;
  String get moveToStart;
  String get moveToEnd;

  // ---- 空態提示 ----
  String get empty;

  // ---- 對話框 ----
  String get cancel;
  String get confirm;
  String get defaultTitle;

  /// 依最近的 [Localizations] 環境語系解析本地化；無環境語系時回退英文。
  static StringListEditorLocalizations of(BuildContext context) {
    return fromLocale(Localizations.maybeLocaleOf(context));
  }

  /// 依 [Locale] 解析本地化：`zh` 依地區／文字腳本回傳繁/簡，其餘回傳英文。
  static StringListEditorLocalizations fromLocale(Locale? locale) {
    final lang = locale?.languageCode;
    if (lang == 'zh') {
      final country = locale?.countryCode ?? '';
      final script = locale?.scriptCode ?? '';
      final isTraditional = country == 'TW' ||
          country == 'HK' ||
          country == 'MO' ||
          script == 'Hant';
      return isTraditional
          ? const StringListEditorLocalizationsZhTw()
          : const StringListEditorLocalizationsZhCn();
    }
    return const StringListEditorLocalizationsEn();
  }
}
