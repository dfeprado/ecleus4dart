import 'ecleus_version_info.dart';
import 'ecleus_version_control.dart';
import 'ecleus_updater.dart';

class EcleusIncompatibleVersionException implements Exception {
  final String message;

  EcleusIncompatibleVersionException(this.message);
}

class Ecleus {
  final EcleusVersionControl _versionControl;
  final EcleusUpdater _latestVersion;

  Ecleus(this._versionControl, this._latestVersion);

  List<EcleusUpdater> _getAllUpdaters() {
    var updaterList = <EcleusUpdater>[_latestVersion];
    var priorUpdater = _latestVersion.getPriorUpdater();

    while (priorUpdater != null) {
      updaterList.add(priorUpdater);
      priorUpdater = priorUpdater.getPriorUpdater();
    }

    return List<EcleusUpdater>.from(updaterList.reversed);
  }

  List<EcleusUpdater> _getAllUpdatersAheadOf(EcleusVersionInfo currentDatabaseVersion) {
    var updateList = <EcleusUpdater>[_latestVersion];
    var priorUpdater = _latestVersion.getPriorUpdater();
    while (priorUpdater != null) {
      var priorUpdaterVersion = priorUpdater.getVersionInfo();
      if (![EcleusCompareResult.greaterRelease, EcleusCompareResult.greaterVersion].contains(currentDatabaseVersion.compareTo(priorUpdaterVersion))) {
        break;
      }
      updateList.add(priorUpdater);
      priorUpdater = priorUpdater.getPriorUpdater();
    }

    return List<EcleusUpdater>.from(updateList.reversed);
  }

  void run() {
    // Lock the database to perform analyze.
    _versionControl.lockDatabase();

    // 1. Get the database current version.
    //  If one is found, compare with latestKnown version
    //  else, create versioning structure and run all known updaters (create database structure)
    var currentDatabaseVersion = _versionControl.getDatabaseVersion();
    if (currentDatabaseVersion != null) {

      // If comparison results in "same" or "lesserRelease", nothing is done. (not declared in code)
      //
      //  (1) else if comparison results is "greaterVersion" or "greaterRelease", so
      //    database is older and needs to be updated.
      //
      //  (2) else if comparsion results is "lesserVersion", database is newer
      //    than the last known updater and not compatible. So, EcleusIncompatibleVersionException is throwed.
      var comparison = currentDatabaseVersion.compareTo(_latestVersion.getVersionInfo());
      if ([EcleusCompareResult.greaterVersion, EcleusCompareResult.greaterRelease].contains(comparison)) {
        var updaterList = _getAllUpdatersAheadOf(currentDatabaseVersion);
        for (var updater in updaterList) {
          updater.execute();
        }
      }
      else if (comparison == EcleusCompareResult.lesserVersion) {
        throw EcleusIncompatibleVersionException(
          'Database has a greater version. '
          'Latest known version: ${_latestVersion.getVersionInfo().toString()} / '
          'Database version: ${currentDatabaseVersion.toString()}'
        );
      }
    }

    else {
      _versionControl.buildVersionStructure();
      var updaterList = _getAllUpdaters();
      for (var updater in updaterList) {
        updater.execute();       
      }
    }

    _versionControl.unlockDatabase();
  }
}