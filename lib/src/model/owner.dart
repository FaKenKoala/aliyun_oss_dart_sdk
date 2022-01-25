/// OSS Bucket owner class definition
class Owner {
  String? displayName;
  String? id;

  Owner([this.id, this.displayName]);

  /// Returns the serialization string.
  @override
  String toString() {
    return "Owner [name=$displayName,id=$id]";
  }

  /// Checks if 'this' object is same as the specified one.
  @override
  bool operator ==(Object obj) {
    return identical(this, obj) ||
        obj is Owner && obj.id == id && obj.displayName == displayName;
  }

  /// Gets the hash code of the 'this' object
  @override
  int get hashCode {
    return id?.hashCode ?? 0;
  }
}
