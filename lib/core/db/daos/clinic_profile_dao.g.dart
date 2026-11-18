// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinic_profile_dao.dart';

// ignore_for_file: type=lint
mixin _$ClinicProfileDaoMixin on DatabaseAccessor<AppDatabase> {
  $ClinicProfilesTable get clinicProfiles => attachedDatabase.clinicProfiles;
  ClinicProfileDaoManager get managers => ClinicProfileDaoManager(this);
}

class ClinicProfileDaoManager {
  final _$ClinicProfileDaoMixin _db;
  ClinicProfileDaoManager(this._db);
  $$ClinicProfilesTableTableManager get clinicProfiles =>
      $$ClinicProfilesTableTableManager(
        _db.attachedDatabase,
        _db.clinicProfiles,
      );
}
