import 'ecleus_version_info.dart';

abstract class EcleusDatabaseInterface {
  void insertVersionInfo(int version, int release);
  void execute(String command);
  EcleusVersionInfo? getDatabaseVersion();
}