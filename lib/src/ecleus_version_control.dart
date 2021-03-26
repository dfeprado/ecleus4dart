import 'ecleus_database_interface.dart';
import 'ecleus_version_info.dart';

/// Defines a version control structure used by `Ecleus`.
/// You should extend this to create DBMS-specific controllers.
abstract class EcleusVersionControl {
  final EcleusDatabaseInterface database;

  EcleusVersionControl(this.database);

  /// Locks database to avoid multiple Ecleus instances executing on one database
  void lockDatabase();

  /// Unlocks database to allow others instances to use it
  void unlockDatabase();

  /// Creates the version control structure
  void buildVersionStructure();

  /// Returns the current database version. Should return `null` if none.
  EcleusVersionInfo? getDatabaseVersion();
}