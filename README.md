### 地址选择器

[![](https://img.shields.io/pub/v/flutter_city_picker.svg?color=blue)](https://pub.dev/packages/flutter_city_picker)
[![](https://img.shields.io/github/last-commit/wenchaosong/FlutterCityPicker?color=yellow)](https://github.com/wenchaosong/FlutterCityPicker)

由于地址选择的数据来源会更新，为了统一，在后台配置一份城市数据，前端获取，这是最好的处理方式，否则各个平台都配置一份数据，
维护会很麻烦，而且有可能每个平台城市的数据结构都不一样。本库就是由此而来，数据从后台实时获取，只要解析成固定的数据结构就可以

![效果示例](https://img.alicdn.com/imgextra/i1/2315514881/O1CN01U4ZUac1lvXuajSzCz_!!2315514881.gif)

#### 导入方式

```
dependencies:
    flutter_city_picker: ^1.0.2
```

#### 使用方法

1. 简单使用
```
    CityPicker.show(context: context, cityPickerListener: this);
```

2. 多配置的使用
```
    CityPicker.show(
          context: context,
          // 主题颜色
          theme: ThemeData(
            // 弹窗的背景颜色
            dialogBackgroundColor: Colors.white,
          ),
          // 底部弹出框动画时间
          duration: 200,
          // 背景透明度
          opacity: 0.5,
          // 点击外部是否消失
          dismissible: true,
          // 高度
          height: 400,
          // 标题高度
          titleHeight: 50,
          // 顶部圆角
          corner: 20,
          // 距离左边的间距
          paddingLeft: 15,
          // 标题组件
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
          // 关闭图标组件
          closeWidget: Icon(Icons.close),
          // tab 高度
          tabHeight: 40,
          // 是否显示指示器
          showTabIndicator: _showTabIndicator,
          // tab 指示器颜色
          tabIndicatorColor: Theme.of(context).primaryColor,
          // tab 指示器高度
          tabIndicatorHeight: 2,
          // tab 字体大小
          labelTextSize: 15,
          // tab 选中的字体颜色
          selectedLabelColor: Theme.of(context).primaryColor,
          // tab 未选中的字体颜色
          unselectedLabelColor: Colors.black54,
          // 列表 item 头部高度
          itemHeadHeight: 30,
          // 列表 item 头部背景颜色
          itemHeadBackgroundColor: Colors.white,
          // 列表 item 头部分割线颜色
          itemHeadLineColor: Colors.black,
          // 列表 item 头部分割线高度
          itemHeadLineHeight: 0.1,
          // 列表 item 头部文字样式
          itemHeadTextStyle: TextStyle(fontSize: 15, color: Colors.black),
          // 列表 item 高度
          itemHeight: 40,
          // 索引组件宽度
          indexBarWidth: 28,
          // 索引组件 item 高度
          indexBarItemHeight: 20,
          // 索引组件背景颜色
          indexBarBackgroundColor: Colors.black12,
          // 索引组件文字样式
          indexBarTextStyle: TextStyle(fontSize: 14, color: Colors.black54),
          // 列表选中的图标组件
          itemSelectedIconWidget:
              Icon(Icons.done, color: Theme.of(context).primaryColor, size: 16),
          // 列表选中的文字样式
          itemSelectedTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor),
          // 列表未选中的文字样式
          itemUnSelectedTextStyle: TextStyle(fontSize: 14, color: Colors.black54),
          cityPickerListener: this,
        );
```

3. 监听事件
```
    <你的组件> implements CityPickerListener

    @override
    Future<List<City>> loadProvinceData() async {
      // 发起网络请求，获取省级数据
      return 返回省级数据;
    }

    @override
    Future<List<City>> onProvinceSelected(String provinceCode, String provinceName) async {
      // 点击省份后的回调，根据城市代码或名称去请求市级数据
      return 返回市级数据;
    }

    @override
    Future<List<City>> onCitySelected(String cityCode, String cityName) async {
      // 点击城市后的回调，根据城市代码或名称去请求区级数据
      return 返回区级数据;
    }

    @override
    void onFinish(String provinceCode, String provinceName, String cityCode,
        String cityName, String districtCode, String districtName) {
      // 最终回调，返回省市区的代码和名称
      setState(() {
        _address = provinceName + " " + cityName + " " + districtName;
      });
    }
```

#### 待优化

无

欢迎提 PR 或者 ISSUE
