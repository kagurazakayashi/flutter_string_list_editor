import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_string_list_editor/flutter_string_list_editor.dart';

void main() {
  group('splitList / joinList', () {
    test('逗號：去空白並過濾空項目', () {
      expect(splitList('a, b, , c ', Delimiter.comma), ['a', 'b', 'c']);
    });

    test('分號', () {
      expect(splitList('x; y;z', Delimiter.semicolon), ['x', 'y', 'z']);
    });

    test('換行（含 \r\n）', () {
      expect(splitList('a\r\nb\n\nc', Delimiter.newline), ['a', 'b', 'c']);
    });

    test('自訂分隔符', () {
      expect(splitList('a||b||c', const Delimiter('||')), ['a', 'b', 'c']);
    });

    test('合併', () {
      expect(joinList(['a', 'b', 'c'], Delimiter.comma), 'a,b,c');
      expect(joinList(['a', 'b'], Delimiter.semicolon), 'a;b');
      expect(joinList(['a', 'b'], const Delimiter('||')), 'a||b');
    });
  });

  group('Delimiter', () {
    test('內建常數值', () {
      expect(Delimiter.comma.value, ',');
      expect(Delimiter.semicolon.value, ';');
      expect(Delimiter.newline.value, '\n');
      expect(Delimiter.pipe.value, '|');
      expect(Delimiter.tab.value, '\t');
      expect(Delimiter.space.value, ' ');
    });
  });

  group('StringListEditorLocalizations.fromLocale', () {
    test('zh 依地區 / 文字腳本解析繁簡', () {
      expect(
        StringListEditorLocalizations.fromLocale(const Locale('zh', 'TW')).languageCode,
        'zh_TW',
      );
      expect(
        StringListEditorLocalizations.fromLocale(const Locale('zh', 'CN')).languageCode,
        'zh_CN',
      );
      expect(
        StringListEditorLocalizations.fromLocale(
          Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        ).languageCode,
        'zh_TW',
      );
    });

    test('其他語言回退英文', () {
      expect(
        StringListEditorLocalizations.fromLocale(const Locale('en')).languageCode,
        'en',
      );
      expect(
        StringListEditorLocalizations.fromLocale(const Locale('ja')).languageCode,
        'en',
      );
      expect(StringListEditorLocalizations.fromLocale(null).languageCode, 'en');
    });
  });

  group('內建本地化字串', () {
    test('簡中', () {
      const l10n = StringListEditorLocalizationsZhCn();
      expect(l10n.add, '新增');
      expect(l10n.delete, '删除');
      expect(l10n.drag, '拖动排序');
      expect(l10n.defaultTitle, '编辑列表');
    });

    test('繁中', () {
      const l10n = StringListEditorLocalizationsZhTw();
      expect(l10n.add, '新增');
      expect(l10n.delete, '刪除');
      expect(l10n.drag, '拖曳排序');
      expect(l10n.confirm, '確定');
    });

    test('英文', () {
      const l10n = StringListEditorLocalizationsEn();
      expect(l10n.add, 'Add');
      expect(l10n.drag, 'Drag to reorder');
      expect(l10n.empty, 'No items');
      expect(l10n.cancel, 'Cancel');
    });
  });
}
