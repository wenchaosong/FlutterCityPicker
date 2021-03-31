/// 城市的数据模型
class City {
  /// 名称
  String name;

  /// 代码
  String code;

  City({
    this.name,
    this.code,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json["name"].toString(),
      code: json["code"].toString(),
    );
  }
}
