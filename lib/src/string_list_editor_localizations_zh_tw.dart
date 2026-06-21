import 'string_list_editor_localizations.dart';

/// 繁體中文（zh_TW）本地化實作。
class StringListEditorLocalizationsZhTw extends StringListEditorLocalizations {
  const StringListEditorLocalizationsZhTw();

  @override
  String get languageCode => 'zh_TW';

  @override
  String get add => '新增';

  @override
  String get delete => '刪除';

  @override
  String get moveUp => '上移';

  @override
  String get moveDown => '下移';

  @override
  String get moveToStart => '移到開頭';

  @override
  String get moveToEnd => '移到結尾';

  @override
  String get empty => '暫無條目';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確定';

  @override
  String get defaultTitle => '編輯列表';
}
