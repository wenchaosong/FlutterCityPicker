import 'dart:async';

import 'package:city_picker_example/http/http_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_city_picker/city_picker.dart';
import 'package:flutter_city_picker/model/address.dart';
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

class HomeWidgetState extends State<HomeWidget>
    with SingleTickerProviderStateMixin
    implements CityPickerListener {
  AnimationController? _animationController;
  String _address = "请选择地区";
  Color _themeColor = Colors.blue;
  Color _backgroundColor = Colors.white;
  double _height = 500.0;
  double _opacity = 0.5;
  double _corner = 20;
  bool _dismissible = true;
  bool _showTabIndicator = true;
  int _streetNum = 3;
  List<AddressNode> _selectedAddress = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
  }

  void show() {
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
      selectText: "请选择",
      closeWidget: Icon(Icons.close),
      tabHeight: 40,
      showTabIndicator: _showTabIndicator,
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
      initialAddress: _selectedAddress,
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

  Widget _buildStreet() {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Slider(
            value: _streetNum.toDouble(),
            min: 1,
            max: 4,
            divisions: 3,
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Colors.grey,
            onChanged: (double) {
              setState(() {
                _streetNum = double.toInt();
              });
            },
          ),
        ),
        Text("${_streetNum.toStringAsFixed(0)}")
      ],
    );
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
            ItemTextWidget(title: '城市层级', subWidget: _buildStreet()),
          ],
        ),
      ),
    );
  }

  @override
  Future<List<AddressNode>> onDataLoad(
      int index, String code, String name) async {
    print("onDataLoad ---> $index $name");
    await Future.delayed(Duration(milliseconds: 200));

    if (index == 0) {
      return HttpUtils.getCityData("");
    } else {
      if (_streetNum == 1) {
        return Future.value([]);
      } else if (_streetNum == 2) {
        if (index == 2) {
          return Future.value([]);
        }
        return HttpUtils.getCityData(name);
      } else if (_streetNum == 3) {
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
    print("onFinish");
    if (data.isNotEmpty) {
      _address = "";
      if (data.length > 0) {
        _address += (data[0].name! + " ");
      }
      if (data.length > 1) {
        _address += (data[1].name! + " ");
      }
      if (data.length > 2) {
        _address += (data[2].name! + " ");
      }
      if (data.length > 3) {
        _address += (data[3].name! + " ");
      }
      _selectedAddress = data;
    }
    setState(() {});
  }
}
