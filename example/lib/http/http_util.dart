import 'package:dio/dio.dart';
import 'package:flutter_city_picker/model/address.dart';
import 'package:lpinyin/lpinyin.dart';

import 'model.dart';

class HttpUtils {
  static Future<List<AddressNode>> getCityData(String keywords) async {
    var url = 'Your key or other api';
    var param = {
      "keywords": keywords,
      "subdistrict": 1,
      "key": "Your key or other api",
    };
    var dio = Dio();
    Response response = await dio.request(url, queryParameters: param);
    DataModel data = DataModel.fromJson(response.data);
    List<AddressNode> result = [];
    if (data.info == "OK") {
      DistrictsModel model = data.districts!.first;
      for (int i = 0; i < model.districts!.length; i++) {
        String letter =
            PinyinHelper.getFirstWordPinyin(model.districts![i].name!)
                .substring(0, 1)
                .toUpperCase();
        result.add(
          AddressNode(
            name: model.districts![i].name,
            code: model.districts![i].adcode,
            letter: letter,
          ),
        );
      }
    }
    return result;
  }
}
