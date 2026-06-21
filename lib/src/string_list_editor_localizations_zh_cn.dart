import 'string_list_editor_localizations.dart';

/// 簡體中文（zh_CN）本地化實作。
class StringListEditorLocalizationsZhCn extends StringListEditorLocalizations {
  const StringListEditorLocalizationsZhCn();

  @override
  String get languageCode => 'zh_CN';

  @override
  String get add => '新增';

  @override
  String get delete => '删除';

  @override
  String get moveUp => '上移';

  @override
  String get moveDown => '下移';

  @override
  String get moveToStart => '移到开头';

  @override
  String get moveToEnd => '移到结尾';

  @override
  String get empty => '暂无条目';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确定';

  @override
  String get defaultTitle => '编辑列表';
}
