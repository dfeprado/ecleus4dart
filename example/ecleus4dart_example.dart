import 'package:ecleus4dart/ecleus4dart.dart';

// DummyDatabase simulates a database connection. The DBMS kind does not matter to Ecleus
class DummyDatabase implements EcleusDatabaseInterface {
  @override
  void execute(String command) {
    print('Executing command $command');
  }

  @override
  void insertVersionInfo(int version, int release) {
    print('>>> Insert version info');
    print('Insert into ecleus.control values ($version, $release);');
  }

  @override
  EcleusVersionInfo? getDatabaseVersion() => null;
}

// DummyControlDatabaseWithoutControlStructure simulates a Ecleu's execution in an environment
// without control struture: a "virgin" database
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

// DummyControlV0R0 simulates a environment with a database already in version 0.0
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

// The first database deploy: v0.0
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

// The second database deploy: v0.1
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

// The third database deploy: v0.2
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

// In this case, database control structure needs to be created. It simulates an scenario
// where database has no tables/schem and needs to be created from scratch.
//
// This will run DummyUpdaterV0R0 up to DummyUpdaterV0R2
void runVirginEnvironment() {
  var database = DummyDatabase();
  var ecleus = Ecleus(DummyControlDatabaseWithoutControlStructure(database), DummyUpdaterV0R2(database));
  ecleus.run();
}

// In this case, database control structure already exists and sits on V0.0. So, Ecleus
// will identify the current database version (0.0) and apply just DummyUpdaterV0R1 and DummyUpdateV0R2
void runAlreadyDeployedV0R0() {
  var database = DummyDatabase();
  var ecleus = Ecleus(DummyControlV0R0(database), DummyUpdaterV0R2(database));
  ecleus.run();
}

void main() {
  runVirginEnvironment();
  runAlreadyDeployedV0R0();
}
