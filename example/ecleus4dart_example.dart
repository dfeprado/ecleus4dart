import 'package:ecleus4dart/ecleus4dart.dart';
import 'package:ecleus4dart/src/dummy/dummy_control.dart';
import 'package:ecleus4dart/src/dummy/dummy_database.dart';
import 'package:ecleus4dart/src/dummy/dummy_updater_v0r2.dart';

void main() {
  var database = DummyDatabase();
  // var ecleus = Ecleus(DummyControlDatabaseWithoutControlStructure(database), DummyUpdaterV0R2(database));
  var ecleus = Ecleus(DummyControlV0R0(database), DummyUpdaterV0R2(database));
  ecleus.run();
}
