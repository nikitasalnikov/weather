import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app/domain/api/api.dart';
import 'package:weather_app/domain/hive/favorite_history.dart';
import 'package:weather_app/domain/hive/hive_boxes.dart';
import 'package:weather_app/domain/json_convertors/coord.dart';
import 'package:weather_app/domain/json_convertors/weather_data.dart';
import 'package:weather_app/ui/resources/app_bg.dart';
import 'package:weather_app/ui/ui_theme/app_colors.dart';

class WeatherProvider extends ChangeNotifier {
  //хранение координат
  Coord? _coords;
  Coord? get coords => _coords;

  // Хранение данных о погоде
  WeatherData? weatherData;

  //хранение текущих данныхо погоде

  Current? current;

  //контроллер ввода
  TextEditingController searchController = TextEditingController();

  // Главная функция которую запустим в FutureBuilder

  Future<WeatherData?> setUp({String? cityName}) async {
    final pref = await SharedPreferences.getInstance();
    cityName = pref.getString('city_name');
    _coords = await Api.getCoords(cityName: cityName ?? 'Ташкент');
    weatherData = await Api.getWeather(coords);
    current = weatherData?.current;
    setSevenDays();

    return weatherData;
  }
  //*************************************/

  /* установка текущего города */

  void setCurrCity(BuildContext context, {String? cityName}) async {
    if (searchController.text != null && searchController.text != '') {
      cityName = searchController.text;
      final pref = await SharedPreferences.getInstance();
      await pref.setString('city_name', cityName);
      await setUp(cityName: pref.getString('city_name'))
          .then(
            (value) => Navigator.pop(context),
          )
          .then(
            (value) => searchController.clear(),
          );
          notifyListeners();
    }
  }
  //*************************************/

  // Получение текущего времени
  String? currentTime;

  String setCurrentTime() {
    final getTime = (current?.dt ?? 0) + (weatherData?.timezoneOffset ?? 0); //
    final setTime = DateTime.fromMillisecondsSinceEpoch(getTime * 1000);
    currentTime = DateFormat('HH:mm a').format(setTime);

    return currentTime ?? 'Error';
  }
  //*************************************/

  // Получение текущего статуса погоды
  String currentStatus = '';

  String setCurrentStatus() {
    currentStatus = current?.weather?[0].description ?? 'Ошибка';

    return capitalize(currentStatus);
  }
  //*************************************/

  //получение иконки по текущей погоде
  String currentIconUrl = 'https://api.openweathermap.org/img/w/';

  String setIcon() {
    return '$currentIconUrl${current?.weather?[0].icon}.png';
  }
  //*************************************/

  //https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2

  /* изменение заднего фона */
  String? currentBg;

  String setBg() {
    int id = current?.weather?[0].id ?? -1;

    if (id == -1 || current?.sunset == null || current?.dt == null) {
      currentBg = AppBg.shinyDay;
    }

    try {
      if (current!.sunset! < current!.dt!) {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyNight;
          AppColors.sevenDayBoxColor = const Color.fromRGBO(35, 35, 35, 0.5);
          AppColors.blackColor = const Color(0xFFFFFFFF);
          AppColors.darkBlueColor = const Color(0xFFFFFFFF);
          AppColors.iconsColor = const Color(0xFFFFFFFF);
        } else if (id >= 600 && id <= 622) {
          currentBg = AppBg.snowNight;
          AppColors.sevenDayBoxColor = const Color.fromRGBO(12, 23, 27, 0.5);
        } else if (id >= 701 && id <= 781) {
          currentBg = AppBg.fogNight;
          AppColors.sevenDayBoxColor = const Color.fromRGBO(35, 35, 35, 0.5);
          AppColors.darkBlueColor = const Color(0xFFFFFFFF);
          AppColors.iconsColor = const Color(0xFFFFFFFF);
          AppColors.blackColor = const Color(0xFFFFFFFF);
          AppColors.iconsColor = const Color(0xFFFFFFFF);
        } else if (id == 800) {
          currentBg = AppBg.shinyNight;
          AppColors.sevenDayBoxColor = const Color.fromRGBO(47, 97, 148, 0.5);
        } else if (id >= 801 && id <= 804) {
          currentBg = AppBg.cloudyNight;
          AppColors.sevenDayBoxColor = const Color.fromRGBO(12, 23, 27, 0.5);
          AppColors.darkBlueColor = const Color(0xFFFFFFFF);
        }
      } else {
        if (id >= 200 && id <= 531) {
          currentBg = AppBg.rainyDay;
          AppColors.sevenDayBoxColor = const Color.fromRGBO(106, 141, 135, 0.5);
        } else if (id >= 600 && id <= 622) {
          currentBg = AppBg.snowDay;
          AppColors.sevenDayBoxColor = const Color.fromRGBO(109, 160, 192, 0.5);
        } else if (id >= 701 && id <= 781) {
          currentBg = AppBg.fogDay;
          AppColors.sevenDayBoxColor = const Color.fromRGBO(142, 141, 141, 0.5);
        } else if (id == 800) {
          currentBg = AppBg.shinyDay;
          AppColors.sevenDayBoxColor = const Color.fromRGBO(142, 141, 141, 0.5);
        } else if (id >= 801 && id <= 804) {
          currentBg = AppBg.cloudyDay;
          AppColors.sevenDayBoxColor = const Color.fromRGBO(140, 155, 170, 0.5);
        }
      }
    } catch (e) {
      return AppBg.shinyDay;
    }

    return currentBg ?? AppBg.shinyDay;
  }

  //*************************************/

  /* получение текущей погоды */
  int kelvin = -273;

  int currentTemp = 0;

  int setCurrentTemp() {
    currentTemp = ((current?.temp ?? -kelvin) + kelvin).round();
    return currentTemp;
  }
  //*************************************/

  /**max temp */

  int maxTemp = 0;

  String setMaxTemp() {
    maxTemp = ((weatherData?.daily?[0].temp?.max ?? -kelvin) + kelvin).round();
    return maxTemp.toString();
  }
  //*************************************/

  /*max temp */

  int minTemp = 0;

  String setMinTemp() {
    minTemp = ((weatherData?.daily?[0].temp?.min ?? -kelvin) + kelvin).round();
    return minTemp.toString();
  }

  //*************************************/
  String capitalize(String str) => str[0].toUpperCase() + str.substring(1);

  /*дни недели*/

  final List<String> date = [];

  List<Daily> daily = [];

  void setSevenDays() {
    daily = weatherData!.daily!;

    for (var i = 0; i < daily.length; i++) {
      if (i == 0 && daily.isNotEmpty) {
        date.clear();
      }

      if (i == 0) {
        date.add('Сегодня');
      } else {
        var timeNum = daily[i].dt! * 1000;
        var itemDate = DateTime.fromMillisecondsSinceEpoch(
            timeNum); //2022-01-01 10:00:00.000Z
        date.add(
          capitalize(
            DateFormat('EEEE', 'ru').format(itemDate),
          ),
        ); //weekday
      }
    }
  }

  /*получение иконки для каждого дня недели */

  final String _iconUrlPath = 'http://openweathermap.org/img/wn/';

  String setDaylyIcons(int index) {
    final String getIcon = '${weatherData?.daily?[index].weather?[0].icon}';
    final String setIcon = '$_iconUrlPath$getIcon.png';
    return setIcon;
  }

  /*получение дневной температуры */
  int dailyTemp = 0;
  int setDailyTemp(int index) {
    dailyTemp =
        ((weatherData?.daily?[index].temp?.morn ?? -kelvin) + kelvin).round();
    return dailyTemp;
  }

  /*получение ночной температуры */
  int nigthTemp = 0;
  int setNightTemp(int index) {
    nigthTemp =
        ((weatherData?.daily?[index].temp?.night ?? -kelvin) + kelvin).round();
    return nigthTemp;
  }

  /*Добавление в массив данных о погодных условиях */

  List<dynamic> weatherValues = [];

  dynamic setValues(int index) {
    weatherValues.add(current?.windSpeed ?? 0);
    weatherValues
        .add(((current?.feelsLike ?? -kelvin) + kelvin).roundToDouble());
    weatherValues.add((current?.humidity ?? 0) / 1);
    weatherValues.add((current?.visibility ?? 0) / 1000);
    return weatherValues[index];
  }

  /*Время восхода */

  String sunRise = '';

  String setCurrentSunRise() {
    final getSunTime =
        (current?.sunrise ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setSunRise = DateTime.fromMillisecondsSinceEpoch(getSunTime * 1000);
    sunRise = DateFormat('HH:mm a').format(setSunRise);
    return sunRise;
  }

  /*Время заката */

  String sunSet = '';

  String setCurrentSunSet() {
    final getSunTime =
        (current?.sunset ?? 0) + (weatherData?.timezoneOffset ?? 0);
    final setSunSet = DateTime.fromMillisecondsSinceEpoch(getSunTime * 1000);
    sunSet = DateFormat('HH:mm a').format(setSunSet);
    return sunSet;
  }

  /* добавление в избранное*/
  Future<void> setFavotite(BuildContext context, {String? cityName}) async {
    var box = Hive.box<FavouriteHistory>(HiveBoxes.favoriteBox);

    box
        .add(
          FavouriteHistory(
            weatherData?.timezone ?? 'Error',
            currentBg ?? AppBg.shinyDay,
            AppColors.darkBlueColor.value,
          ),
        )
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Городо $cityName добавлен в избранное'),
            ),
          ),
        );
  }

  //****************************************/

  /*Удаление из избранных */

  Future<void> deleteFav(int index) async {
    var box = Hive.box<FavouriteHistory>(HiveBoxes.favoriteBox);
    box.deleteAt(index);
  }
  //****************************************/

}
