extension SafeIndexAccess<T> on List<T> {
  T? safeGet(int index) {
    if (index >= 0 && index < length) {
      return this[index];
    }
    return null;
  }
}
