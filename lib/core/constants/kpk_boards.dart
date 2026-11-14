/// Academic class levels supported by Imtihan Pro (KPK BISE Matric & HSSC).
enum ClassLevel {
  class9(id: 'class_9', label: 'Class 9', subtitle: 'SSC Part I • Matric'),
  class10(id: 'class_10', label: 'Class 10', subtitle: 'SSC Part II • Matric'),
  class11(id: 'class_11', label: 'Class 11', subtitle: 'HSSC Part I • FSc/FA'),
  class12(id: 'class_12', label: 'Class 12', subtitle: 'HSSC Part II • FSc/FA');

  const ClassLevel({
    required this.id,
    required this.label,
    required this.subtitle,
  });

  final String id;
  final String label;
  final String subtitle;

  static ClassLevel? fromId(String? id) {
    if (id == null) return null;
    for (final level in values) {
      if (level.id == id) return level;
    }
    return null;
  }
}

/// All eight official Boards of Intermediate and Secondary Education (BISE) in KPK.
enum KpkBoard {
  peshawar(id: 'bise_peshawar', name: 'BISE Peshawar', region: 'Peshawar Division'),
  abbottabad(id: 'bise_abbottabad', name: 'BISE Abbottabad', region: 'Hazara Division'),
  mardan(id: 'bise_mardan', name: 'BISE Mardan', region: 'Mardan Division'),
  swat(id: 'bise_swat', name: 'BISE Swat', region: 'Malakand / Swat'),
  kohat(id: 'bise_kohat', name: 'BISE Kohat', region: 'Kohat Division'),
  bannu(id: 'bise_bannu', name: 'BISE Bannu', region: 'Bannu Division'),
  deraIsmailKhan(
    id: 'bise_dikhan',
    name: 'BISE Dera Ismail Khan',
    region: 'D.I. Khan Division',
  ),
  malakand(id: 'bise_malakand', name: 'BISE Malakand', region: 'Chakdara / Lower Dir');

  const KpkBoard({
    required this.id,
    required this.name,
    required this.region,
  });

  final String id;
  final String name;
  final String region;

  static KpkBoard? fromId(String? id) {
    if (id == null) return null;
    for (final board in values) {
      if (board.id == id) return board;
    }
    return null;
  }
}

/// Academic groups offered across Class 9-12 in KPK BISE examinations.
enum AcademicGroup {
  science(
    id: 'science',
    label: 'Science',
    subtitle: 'Physics, Chemistry, Mathematics, Biology / CS',
  ),
  arts(
    id: 'arts',
    label: 'Arts',
    subtitle: 'Humanities, Civics, Islamic Studies, General Science',
  ),
  commerce(
    id: 'commerce',
    label: 'Commerce',
    subtitle: 'Accounting, Business Math, Economics, Statistics',
  );

  const AcademicGroup({
    required this.id,
    required this.label,
    required this.subtitle,
  });

  final String id;
  final String label;
  final String subtitle;

  static AcademicGroup? fromId(String? id) {
    if (id == null) return null;
    for (final group in values) {
      if (group.id == id) return group;
    }
    return null;
  }
}
