import '../../city_picker.dart';

/// 城市列表点击事件监听
abstract class ItemClickListener {
  /// 点击事件
  /// tabIndex：当前 tab 索引
  /// position：点击的索引
  /// data：当前 tab 数据
  void onItemClick(int tabIndex, int position, List<City> data);
}
