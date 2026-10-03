/// A user's reusable result, separate from XP and the authored instructions.
/// Stored in the same profile/backup as the completed mission.
enum JourneyToolKind { flashcard, checklist, routine, script }

String toolText(String value) => String.fromCharCodes(
  value
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .replaceAll(RegExp(r'[\x00-\x09\x0b\x0c\x0e-\x1f]'), ' ')
      .trim()
      .runes
      .take(1200),
);

class JourneyTool {
  final JourneyToolKind kind;
  final List<String> fields;
  const JourneyTool({required this.kind, required this.fields});
  int get fieldCount => kind == JourneyToolKind.routine ? 3 : 2;
  String field(int index) => index < fields.length ? fields[index] : '';
  bool get hasContent => fields.any((text) => text.trim().isNotEmpty);
  Map<String, dynamic> toJson() => {
    'kind': kind.name,
    'fields': List.generate(fieldCount, (i) => toolText(field(i))),
  };
  static JourneyTool? parse(Object? json) {
    if (json is! Map || json['fields'] is! List) return null;
    final kind = JourneyToolKind.values
        .where((k) => k.name == json['kind'])
        .firstOrNull;
    final fields = json['fields'] as List;
    if (kind == null ||
        fields.length != (kind == JourneyToolKind.routine ? 3 : 2) ||
        fields.any((f) => f is! String)) {
      return null;
    }
    return JourneyTool(
      kind: kind,
      fields: List.unmodifiable(fields.cast<String>().map(toolText)),
    );
  }
}
