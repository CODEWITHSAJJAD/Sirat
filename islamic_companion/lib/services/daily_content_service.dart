// ============================================================
// daily_content_service.dart
// Offline content service — all data is bundled in-app.
// Returns a deterministic daily item based on day-of-year.
// ============================================================

import 'package:islamic_companion/features/daily_content/domain/entities/daily_content_entity.dart';

class DailyContentService {
  // ── Ayahs (10 featured verses) ────────────────────────────
  static const List<Map<String, String>> _ayahs = [
    {'id': 'a1', 'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', 'translation': 'In the name of Allah, the Most Gracious, the Most Merciful.', 'ref': 'Al-Fatiha 1:1'},
    {'id': 'a2', 'arabic': 'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ', 'translation': 'And when My servants ask about Me — indeed I am near.', 'ref': 'Al-Baqara 2:186'},
    {'id': 'a3', 'arabic': 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ', 'translation': 'Allah — there is no deity except Him, the Ever-Living, the Self-Sustaining.', 'ref': 'Al-Baqara 2:255 (Ayat ul Kursi)'},
    {'id': 'a4', 'arabic': 'فَإِنَّ مَعَ الْعُسْرِ يُسْرًا', 'translation': 'For indeed, with hardship will be ease.', 'ref': 'Al-Inshirah 94:5'},
    {'id': 'a5', 'arabic': 'وَاللَّهُ الَّذِي أَرْسَلَ الرِّيَاحَ فَتُثِيرُ سَحَابًا', 'translation': 'And it is Allah who sends the winds, and they stir the clouds.', 'ref': 'Fatir 35:9'},
    {'id': 'a6', 'arabic': 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ', 'translation': 'Allah is sufficient for us, and He is the best disposer of affairs.', 'ref': 'Al Imran 3:173'},
    {'id': 'a7', 'arabic': 'إِنَّ اللَّهَ مَعَ الصَّابِرِينَ', 'translation': 'Indeed, Allah is with the patient.', 'ref': 'Al-Baqara 2:153'},
    {'id': 'a8', 'arabic': 'وَقُل رَّبِّ زِدْنِي عِلْمًا', 'translation': 'Say: My Lord, increase me in knowledge.', 'ref': 'Ta-Ha 20:114'},
    {'id': 'a9', 'arabic': 'إِنَّ الصَّلَاةَ تَنْهَىٰ عَنِ الْفَحْشَاءِ وَالْمُنكَرِ', 'translation': 'Indeed, prayer prohibits immorality and wrongdoing.', 'ref': 'Al-Ankabut 29:45'},
    {'id': 'a10', 'arabic': 'وَتَوَكَّلْ عَلَى اللَّهِ وَكَفَىٰ بِاللَّهِ وَكِيلًا', 'translation': 'And rely upon Allah; and sufficient is Allah as Disposer.', 'ref': 'Al-Ahzab 33:3'},
  ];

  // ── Hadiths (10 selected) ─────────────────────────────────
  static const List<Map<String, String>> _hadiths = [
    {'id': 'h1', 'arabic': 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ', 'translation': 'Actions are judged by intentions.', 'ref': 'Sahih Bukhari 1'},
    {'id': 'h2', 'arabic': 'الطُّهُورُ شَطْرُ الْإِيمَانِ', 'translation': 'Cleanliness is half of faith.', 'ref': 'Sahih Muslim 223'},
    {'id': 'h3', 'arabic': 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ', 'translation': 'The best of you are those who learn and teach the Quran.', 'ref': 'Sahih Bukhari 5027'},
    {'id': 'h4', 'arabic': 'الدِّينُ النَّصِيحَةُ', 'translation': 'The religion is sincere advice.', 'ref': 'Sahih Muslim 55'},
    {'id': 'h5', 'arabic': 'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ', 'translation': 'None of you truly believes until he loves for his brother what he loves for himself.', 'ref': 'Sahih Bukhari 13'},
    {'id': 'h6', 'arabic': 'الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ', 'translation': 'A Muslim is one from whose tongue and hands Muslims are safe.', 'ref': 'Sahih Bukhari 10'},
    {'id': 'h7', 'arabic': 'أَحَبُّ الأَعْمَالِ إِلَى اللهِ أَدْوَمُهَا وَإِنْ قَلَّ', 'translation': 'The most beloved deeds to Allah are those done consistently, even if small.', 'ref': 'Sahih Bukhari 6464'},
    {'id': 'h8', 'arabic': 'إِنَّ اللهَ جَمِيلٌ يُحِبُّ الجَمَالَ', 'translation': 'Indeed Allah is beautiful and loves beauty.', 'ref': 'Sahih Muslim 91'},
    {'id': 'h9', 'arabic': 'مَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ', 'translation': 'Whoever fasts Ramadan out of faith and with hope of reward, his previous sins will be forgiven.', 'ref': 'Sahih Bukhari 38'},
    {'id': 'h10', 'arabic': 'اتَّقِ اللهَ حَيْثُمَا كُنْتَ', 'translation': 'Fear Allah wherever you are.', 'ref': 'Tirmidhi 1987'},
  ];

  // ── Duas (10 common) ──────────────────────────────────────
  static const List<Map<String, String>> _duas = [
    {'id': 'd1', 'arabic': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ', 'translation': 'Our Lord! Grant us good in this world and in the Hereafter, and save us from the punishment of the Fire.', 'ref': 'Al-Baqara 2:201', 'category': 'General'},
    {'id': 'd2', 'arabic': 'اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ', 'translation': 'O Allah, You are my Lord, there is no god but You, You created me and I am Your servant.', 'ref': 'Sayyid al-Istighfar – Bukhari 6306', 'category': 'Morning'},
    {'id': 'd3', 'arabic': 'رَّبِّ أَعُوذُ بِكَ مِنْ هَمَزَاتِ الشَّيَاطِينِ', 'translation': 'My Lord, I seek refuge in You from the incitements of the devils.', 'ref': 'Al-Muminun 23:97', 'category': 'Protection'},
    {'id': 'd4', 'arabic': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالعَافِيَةَ', 'translation': 'O Allah, I ask You for pardon and well-being.', 'ref': 'Abu Dawud 5074', 'category': 'Evening'},
    {'id': 'd5', 'arabic': 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي', 'translation': 'My Lord, expand for me my breast and ease for me my task.', 'ref': 'Ta-Ha 20:25-26', 'category': 'Study'},
    {'id': 'd6', 'arabic': 'يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ', 'translation': 'O Turner of hearts, make my heart firm upon Your religion.', 'ref': 'Tirmidhi 3522', 'category': 'Faith'},
    {'id': 'd7', 'arabic': 'اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ', 'translation': 'O Allah, bless us in what You have provided us and protect us from the Fire.', 'ref': 'Before meals', 'category': 'Meals'},
    {'id': 'd8', 'arabic': 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ', 'translation': 'I seek refuge in the perfect words of Allah from the evil of what He has created.', 'ref': 'Sahih Muslim 2708', 'category': 'Evening'},
    {'id': 'd9', 'arabic': 'اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَاهْدِنِي وَعَافِنِي وَارْزُقْنِي', 'translation': 'O Allah, forgive me, have mercy on me, guide me, grant me well-being, and provide for me.', 'ref': 'Sahih Muslim 2697', 'category': 'General'},
    {'id': 'd10', 'arabic': 'سُبْحَانَكَ اللَّهُمَّ وَبِحَمْدِكَ أَشْهَدُ أَنْ لَا إِلَهَ إِلَّا أَنْتَ أَسْتَغْفِرُكَ وَأَتُوبُ إِلَيْكَ', 'translation': 'Glory be to You, O Allah, with Your praise. I testify that there is no god but You. I seek Your forgiveness and repent to You.', 'ref': 'Kaffaratul Majlis – Tirmidhi', 'category': 'After sitting'},
  ];

  /// Get today's content — cycles deterministically by day of year
  DailyContentEntity getTodayAyah() => _mapAyah(_ayahs[_todayIndex(_ayahs.length)]);
  DailyContentEntity getTodayHadith() => _mapHadith(_hadiths[_todayIndex(_hadiths.length)]);
  DailyContentEntity getTodayDua() => _mapDua(_duas[_todayIndex(_duas.length)]);

  int _todayIndex(int total) =>
      DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays % total;

  DailyContentEntity _mapAyah(Map<String, String> m) => DailyContentEntity(
        id: m['id']!, type: DailyContentType.ayah,
        arabic: m['arabic']!, translation: m['translation']!, reference: m['ref']!);

  DailyContentEntity _mapHadith(Map<String, String> m) => DailyContentEntity(
        id: m['id']!, type: DailyContentType.hadith,
        arabic: m['arabic']!, translation: m['translation']!, reference: m['ref']!);

  DailyContentEntity _mapDua(Map<String, String> m) => DailyContentEntity(
        id: m['id']!, type: DailyContentType.dua,
        arabic: m['arabic']!, translation: m['translation']!,
        reference: m['ref']!, category: m['category'] ?? '');

  List<DailyContentEntity> getAllDuas() =>
      _duas.map(_mapDua).toList();

  List<DailyContentEntity> getAllHadiths() =>
      _hadiths.map(_mapHadith).toList();
}
