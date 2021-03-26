import '../ecleus_database_interface.dart';
import '../ecleus_version_info.dart';
import '../ecleus_version_control.dart';

class DummyControlDatabaseWithoutControlStructure extends EcleusVersionControl {
  DummyControlDatabaseWithoutControlStructure(EcleusDatabaseInterface database) : super(database);

  @override
  void buildVersionStructure() {
    print('>>> Creating control structure');
    print('create schema ecleus;');
    print('create table ecleus.control (version int not null, release int not null, primary key(version, info));');
  }

  @override
  EcleusVersionInfo? getDatabaseVersion() => database.getDatabaseVersion();

  @override
  void lockDatabase() {
    print('** start transaction **');
    try {
      print('>>> Locking database');
      throw 'No structure found';
      print('lock table ecleus.control in access exclusive mode;');
    }
    catch (e) {
      print('$e');
    }
  }

  @override
  void unlockDatabase() {
    print('>>> Unlocking database');
    print('** commiting transaction or rollbacking **');
  }

}

class DummyControlV0R0 extends EcleusVersionControl {
  DummyControlV0R0(EcleusDatabaseInterface database) : super(database);

  @override
  void buildVersionStructure() {
    print('>>> Creating control structure');
    print('create schema ecleus;');
    print('create table ecleus.control (version int not null, release int not null, primary key(version, info));');
  }

  @override
  EcleusVersionInfo? getDatabaseVersion() => EcleusVersionInfo(0, 0);

  @override
  void lockDatabase() {
    print('** start transaction **');
    try {
      print('>>> Locking database');
      print('lock table ecleus.control in access exclusive mode;');
    }
    catch (e) {
      print('$e');
    }
  }

  @override
  void unlockDatabase() {
    print('>>> Unlocking database');
    print('** commiting transaction or rollbacking **');
  }

}