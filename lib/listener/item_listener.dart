/// 城市列表事件监听
abstract class ItemClickListener {
  /// 点击事件
  /// tabIndex：当前 tab 索引
  /// name：城市名称
  /// code：城市代码
  void onItemClick(int tabIndex, String name, String code);
}
