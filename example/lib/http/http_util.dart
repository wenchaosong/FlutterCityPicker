import 'dart:convert';
import 'dart:io';

import 'package:flutter_city_picker/model/city.dart';

import 'model.dart';

class HttpUtils {
  static Future<List<City>> getCityData(String keywords) async {
    var url =
        'https://restapi.amap.com/v3/config/district?keywords=$keywords&subdistrict=1&key=6c8a3421379a8f7aa41e452175355c4b';
    var httpClient = HttpClient();
    List<City> result = [];
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var json = await response.transform(utf8.decoder).join();
    var data = jsonDecode(json);
    var list = List<DistrictsModel>.from(
        data["districts"].map((e) => DistrictsModel.fromJson(e)));
    DistrictsModel model = list.first;
    for (int i = 0; i < model.districts!.length; i++) {
      result.add(City(
          name: model.districts![i].name, code: model.districts![i].adcode));
    }
    return result;
  }
}
