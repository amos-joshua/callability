import 'package:objectbox/objectbox.dart';
import '../../objectbox.g.dart';
import 'enums.dart';
import 'group.dart';
import 'schedule.dart';

@Entity()
class PresetSetting {
  @Id()
  int id;

  @Transient()
  RingType leisureRingType;

  @Transient()
  RingType importantRingType;

  @Transient()
  RingType urgentRingType;

  final group = ToOne<ContactGroup>();
  final preset = ToOne<Preset>();

  int get dbLeisureRingType => leisureRingType.index;
  set dbLeisureRingType(int index) {
    leisureRingType = RingType.values[index];
  }

  int get dbImportantRingType => importantRingType.index;
  set dbImportantRingType(int index) {
    importantRingType = RingType.values[index];
  }

  int get dbUrgentRingType => urgentRingType.index;
  set dbUrgentRingType(int index) {
    urgentRingType = RingType.values[index];
  }

  int get ringTypeIndex => switch((leisureRingType, importantRingType, urgentRingType)) {
    (RingType.ring, _, _) => 0,
    (RingType.vibrate, _, _) => 1,
    (RingType.silent, RingType.ring, _) => 2,
    (RingType.silent, RingType.vibrate, _) => 3,
    (RingType.silent, RingType.silent, RingType.ring) => 4,
    (RingType.silent, RingType.silent, RingType.vibrate) => 5,
    (RingType.silent, RingType.silent, RingType.silent) => 6
  };

  set ringTypeIndex(int value) {
    leisureRingType = (value == 0) ? RingType.ring : (value <= 1) ? RingType.vibrate : RingType.silent;
    importantRingType = (value <= 2) ? RingType.ring : (value <= 3) ? RingType.vibrate : RingType.silent;
    urgentRingType = (value <= 4) ? RingType.ring : (value <= 5) ? RingType.vibrate : RingType.silent;
  }

  RingType ringTypeFor(CallUrgency urgency) => switch(urgency) {
    CallUrgency.leisure => leisureRingType,
    CallUrgency.important => importantRingType,
    CallUrgency.urgent => urgentRingType
  };

  void setRingTypeFor(CallUrgency urgency, {required RingType ringType}) {
    switch(urgency) {
      case CallUrgency.leisure:
        leisureRingType = ringType;
        break;
      case CallUrgency.important:
        importantRingType = ringType;
        break;
      case CallUrgency.urgent:
        urgentRingType = ringType;
        break;
    }
  }

  void update(PresetSetting other) {
    leisureRingType = other.leisureRingType;
    importantRingType = other.importantRingType;
    urgentRingType = other.urgentRingType;
  }
  
  bool belongsToGroup(ContactGroup someGroup) => group.target?.id == someGroup.id;

  PresetSetting({this.id = 0, this.leisureRingType = RingType.ring, this.importantRingType = RingType.ring, this.urgentRingType = RingType.ring});

  @override
  String toString() => 'PresetSetting(${group.target?.name} => (${leisureRingType.label}, ${importantRingType.label}, ${urgentRingType.label}))';

  Map asMap() {
    return {
      'groupName': group.target?.name,
      'leisureRingType': leisureRingType.index,
      'importantRingType': importantRingType.index,
      'urgentRingType': urgentRingType.index,
    };
  }

  static PresetSetting forGroup(ContactGroup group, RingType leisureRingType, RingType importantRingType, RingType urgentRingType) {
    return PresetSetting(
      leisureRingType: leisureRingType,
      importantRingType: importantRingType,
      urgentRingType: urgentRingType
      )..group.target = group;
  }
}

@Entity()
class Preset {
  static const defaultPresetName = 'Available';

  @Id()
  int id;
  String name;
  bool isDefault;

  @Backlink('preset')
  final settings = ToMany<PresetSetting>();

  @Backlink('preset')
  final schedules = ToMany<Schedule>();

  Preset({this.id = 0, required this.name, this.isDefault = false});

  Schedule? activeScheduleAt(DateTime time) => schedules.cast<Schedule?>().firstWhere((schedule) => schedule?.activeAt(time) == true, orElse: () => null);

  PresetSetting? settingForGroup(ContactGroup group) => settings.where((setting) => setting.group.targetId == group.id).firstOrNull;
  @override
  String toString() => 'Preset($name, id: $id, isDefault: $isDefault)';

  Map asMap() {
    final validSettings = settings.where((setting) => setting.group.target != null);
    return {
      'name': name,
      'isDefault': isDefault,
      'settings': [... validSettings.map((setting) => setting.asMap())],
      'schedules': [... schedules.map((schedule) => schedule.asMap())]
    };
  }
}

class ActivePresetData {
  final Preset preset;
  final bool isOverride;
  final DateTime endTime;
  ActivePresetData({required this.preset, required this.isOverride, required this.endTime});
}