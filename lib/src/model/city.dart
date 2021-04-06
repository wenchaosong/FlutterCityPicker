/// 城市的数据模型
class City {
  /// 名称
  String name;

  /// 代码
  String code;

  /// 首字母
  String letter;

  City({
    this.name,
    this.code,
    this.letter,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json["name"].toString(),
      code: json["code"].toString(),
      letter: json["letter"].toString(),
    );
  }
}
