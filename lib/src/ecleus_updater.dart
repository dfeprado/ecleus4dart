import 'ecleus_version_info.dart';
import 'ecleus_database_interface.dart';

abstract class EcleusUpdater {
  final EcleusDatabaseInterface database;

  EcleusUpdater(this.database);

  EcleusVersionInfo getVersionInfo();
  EcleusUpdater? getPriorUpdater();
  void updateDatabase();

  void execute() {
    var versionInfo = getVersionInfo();
    database.insertVersionInfo(versionInfo.version, versionInfo.release);
    updateDatabase();
  }
}