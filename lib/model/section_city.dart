import '../view/listview_section.dart';

import 'city.dart';

/// 城市列表数据模型
class SectionCity implements ExpandableListSection<City> {
  /// 字母
  String? letter;

  /// 当前字母的列表
  List<City>? data;

  SectionCity({
    this.letter,
    this.data,
  });

  factory SectionCity.fromJson(Map<String, dynamic> json) {
    return SectionCity(
      letter: json["letter"].toString(),
      data: json["data"] == null
          ? []
          : json["data"].map((o) => City.fromJson(o)).toList(),
    );
  }

  @override
  List<City>? getItems() {
    return data;
  }

  @override
  bool isSectionExpanded() {
    return true;
  }

  @override
  void setSectionExpanded(bool expanded) {}
}
