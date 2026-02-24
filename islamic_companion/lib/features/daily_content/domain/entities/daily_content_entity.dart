// ============================================================
// daily_content_entity.dart
// Domain entity for single daily Islamic content item.
// ============================================================

enum DailyContentType { ayah, hadith, dua, quote }

class DailyContentEntity {
  final String id;
  final DailyContentType type;
  final String arabic;      // Arabic text
  final String transliteration;
  final String translation; // Urdu or English
  final String reference;   // Surah/Hadith source
  final String category;    // optional (Morning, Evening, etc.)

  const DailyContentEntity({
    required this.id,
    required this.type,
    required this.arabic,
    this.transliteration = '',
    required this.translation,
    required this.reference,
    this.category = '',
  });
}
