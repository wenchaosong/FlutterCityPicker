class DistrictsModel {
  String? citycode;
  String? adcode;
  String? name;
  String? center;
  String? level;
  List<DistrictsModel>? districts;

  DistrictsModel({
    this.citycode,
    this.adcode,
    this.name,
    this.center,
    this.level,
    this.districts,
  });

  factory DistrictsModel.fromJson(Map<String, dynamic> json) {
    return DistrictsModel(
      citycode: json["citycode"].toString(),
      adcode: json["adcode"].toString(),
      name: json["name"].toString(),
      center: json["name"].toString(),
      level: json["level"].toString(),
      districts: List<DistrictsModel>.from(
          json["districts"].map((e) => DistrictsModel.fromJson(e))),
    );
  }
}
