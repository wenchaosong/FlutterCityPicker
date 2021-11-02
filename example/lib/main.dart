import 'dart:async';

import 'package:city_picker_example/http/http_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_city_picker/city_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import 'provider/theme_provider.dart';
import 'view/item_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          Color color = themeProvider.themeColor;
          return MaterialApp(
            title: 'CityPickerExample',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: color,
              dialogBackgroundColor: Colors.white,
            ),
            home: HomeWidget(),
          );
        },
      ),
    );
  }
}

class HomeWidget extends StatefulWidget {
  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> implements CityPickerListener {
  String _address = "请选择地区";
  Color _themeColor = Colors.blue;
  Color _backgroundColor = Colors.white;
  double _height = 400.0;
  double _opacity = 0.5;
  double _corner = 20;
  bool _dismissible = true;
  bool _showTabIndicator = true;

  @override
  void initState() {
    super.initState();
  }

  void show() {
    CityPicker.show(
      context: context,
      theme: ThemeData(
        dialogBackgroundColor: _backgroundColor,
      ),
      duration: 200,
      opacity: _opacity,
      dismissible: _dismissible,
      height: _height,
      titleHeight: 50,
      corner: _corner,
      paddingLeft: 15,
      titleWidget: Container(
        padding: EdgeInsets.only(left: 15),
        child: Text(
          '请选择地址',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      closeWidget: Icon(Icons.close),
      tabHeight: 40,
      showTabIndicator: _showTabIndicator,
      tabIndicatorColor: Theme.of(context).primaryColor,
      tabIndicatorHeight: 2,
      labelTextSize: 15,
      selectedLabelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.black54,
      itemHeadHeight: 30,
      itemHeadLineColor: Colors.black,
      itemHeadLineHeight: 0.1,
      itemHeadTextStyle: TextStyle(fontSize: 15, color: Colors.black),
      itemHeight: 40,
      indexBarWidth: 28,
      indexBarItemHeight: 20,
      indexBarBackgroundColor: Colors.black12,
      indexBarTextStyle: TextStyle(fontSize: 14, color: Colors.black54),
      itemSelectedIconWidget:
          Icon(Icons.done, color: Theme.of(context).primaryColor, size: 16),
      itemSelectedTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor),
      itemUnSelectedTextStyle: TextStyle(fontSize: 14, color: Colors.black54),
      cityPickerListener: this,
    );
  }

  Widget _buildTheme() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('选择颜色'),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: _themeColor,
                  onColorChanged: (color) {
                    setState(() {
                      _themeColor = color;
                    });
                    Provider.of<ThemeProvider>(context, listen: false)
                        .setTheme(color);
                  },
                ),
              ),
            );
          },
        );
      },
      child: Container(
        color: _themeColor,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(80, 10, 80, 10),
      ),
    );
  }

  Widget _buildColor() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('选择颜色'),
              content: SingleChildScrollView(
                child: BlockPicker(
                  pickerColor: _backgroundColor,
                  onColorChanged: (color) {
                    setState(() {
                      _backgroundColor = color;
                    });
                  },
                ),
              ),
            );
          },
        );
      },
      child: Container(
        color: _backgroundColor,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(80, 10, 80, 10),
      ),
    );
  }

  Widget _buildOpacity() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Slider(
            value: _opacity,
            min: 0.01,
            max: 1.0,
            divisions: 100,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey,
            onChanged: (double) {
              setState(() {
                _opacity = double.toDouble();
              });
            },
          ),
        ),
        Text("${_opacity.toStringAsFixed(2)}")
      ],
    );
  }

  Widget _buildDismissible() {
    return Container(
        alignment: Alignment.centerRight,
        child: Switch(
          value: _dismissible,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (bool val) {
            setState(() {
              _dismissible = !_dismissible;
            });
          },
        ));
  }

  Widget _buildHeight() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Slider(
            value: _height,
            min: 200,
            max: 500,
            divisions: 100,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey,
            onChanged: (double) {
              setState(() {
                _height = double.toDouble();
              });
            },
          ),
        ),
        Text("${_height.toStringAsFixed(2)}")
      ],
    );
  }

  Widget _buildCorner() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Slider(
            value: _corner,
            min: 0.0,
            max: 30,
            divisions: 100,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey,
            onChanged: (double) {
              setState(() {
                _corner = double.toDouble();
              });
            },
          ),
        ),
        Text("${_corner.toStringAsFixed(2)}")
      ],
    );
  }

  Widget _buildIndicator() {
    return Container(
        alignment: Alignment.centerRight,
        child: Switch(
          value: _showTabIndicator,
          activeColor: Theme.of(context).primaryColor,
          onChanged: (bool val) {
            setState(() {
              _showTabIndicator = !_showTabIndicator;
            });
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('城市选择器'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ItemTextWidget(
              title: '选择城市',
              subWidget: InkWell(
                onTap: () => show(),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Text(_address),
                ),
              ),
            ),
            ItemTextWidget(title: '主题颜色', subWidget: _buildTheme()),
            ItemTextWidget(title: '透明度', subWidget: _buildOpacity()),
            ItemTextWidget(title: '外部点击消失', subWidget: _buildDismissible()),
            ItemTextWidget(title: '弹窗背景颜色', subWidget: _buildColor()),
            ItemTextWidget(title: '弹窗高度', subWidget: _buildHeight()),
            ItemTextWidget(title: '顶部圆角', subWidget: _buildCorner()),
            ItemTextWidget(title: '显示 Indicator', subWidget: _buildIndicator()),
          ],
        ),
      ),
    );
  }

  @override
  Future<List<City>> loadProvinceData() async {
    print("loadProvinceData");
    return HttpUtils.getCityData("");
  }

  @override
  Future<List<City>> onProvinceSelected(
      String? provinceCode, String? provinceName) async {
    print("onProvinceSelected --- provinceName: $provinceName");
    return HttpUtils.getCityData(provinceName!);
  }

  @override
  Future<List<City>> onCitySelected(String? cityCode, String? cityName) async {
    print("onCitySelected --- cityName: $cityName");
    return HttpUtils.getCityData(cityName!);
  }

  @override
  void onFinish(String? provinceCode, String? provinceName, String? cityCode,
      String? cityName, String? districtCode, String? districtName) {
    print("onFinish");
    setState(() {
      _address = provinceName! + " " + cityName! + " " + districtName!;
    });
  }
}
