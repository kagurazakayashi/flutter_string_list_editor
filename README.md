# flutter_string_list_editor

A reusable Flutter package (pure Dart + Flutter UI, no platform-native code) that
provides a visual string list editor dialog with configurable delimiters, plus
built-in English / Simplified Chinese / Traditional Chinese localizations.

## Features

- Visually add / edit / remove / reorder list items (drag the handle to reorder)
- Configurable delimiter: comma, semicolon, newline, pipe, tab, space, or a custom string
- `splitList` / `joinList` helpers for converting between delimited text and lists
- Automatic locale resolution with an optional `localizations` override
- Independent of any host application

## Requirements

- Dart `^3.0.0`
- Flutter `>=3.32.0`

## Installation

```yaml
dependencies:
  flutter_string_list_editor:
    path: packages/flutter_string_list_editor   # or a version once published
```

## Usage

```dart
import 'package:flutter_string_list_editor/flutter_string_list_editor.dart';

// 1) Edit a list of strings
final list = await showStringListEditorDialog(
  context: context,
  initial: const ['a', 'b', 'c'],
  title: 'Items',
);

// 2) Edit delimited text (splits/joins automatically)
final text = await showDelimitedTextEditorDialog(
  context: context,
  text: 'a,b,c',
  delimiter: Delimiter.comma,   // or .semicolon / .newline / .pipe / custom
);

// 3) Use the widget directly (needs a bounded height)
SizedBox(
  height: 300,
  child: StringListEditor(
    items: const ['a', 'b'],
    onChanged: (list) => print(list),
  ),
);

// 4) Split / join helpers
splitList('a, b, c', Delimiter.comma);    // ['a', 'b', 'c']
joinList(['a', 'b'], Delimiter.semicolon); // 'a;b'
```

## Delimiters

Built-in: `Delimiter.comma`, `.semicolon`, `.newline`, `.pipe`, `.tab`, `.space`.
Custom: `const Delimiter('||')`.

## Localization

Built-in localizations: English (`en`), Simplified Chinese (`zh_CN`) and
Traditional Chinese (`zh_TW`). The editor resolves the language automatically
from the ambient `MaterialApp` locale; to force one, pass `localizations`:

```dart
await showStringListEditorDialog(
  context: context,
  initial: const [],
  localizations: const StringListEditorLocalizationsZhCn(),
);
```

You may also subclass `StringListEditorLocalizations` to provide a custom language.

- `README.md` — English (en_US)
- `README.zh.md` — Simplified Chinese (zh_CN)
- Source code comments — Traditional Chinese (zh_TW)

## License

[Mulan PSL v2](LICENSE). Copyright (c) 2026 KagurazakaYashi (KagurazakaMiyabi).
