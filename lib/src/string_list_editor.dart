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

/// 字串列表編輯器：以列表呈現，每項皆可輸入編輯；支援新增、刪除、上移、下移。
///
/// 「移到開頭／移到結尾」由**長按**上移／下移按鈕觸發。
/// 任何變更（含逐字輸入）皆透過 [onChanged] 回報完整的新列表。
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

  void _move(int index, int delta) {
    final target = index + delta;
    if (target < 0 || target >= _controllers.length) return;
    setState(() {
      final c = _controllers.removeAt(index);
      _controllers.insert(target, c);
    });
    widget.onChanged(_current());
  }

  void _moveToStart(int index) {
    if (index == 0) return;
    setState(() {
      final c = _controllers.removeAt(index);
      _controllers.insert(0, c);
    });
    widget.onChanged(_current());
  }

  void _moveToEnd(int index) {
    final last = _controllers.length - 1;
    if (index == last) return;
    setState(() {
      final c = _controllers.removeAt(index);
      _controllers.add(c);
    });
    widget.onChanged(_current());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.localizations ?? StringListEditorLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
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
          for (int i = 0; i < _controllers.length; i++) _buildRow(l10n, i),
      ],
    );
  }

  Widget _buildRow(StringListEditorLocalizations l10n, int index) {
    final isFirst = index == 0;
    final isLast = index == _controllers.length - 1;

    return Padding(
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
              controller: _controllers[index],
              decoration: const InputDecoration(isDense: true),
              onChanged: (_) => widget.onChanged(_current()),
            ),
          ),
          const SizedBox(width: 4),
          // 上移（長按=移到開頭）
          _moveButton(
            tooltip: l10n.moveUp,
            icon: Icons.arrow_upward,
            onTap: isFirst ? null : () => _move(index, -1),
            onLongPress: isFirst ? null : () => _moveToStart(index),
          ),
          // 下移（長按=移到結尾）
          _moveButton(
            tooltip: l10n.moveDown,
            icon: Icons.arrow_downward,
            onTap: isLast ? null : () => _move(index, 1),
            onLongPress: isLast ? null : () => _moveToEnd(index),
          ),
          // 刪除
          IconButton(
            onPressed: () => _remove(index),
            tooltip: l10n.delete,
            icon: const Icon(Icons.delete_outline,
                size: 18, color: Color(0xFFD32F2F)),
          ),
        ],
      ),
    );
  }

  /// 上移／下移按鈕：點擊＝移動一位，長按＝移到開頭／結尾。
  Widget _moveButton({
    required String tooltip,
    required IconData icon,
    required VoidCallback? onTap,
    required VoidCallback? onLongPress,
  }) {
    final enabled = onTap != null;
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(
            icon,
            size: 18,
            color: enabled ? const Color(0xFF43A047) : const Color(0xFFB0B0B0),
          ),
        ),
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
    final l10n = widget.localizations ?? StringListEditorLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title ?? l10n.defaultTitle),
      content: SingleChildScrollView(
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
