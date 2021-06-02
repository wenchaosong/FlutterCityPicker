import '../model/city.dart';

/// 事件监听
abstract class CityPickerListener {
  /// 获取省份数据
  Future<List<City>> loadProvinceData();

  /// 点击省份获取城市数据
  /// provinceCode：省份代码
  /// provinceName：省份名称
  Future<List<City>> onProvinceSelected(
    String? provinceCode,
    String? provinceName,
  );

  /// 点击城市获取区县数据
  /// cityCode：城市代码
  /// cityName：城市名称
  Future<List<City>> onCitySelected(
    String? cityCode,
    String? cityName,
  );

  /// 选择完成
  /// provinceCode：省份代码
  /// provinceName：省份名称
  /// cityCode：城市代码
  /// cityName：城市名称
  /// districtCode：县代码
  /// districtName：县名称
  void onFinish(
    String? provinceCode,
    String? provinceName,
    String? cityCode,
    String? cityName,
    String? districtCode,
    String? districtName,
  );
}
