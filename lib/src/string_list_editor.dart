import 'package:flutter/material.dart';

import 'string_list_editor_localizations.dart';

/// 分隔符：內建常用常數，亦可使用任意自訂字串。
class Delimiter {
  const Delimiter(this.value);

  /// 分隔符字串（不可為空字串）。
  final String value;

  static const Delimiter comma = Delimiter(',');
  static const Delimiter semicolon = Delimiter(';');
  static const Delimiter newline = Delimiter('\n');
  static const Delimiter pipe = Delimiter('|');
  static const Delimiter tab = Delimiter('\t');
  static const Delimiter space = Delimiter(' ');
}

/// 依 [delimiter] 拆分字串為列表（去除每項前後空白、過濾空項目）。
List<String> splitList(String text, Delimiter delimiter) {
  return text
      .split(delimiter.value)
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();
}

/// 以 [delimiter] 合併列表為字串。
String joinList(List<String> items, Delimiter delimiter) {
  return items.join(delimiter.value);
}

/// 字串列表編輯器：以列表呈現，每項皆可輸入編輯；支援新增、刪除與拖放排序。
///
/// 按住每列右側的拖放手把即可拖曳調整順序；任何變更（含逐字輸入）皆透過
/// [onChanged] 回報完整的新列表。
class StringListEditor extends StatefulWidget {
  const StringListEditor({
    super.key,
    required this.items,
    required this.onChanged,
    this.addLabel,
    this.localizations,
  });

  /// 初始列表（僅首次建構時使用）。
  final List<String> items;

  /// 列表變更回調（回報完整新列表）。
  final ValueChanged<List<String>> onChanged;

  /// 新增輸入框的標籤（可選）。
  final String? addLabel;

  /// 可選的本地化覆寫；null 時依環境語系自動選取。
  final StringListEditorLocalizations? localizations;

  @override
  State<StringListEditor> createState() => _StringListEditorState();
}

class _StringListEditorState extends State<StringListEditor> {
  final TextEditingController _addCtrl = TextEditingController();
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = [
      for (final t in widget.items) TextEditingController(text: t),
    ];
  }

  @override
  void dispose() {
    _addCtrl.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  List<String> _current() =>
      _controllers.map((c) => c.text.trim()).toList();

  void _add() {
    final value = _addCtrl.text.trim();
    if (value.isEmpty) return;
    _addCtrl.clear();
    setState(() => _controllers.add(TextEditingController(text: value)));
    widget.onChanged(_current());
  }

  void _remove(int index) {
    setState(() => _controllers.removeAt(index).dispose());
    widget.onChanged(_current());
  }

  /// 拖放排序：把 [oldIndex] 的項目移到 [newIndex]（onReorderItem 已調整索引）。
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final c = _controllers.removeAt(oldIndex);
      _controllers.insert(newIndex, c);
    });
    widget.onChanged(_current());
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        widget.localizations ?? StringListEditorLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 新增輸入列
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addCtrl,
                decoration: InputDecoration(
                  labelText: widget.addLabel,
                  isDense: true,
                ),
                onSubmitted: (_) => _add(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _add,
              tooltip: l10n.add,
              icon: const Icon(Icons.add, size: 20, color: Color(0xFF43A047)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // 列表區
        if (_controllers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.empty,
              style: const TextStyle(fontSize: 13, color: Color(0xFF9EAC9E)),
            ),
          )
        else
          Expanded(
            child: ReorderableListView(
              buildDefaultDragHandles: false,
              onReorderItem: _onReorder,
              children: [
                for (int i = 0; i < _controllers.length; i++) _buildRow(l10n, i),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildRow(StringListEditorLocalizations l10n, int index) {
    final controller = _controllers[index];
    return Padding(
      key: ValueKey(controller),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // 序號
          SizedBox(
            width: 24,
            child: Text(
              '${index + 1}.',
              style: const TextStyle(fontSize: 13, color: Color(0xFF9EAC9E)),
            ),
          ),
          // 可輸入的內容
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(isDense: true),
              onChanged: (_) => widget.onChanged(_current()),
            ),
          ),
          const SizedBox(width: 4),
          // 刪除
          IconButton(
            onPressed: () => _remove(index),
            tooltip: l10n.delete,
            icon: const Icon(Icons.delete_outline,
                size: 18, color: Color(0xFFD32F2F)),
          ),
          // 拖放手把（按住拖曳調整順序，置於刪除按鈕右側）
          ReorderableDragStartListener(
            index: index,
            child: Tooltip(
              message: l10n.drag,
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.drag_handle,
                  size: 20,
                  color: Color(0xFF9EAC9E),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 開啟字串列表編輯器對話框，回傳編輯後的列表（取消回傳 null）。
Future<List<String>?> showStringListEditorDialog({
  required BuildContext context,
  required List<String> initial,
  String? title,
  StringListEditorLocalizations? localizations,
}) {
  return showDialog<List<String>>(
    context: context,
    builder: (ctx) => _StringListEditorDialog(
      initial: initial,
      title: title,
      localizations: localizations,
    ),
  );
}

/// 以分隔字串為輸入／輸出的列表編輯器對話框。
///
/// 依 [delimiter] 把 [text] 拆分為列表供編輯，確認後以同一個分隔符合併回傳
/// （取消回傳 null）。適用於「輸入框存放逗號（或其他分隔符）分隔文字」的表單。
Future<String?> showDelimitedTextEditorDialog({
  required BuildContext context,
  required String text,
  Delimiter delimiter = Delimiter.comma,
  String? title,
  StringListEditorLocalizations? localizations,
}) async {
  final result = await showStringListEditorDialog(
    context: context,
    initial: splitList(text, delimiter),
    title: title,
    localizations: localizations,
  );
  return result == null ? null : joinList(result, delimiter);
}

/// 列表編輯器對話框（內部持有列表狀態）。
class _StringListEditorDialog extends StatefulWidget {
  const _StringListEditorDialog({
    required this.initial,
    this.title,
    this.localizations,
  });

  final List<String> initial;
  final String? title;
  final StringListEditorLocalizations? localizations;

  @override
  State<_StringListEditorDialog> createState() =>
      _StringListEditorDialogState();
}

class _StringListEditorDialogState extends State<_StringListEditorDialog> {
  late List<String> _items;

  @override
  void initState() {
    super.initState();
    _items = List<String>.from(widget.initial);
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        widget.localizations ?? StringListEditorLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title ?? l10n.defaultTitle),
      content: SizedBox(
        width: 360,
        height: 360,
        child: StringListEditor(
          items: _items,
          onChanged: (v) => setState(() => _items = v),
          localizations: widget.localizations,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(_items),
          child: Text(l10n.confirm),
        ),
      ],
    );
  }
}
