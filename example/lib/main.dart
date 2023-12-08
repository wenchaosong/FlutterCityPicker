import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_city_picker/city_picker.dart';
import 'package:flutter_city_picker/model/address.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import 'http/http_util.dart';
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
              bottomSheetTheme: BottomSheetThemeData(
                  constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              )),
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

class HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin
    implements CityPickerListener {
  AnimationController? _animationController;
  String _addressProvince = "请选择省";
  String _addressCity = "请选择市";
  String _addressArea = "请选择地区";
  String _addressStreet = "请选择街道";
  Color _themeColor = Colors.blue;
  Color _backgroundColor = Colors.white;
  double _height = 500.0;
  double _opacity = 0.5;
  double _corner = 20;
  bool _dismissible = true;
  bool _showTabIndicator = true;
  List<AddressNode> _selectProvince = [];
  List<AddressNode> _selectCity = [];
  List<AddressNode> _selectArea = [];
  List<AddressNode> _selectStreet = [];

  /// 0: 省
  /// 1: 市
  /// 2: 地区
  /// 3: 街道
  int _currentType = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  void show(List<AddressNode> initData) {
    CityPicker.show(
      context: context,
      animController: _animationController,
      opacity: _opacity,
      dismissible: _dismissible,
      height: _height,
      titleHeight: 50,
      corner: _corner,
      backgroundColor: _backgroundColor,
      paddingLeft: 15,
      titleWidget: Text(
        '请选择地址',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      selectText: "请选择",
      closeWidget: Icon(Icons.close),
      tabHeight: 40,
      showTabIndicator: _showTabIndicator,
      tabPadding: 15,
      tabIndicatorColor: Theme.of(context).primaryColor,
      tabIndicatorHeight: 2,
      labelTextSize: 15,
      selectedLabelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.black54,
      itemHeadHeight: 30,
      itemHeadBackgroundColor: _backgroundColor,
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
      initialAddress: initData,
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
            max: 600,
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
              title: '省',
              subWidget: InkWell(
                onTap: () {
                  _currentType = 0;
                  setState(() {});
                  show(_selectProvince);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Text(_addressProvince),
                ),
              ),
            ),
            ItemTextWidget(
              title: '市',
              subWidget: InkWell(
                onTap: () {
                  _currentType = 1;
                  setState(() {});
                  show(_selectCity);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Text(_addressCity),
                ),
              ),
            ),
            ItemTextWidget(
              title: '地区',
              subWidget: InkWell(
                onTap: () {
                  _currentType = 2;
                  setState(() {});
                  show(_selectArea);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Text(_addressArea),
                ),
              ),
            ),
            ItemTextWidget(
              title: '街道',
              subWidget: InkWell(
                onTap: () {
                  _currentType = 3;
                  setState(() {});
                  show(_selectStreet);
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Text(_addressStreet),
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
  Future<List<AddressNode>> onDataLoad(
      int index, String code, String name) async {
    debugPrint("onDataLoad ---> $index $name");

    if (index == 0) {
      await Future.delayed(Duration(milliseconds: 200));
      return HttpUtils.getCityData("");
    } else {
      if (_currentType == 0) {
        return Future.value([]);
      } else if (_currentType == 1) {
        if (index == 2) {
          return Future.value([]);
        }
        return HttpUtils.getCityData(name);
      } else if (_currentType == 2) {
        if (index == 3) {
          return Future.value([]);
        }
        return HttpUtils.getCityData(name);
      } else {
        return HttpUtils.getCityData(name);
      }
    }
  }

  @override
  void onFinish(List<AddressNode> data) {
    debugPrint("onFinish");
    String add = "";
    for (var node in data) {
      add += "${node.name} ";
    }
    if (_currentType == 0) {
      _addressProvince = add;
      _selectProvince = data;
    } else if (_currentType == 1) {
      _addressCity = add;
      _selectCity = data;
    } else if (_currentType == 2) {
      _addressArea = add;
      _selectArea = data;
    } else {
      _addressStreet = add;
      _selectStreet = data;
    }

    setState(() {});
  }
}
