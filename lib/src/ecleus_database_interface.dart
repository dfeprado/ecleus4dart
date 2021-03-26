import 'ecleus_version_info.dart';

/// Defines the Ecleus Database Interface for usage by Ecleus instance.
/// Extends this to implement specific DBMS logics
abstract class EcleusDatabaseInterface {
  /// Used to insert version control information in database
  /// 
  /// ### Command example (PostgreSQL)
  /// ```sql
  /// insert into ecleus.info values ($version, $release);
  /// ```
  void insertVersionInfo(int version, int release);

  /// Used to execute `EcleusUpdater` commands.
  void execute(String command);

  /// Used to return the current database version
  /// It should return `null` in case of none to indicates to Ecleus
  /// that no version control schema was found.
  /// 
  /// ### Example (PostgreSQL)
  /// ```
  /// try {
  ///   // Try to get database information
  ///   return postgresql
  ///     .query('select version, release from ecleus.info order by 1 desc, 2 desc limit 0;')
  ///     (...);
  /// }
  /// catch (e) {
  ///   return null;
  /// }
  /// ```
  EcleusVersionInfo? getDatabaseVersion();
}