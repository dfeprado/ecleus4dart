import '../ecleus_database_interface.dart';
import '../ecleus_version_info.dart';
import '../ecleus_updater.dart';

class DummyUpdaterV0R0 extends EcleusUpdater{
  final _version = EcleusVersionInfo(0, 0);

  DummyUpdaterV0R0(EcleusDatabaseInterface database) : super(database);

  @override
  EcleusUpdater? getPriorUpdater() => null;

  @override
  EcleusVersionInfo getVersionInfo() => _version;

  @override
  void updateDatabase() {
database.execute(
      'create table user ('
        'email varchar(20) not null primary key, '
        'password char(32) not null, '
        'creation_timestamp timestamp not null default current_timestamp'
      ');'
    );

    database.execute(
      'insert into user (email, password) values ("administrator@ecleus.com.br", "123456");'
    );
  }
}