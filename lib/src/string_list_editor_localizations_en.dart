import 'string_list_editor_localizations.dart';

/// 英文（en_US）本地化實作。
class StringListEditorLocalizationsEn extends StringListEditorLocalizations {
  const StringListEditorLocalizationsEn();

  @override
  String get languageCode => 'en';

  @override
  String get add => 'Add';

  @override
  String get delete => 'Delete';

  @override
  String get moveUp => 'Move up';

  @override
  String get moveDown => 'Move down';

  @override
  String get moveToStart => 'Move to start';

  @override
  String get moveToEnd => 'Move to end';

  @override
  String get empty => 'No items';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'OK';

  @override
  String get defaultTitle => 'Edit list';
}
