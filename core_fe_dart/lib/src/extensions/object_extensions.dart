extension ItemFold on Object? {
  dynamic castAllInSync<T>(T Function(dynamic) castCallBack) {
    var data = this;
    if (data == null) return null;
    if (data is Map) {
      var map = {};
      for (var key in data.keys) {
        map[key] = (data[key] as Object?).castAllInSync(castCallBack);
      }
      return map;
    } else if (data is List) {
      var list = [];
      for (var element in data) {
        list.add((element as Object).castAllInSync(castCallBack));
      }
      return list;
    } else {
      return castCallBack(data);
    }
  }

  Future<dynamic> castAllIn<T>(Future<T?> Function(Object) castCallBack) async {
    var data = this;
    if (data == null) return Future.value();
    if (data is Map) {
      var map = {};
      for (var key in data.keys) {
        map[key] = await (data[key] as Object?).castAllIn(castCallBack);
      }
      return map;
    } else if (data is List) {
      var list = [];
      for (var element in data) {
        list.add(await (element as Object).castAllIn(castCallBack));
      }
      return list;
    } else {
      return castCallBack(data);
    }
  }
}
