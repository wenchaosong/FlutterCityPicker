### 地址选择器

[![Pub Package](https://img.shields.io/pub/v/flutter_city_picker.svg?color=blue)](https://pub.dartlang.org/packages/flutter_city_picker)
[![](https://img.shields.io/github/last-commit/wenchaosong/FlutterCityPicker?color=yellow)](https://github.com/wenchaosong/flutter_city_picker)

在原项目[city_pickers](https://github.com/hanxu317317/city_pickers) 基础上修改了升级 2.0 出现的问题

#### 导入方式

```
dependencies:
    flutter_city_picker: ^0.0.2
```

#### 使用方法

```
...
// type 1
Result result = await CityPicker.showCityPicker(
  context: context,
);
// type 2
Result result2 = await CityPicker.showFullPageCityPicker(
  context: context,
);
// type 3
Result result2 = await CityPicker.showCitiesSelector(
  context: context,
);
```

## CityPicker 静态方法

|Name|Type|Desc|
|:---------------|:--------|:----------|
|showCityPicker|Function|呼出弹出层,显示多级选择器 |
|showFullPageCityPicker|Function|呼出一层界面, 显示多级选择器|
|showCitiesSelector |Function|呼出一层, 显示支持字母定位城市选择器|
|utils|Function|获取utils接口的钩子|


### showCityPicker 参数说明

|Name|Type|Default|Desc|
|:---------------|:--------|:----|:----------|
|context|BuildContext|上下文对象|
|theme|ThemeData|Theme.of(context)| 主题, 可以自定义|
|locationCode|String|110000| 初始化地址信息, 可以是省, 市, 区的地区码|
|height|double|300| 弹出层的高度, 过高或者过低会导致容器报错|
|showType|ShowType|ShowType.pca| 三级联动, 显示类型|
|barrierOpacity|double|0.5|弹出层的背景透明度, 应该是大于0, 小于1|
|barrierDismissible|bool|true| 是否可以通过点击弹出层背景, 关闭弹出层|
|cancelWidget|Widget|用户自定义取消按钮|
|confirmWidget| Widget | 用户自定义确认按钮 |
|itemExtent|double|目标框高度|
|selectionOverlay|Widget|选中的悬浮层控件|
|itemBuilder|Widget|item生成器, function(String value, List<String> lists, item){}, 当itemBuilder不为空的时候. 必须设置itemExtent|
|citiesData|Map|城市数据|选择器的城市与区的数据源|
|provincesData|Map|省份数据|选择器的省份数据源|


### showFullPageCityPicker 参数说明

|Name|Type|Default|Desc|
|:---------------|:--------|:----|:----------|
|context|BuildContext|null|上下文对象|
|theme|ThemeData|Theme.of(context)| 主题, 可以自定义|
|locationCode|String|110000| 初始化地址信息, 可以是省, 市, 区的地区码|
|showType|ShowType|ShowType.pca| 三级联动, 显示类型|
|citiesData|Map|城市数据|选择器的城市与区的数据源|
|provincesData|Map|省份数据|选择器的省份数据源|


### showCitiesSelector 参数说明

|Name|Type|Default|Desc|
|:---------------|:--------|:----|:----------|
|context|BuildContext|null|上下文对象|
|theme|ThemeData|Theme.of(context)| 主题, 可以自定义|
|locationCode|String|110000| 初始化地址信息, 可以是省, 市, 区的地区码|
|title|String|城市选择器|弹出层界面标题|
|citiesData|Map|城市数据|选择器的城市与区的数据源|
|provincesData|Map|省份数据|选择器的省份数据源|
|hotCities|List\<HotCity\>|null|热门城市|
|sideBarStyle|BaseStyle|初始默认样式| 右侧字母索引集样式|
|cityItemStyle|BaseStyle|初始默认样式| 城市选项样式|
|topStickStyle|BaseStyle|初始默认样式| 顶部索引吸顶样式|


### utils 说明
utils 是用来封装常用的一些方法, 方便使用者能更好的使用该插件. 使用者通过以下方式声明实例, 可以**获取所有的工具类方法**

```
// 声明实例
CityPickerUtil cityPickerUtils = CityPicker.utils();
```

#### Result getAreaResultByCode(String code)

