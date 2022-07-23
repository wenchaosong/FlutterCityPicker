import 'package:flutter_city_picker/model/address.dart';

/// 事件监听
abstract class CityPickerListener {
  /// 获取省份数据
  Future<List<AddressNode>> loadProvinceData();

  /// 选择省份
  /// provinceCode：省份代码
  /// provinceName：省份名称
  Future<List<AddressNode>> onProvinceSelected(
    String? provinceCode,
    String? provinceName,
  );

  /// 选择城市
  /// cityCode：城市代码
  /// cityName：城市名称
  Future<List<AddressNode>> onCitySelected(
    String? cityCode,
    String? cityName,
  );

  /// 选择区县
  /// districtCode：区县代码
  /// districtName：区县名称
  Future<List<AddressNode>> onDistrictSelected(
    String? districtCode,
    String? districtName,
  );

  /// 选择完成
  /// Address：城市数据
  void onFinish(Address address);
}
