import '../view/listview_section.dart';
import 'address.dart';

/// 城市列表数据模型
class SectionCity implements ExpandableListSection<AddressNode> {
  /// 字母
  String? letter;

  /// 当前字母的列表
  List<AddressNode>? data;

  SectionCity({
    this.letter,
    this.data,
  });

  factory SectionCity.fromJson(Map<String, dynamic> json) {
    return SectionCity(
      letter: json["letter"].toString(),
      data: json["data"] == null
          ? []
          : json["data"].map((o) => AddressNode.fromJson(o)).toList(),
    );
  }

  @override
  List<AddressNode>? getItems() {
    return data;
  }

  @override
  bool isSectionExpanded() {
    return true;
  }

  @override
  void setSectionExpanded(bool expanded) {}
}
