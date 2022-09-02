class DataModel {
  String? info;
  String? status;
  List<DistrictsModel>? districts;

  DataModel({
    this.info,
    this.status,
    this.districts,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      info: json["info"].toString(),
      status: json["status"].toString(),
      districts: List<DistrictsModel>.from(
          json["districts"].map((e) => DistrictsModel.fromJson(e))),
    );
  }
}

class DistrictsModel {
  String? adcode;
  String? name;
  String? center;
  List<DistrictsModel>? districts;

  DistrictsModel({
    this.adcode,
    this.name,
    this.center,
    this.districts,
  });

  factory DistrictsModel.fromJson(Map<String, dynamic> json) {
    return DistrictsModel(
      adcode: json["adcode"].toString(),
      name: json["name"].toString(),
      center: json["name"].toString(),
      districts: List<DistrictsModel>.from(
          json["districts"].map((e) => DistrictsModel.fromJson(e))),
    );
  }
}
