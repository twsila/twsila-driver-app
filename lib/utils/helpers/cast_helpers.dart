T? tryCast<T>({dynamic obj}) {
  if (obj == null) {
    return null;
  }
  if (obj is T) {
    return obj;
  } else {
    try {
      var result = obj as T;
      return result;
    } catch (e) {
      if (T == double && obj is int) {
        var result = obj.toDouble() as T;
        return result;
      }
      return null;
    }
  }
}

List<Object?> tryCastList<T>({dynamic obj}) {
  if (obj == null) {
    return [];
  }

  if (obj is List == false) {
    return [];
  }
  var list = obj as List;
  return list
      .map((e) => tryCast<T>(obj: e) ?? null)
      .where((element) => element != null)
      .map((e) => e!)
      .toList();
}
