enum EcleusCompareResult {same, greaterRelease, lesserRelease, greaterVersion, lesserVersion}

class EcleusVersionInfo {
  final int version;
  final int release;

  EcleusVersionInfo(this.version, this.release);

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