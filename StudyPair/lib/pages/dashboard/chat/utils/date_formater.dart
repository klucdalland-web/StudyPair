String formatMessageDate(DateTime date) {
  final now = DateTime.now();

  final isToday =
      now.year == date.year &&
      now.month == date.month &&
      now.day == date.day;

  final time =
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';

  if (isToday) {
    return time;
  }

  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year} à $time';
}