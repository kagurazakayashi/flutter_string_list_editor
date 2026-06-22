# flutter_string_list_editor

一个可复用的 Flutter Package（纯 Dart + Flutter UI，无平台原生代码），提供可视化
字串列表编辑器对话框，支持可配置的分隔符，并内置英文 / 简体中文 / 繁体中文本地化。

## 特性

- 可视化新增 / 编辑 / 删除 / 排序列表项（点击移动一位，长按移到开头/结尾）
- 可配置分隔符：逗号、分号、换行、竖线、制表符、空格，或任意自定义字串
- `splitList` / `joinList` 工具函数，便于在分隔文本与列表之间转换
- 依环境语系自动选取本地化，也可传入 `localizations` 覆写
- 独立于宿主应用

## 环境要求

- Dart `^3.0.0`
- Flutter `>=3.32.0`

## 安装

```yaml
dependencies:
  flutter_string_list_editor:
    path: packages/flutter_string_list_editor   # 或发布后改用版本号
```

## 用法

```dart
import 'package:flutter_string_list_editor/flutter_string_list_editor.dart';

// 1) 编辑字串列表
final list = await showStringListEditorDialog(
  context: context,
  initial: const ['a', 'b', 'c'],
  title: 'Items',
);

// 2) 编辑分隔文本（自动拆分/合并）
final text = await showDelimitedTextEditorDialog(
  context: context,
  text: 'a,b,c',
  delimiter: Delimiter.comma,   // 或 .semicolon / .newline / .pipe / 自定义
);

// 3) 直接使用 widget
StringListEditor(
  items: const ['a', 'b'],
  onChanged: (list) => print(list),
);

// 4) 拆分 / 合并工具函数
splitList('a, b, c', Delimiter.comma);     // ['a', 'b', 'c']
joinList(['a', 'b'], Delimiter.semicolon); // 'a;b'
```

## 分隔符

内置：`Delimiter.comma`、`.semicolon`、`.newline`、`.pipe`、`.tab`、`.space`。
自定义：`const Delimiter('||')`。

## 本地化

内置英文（`en`）、简体中文（`zh_CN`）、繁体中文（`zh_TW`）三套语言。编辑器会
根据 `MaterialApp` 的环境语系自动选取；如需强制指定，可传入 `localizations`：

```dart
await showStringListEditorDialog(
  context: context,
  initial: const [],
  localizations: const StringListEditorLocalizationsZhCn(),
);
```

也可以继承 `StringListEditorLocalizations` 自定义其他语言。

- `README.md` — 英文（en_US）
- `README.zh.md` — 简体中文（zh_CN）
- 源代码注释 — 繁体中文（zh_TW）

## 许可

[Mulan PSL v2](LICENSE)。Copyright (c) 2026 KagurazakaYashi (KagurazakaMiyabi)。
