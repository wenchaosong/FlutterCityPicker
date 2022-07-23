/// 地址实体类
class Address {
  /// 省
  AddressNode? province;

  /// 市
  AddressNode? city;

  /// 区
  AddressNode? district;

  /// 街道
  AddressNode? street;

  Address({
    this.province,
    this.city,
    this.district,
    this.street,
  });

  @override
  String toString() {
    return 'Address(${province?.name}，${city?.name}，${district?.name}，${street?.name})';
  }
}

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
