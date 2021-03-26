import 'package:ecleus4dart/src/ecleus_version_info.dart';

import '../ecleus_database_interface.dart';

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