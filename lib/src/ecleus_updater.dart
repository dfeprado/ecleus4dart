import 'ecleus_version_info.dart';
import 'ecleus_database_interface.dart';

/// Defines the Updater structure used by `Ecleus`
/// You should extends this to DBMS-Specific logic.
abstract class EcleusUpdater {
  final EcleusDatabaseInterface database;

  EcleusUpdater(this.database);

  /// Return THIS updater version
  EcleusVersionInfo getVersionInfo();

  /// Returns the older version, prior to this one.
  EcleusUpdater? getPriorUpdater();

  /// Executes the needed update commands
  void updateDatabase();

  /// Execute this upater.
  /// First, insert version info to version control structure
  /// Then, runs `updateDatabase()`
  void execute() {
    var versionInfo = getVersionInfo();
    database.insertVersionInfo(versionInfo.version, versionInfo.release);
    updateDatabase();
  }
}