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
