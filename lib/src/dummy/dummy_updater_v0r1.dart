import 'package:ecleus4dart/src/dummy/dummy_updater_v0r0.dart';

import '../ecleus_database_interface.dart';
import '../ecleus_version_info.dart';
import '../ecleus_updater.dart';

class DummyUpdaterV0R1 extends EcleusUpdater{
  final _version = EcleusVersionInfo(0, 1);

  DummyUpdaterV0R1(EcleusDatabaseInterface database) : super(database);

  @override
  EcleusUpdater? getPriorUpdater() => DummyUpdaterV0R0(database);

  @override
  EcleusVersionInfo getVersionInfo() => _version;

  @override
  void updateDatabase() {
    database.execute('alter table user add column active bool not null default true;');
  }
}