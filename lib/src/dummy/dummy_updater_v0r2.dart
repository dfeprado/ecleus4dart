import '../ecleus_database_interface.dart';
import '../ecleus_version_info.dart';
import '../ecleus_updater.dart';
import 'dummy_updater_v0r1.dart';

class DummyUpdaterV0R2 extends EcleusUpdater{
  final _version = EcleusVersionInfo(0, 2);

  DummyUpdaterV0R2(EcleusDatabaseInterface database) : super(database);

  @override
  EcleusUpdater? getPriorUpdater() => DummyUpdaterV0R1(database);

  @override
  EcleusVersionInfo getVersionInfo() => _version;

  @override
  void updateDatabase() {
    database.execute('create table log(msg varchar(128) not null, timestamp timestamp not null default current_time;');
  }
}