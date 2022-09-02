import 'package:dio/dio.dart';
import 'package:flutter_city_picker/model/address.dart';

import 'model.dart';

class HttpUtils {
  static Future<List<AddressNode>> getCityData(String keywords) async {
    var url = 'https://restapi.amap.com/v3/config/district';
    var param = {
      "keywords": keywords,
      "subdistrict": 1,
      "key": "6c8a3421379a8f7aa41e452175355c4b",
    };
    var dio = Dio();
    Response response = await dio.request(url, queryParameters: param);
    DataModel data = DataModel.fromJson(response.data);
    List<AddressNode> result = [];
    if (data.info == "OK") {
      DistrictsModel model = data.districts!.first;
      for (int i = 0; i < model.districts!.length; i++) {
        result.add(AddressNode(
            name: model.districts![i].name, code: model.districts![i].adcode));
      }
    }
    return result;
  }
}
