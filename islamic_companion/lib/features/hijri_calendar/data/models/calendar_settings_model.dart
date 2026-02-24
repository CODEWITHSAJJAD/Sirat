// ============================================================
// calendar_settings_model.dart
// Hive model for calendar user settings (moon adjustment).
// ============================================================

import 'package:hive/hive.dart';
import 'package:islamic_companion/core/constants/app_constants.dart';

part 'calendar_settings_model.g.dart';

@HiveType(typeId: AppConstants.calendarSettingsTypeId)
class CalendarSettingsModel extends HiveObject {
  @HiveField(0)
  int moonAdjustment; // +1 or -1 or 0

  CalendarSettingsModel({this.moonAdjustment = 0});
}
