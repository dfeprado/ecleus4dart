import 'ecleus_database_interface.dart';
import 'ecleus_version_info.dart';

abstract class EcleusVersionControl {
  final EcleusDatabaseInterface database;

  EcleusVersionControl(this.database);

  void lockDatabase();
  void unlockDatabase();
  void buildVersionStructure();
  EcleusVersionInfo? getDatabaseVersion();
}