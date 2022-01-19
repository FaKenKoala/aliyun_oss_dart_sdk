class Owner {
  String? displayName;
  String? id;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Owner && other.displayName == displayName && other.id == id;
  }

  @override
  int get hashCode => Object.hash(displayName, id);

  @override
  String toString() {
    return "Owner [name=$displayName, id=$id]";
  }
}
