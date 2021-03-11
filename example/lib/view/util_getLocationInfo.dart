import 'package:flutter/material.dart';
import 'package:city_picker/city_picker.dart';

import '../src/attr_item_container.dart';

class UtilGetLocationInfo extends StatefulWidget {
  _Demo createState() => _Demo();
}

class _Demo extends State<UtilGetLocationInfo> {
  CityPickerUtil cityPickerUtils = CityPicker.utils();
  Result result = new Result();
  String code = '110101';

  buttonHandle() {
    this.setState(() {
      result = cityPickerUtils.getAreaResultByCode(code);
    });
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("解析locationCode"),
    ),
    body: Column(
      children: <Widget>[
        AttrItemContainer(
          title: '标题1111',
          editor: TextField(
            keyboardType: TextInputType.number,
            autofocus: false,
            controller: TextEditingController(text: code),
            onChanged: (String value) {
              this.setState(() {
                code = value;
              });
            },
          ),
        ),
        Text("地址信息为: ${result.toString()}"),
        RaisedButton(child: Text('touch me 解析 $code '),onPressed: this.buttonHandle)
      ],
    ));
  }
}
