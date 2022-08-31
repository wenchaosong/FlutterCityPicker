/// 城市的数据模型
class AddressNode {
  /// 名称
  String? name;

  /// 代码
  String? code;

  /// 首字母
  String? letter;

  AddressNode({
    this.name,
    this.code,
    this.letter,
  });

  factory AddressNode.fromJson(Map<String, dynamic> json) {
    return AddressNode(
      name: json["name"].toString(),
      code: json["code"].toString(),
      letter: json["letter"].toString(),
    );
  }
}
