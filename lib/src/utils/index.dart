import 'location.dart';
import '../../modal/result.dart';

class CityPickerUtil {
  Map<String, dynamic> citiesData;
  Map<String, dynamic> provincesData;

  CityPickerUtil({this.citiesData, this.provincesData})
      : assert(citiesData != null),
        assert(provincesData != null);

  Result getAreaResultByCode(String code) {
    Location location =
        new Location(citiesData: citiesData, provincesData: provincesData);
    return location.initLocation(code);
  }
}
