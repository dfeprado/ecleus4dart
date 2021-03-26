/// This enum declares comparison responses between database version and Ecleus known version
/// See `EcleusVersionInfo.compareTo()` for more information.
/// 
/// Possible values are
/// - **same:** same version and release
/// - **greaterRelease:** comparator has a newer release
/// - **lesserRelease:** comparator has a older release
/// - **greaterVersion:** comparator has a newer version
/// - **lesserVersion:** comparator has a older version
enum EcleusCompareResult {same, greaterRelease, lesserRelease, greaterVersion, lesserVersion}

/// Defines a class to represent database version
class EcleusVersionInfo {
  final int version;
  final int release;

  EcleusVersionInfo(this.version, this.release);

  /// Compare this version with `someVersion` and return a `EcleusCompareResult` value.
  /// The result are always in direction of `this` in relation to `someVersion`.
  /// 
  /// So, if result is **greaterRelease**, it means that `someVersion` has a newer release than `this`
  EcleusCompareResult compareTo(EcleusVersionInfo someVersion) {
    // same version
    if (someVersion.version == version && someVersion.release == release) {
      return EcleusCompareResult.same;
    }
    // same version, differente releases
    else if (someVersion.version == version && someVersion.release > release) {
      return EcleusCompareResult.greaterRelease;
    }
    else if (someVersion.version == version && someVersion.release < release) {
      return EcleusCompareResult.lesserRelease;
    }
    // differente versions
    else if (someVersion.version > version) {
      return EcleusCompareResult.greaterVersion;
    }
    else {
      return EcleusCompareResult.lesserVersion;
    }
  }

  String toString() {
    return '$version.$release';
  }
}