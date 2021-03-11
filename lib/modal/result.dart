import 'dart:convert';

/// CityPicker 返回的 **Result** 结果函数
class Result {
  /// provinceId
  String provinceId;

  /// cityId
  String cityId;

  /// areaId
  String areaId;

  String villageId; // 增加第4级(村/镇)选择

  /// provinceName
  String provinceName;

  /// cityName
  String cityName;

  /// areaName
  String areaName;

  String villageName; // 增加第4级(村/镇)选择

  Result(
      {this.provinceId,
      this.cityId,
      this.areaId,
      // 增加第4级(村/镇)选择
      this.villageId,
      this.provinceName,
      this.cityName,
      this.areaName,
      // 增加第4级(村/镇)选择
      this.villageName});

  /// string json
  @override
  String toString() {
    Map<String, dynamic> obj = {
      'provinceName': provinceName,
      'provinceId': provinceId,
      'cityName': cityName,
      'villageName': villageName, // 增加第4级(村/镇)选择
      'cityId': cityId,
      'areaName': areaName,
      'areaId': areaId,
      'villageId': villageId // 增加第4级(村/镇)选择
    };
    obj.removeWhere((key, value) => value == null);

    return json.encode(obj);
  }
}
