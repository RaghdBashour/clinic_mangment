import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/clinic_tables.dart';

part 'clinic_profile_dao.g.dart';

@DriftAccessor(tables: [ClinicProfiles])
class ClinicProfileDao extends DatabaseAccessor<AppDatabase>
    with _$ClinicProfileDaoMixin {
  ClinicProfileDao(super.db);

  Stream<ClinicProfile?> watchProfile() =>
      (select(clinicProfiles)..limit(1)).watchSingleOrNull();

  Future<ClinicProfile?> getProfile() =>
      (select(clinicProfiles)..limit(1)).getSingleOrNull();

  Future<int> saveProfile(ClinicProfilesCompanion entry) async {
    final existing = await getProfile();
    if (existing == null) {
      return into(clinicProfiles).insert(entry);
    }
    await (update(clinicProfiles)..where((t) => t.id.equals(existing.id)))
        .write(entry.copyWith(updatedAt: Value(DateTime.now().toUtc())));
    return existing.id;
  }
}
