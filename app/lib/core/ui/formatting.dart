String _two(int v) => v.toString().padLeft(2, '0');

/// Formats a date as `dd.MM.yyyy`.
String formatDate(DateTime date) =>
    '${_two(date.day)}.${_two(date.month)}.${date.year}';

String? formatDateRange(DateTime? start, DateTime? end) {
  if (start == null && end == null) return null;
  if (start != null && end != null) {
    return '${formatDate(start)} – ${formatDate(end)}';
  }
  if (start != null) return 'ab ${formatDate(start)}';
  return 'bis ${formatDate(end!)}';
}
