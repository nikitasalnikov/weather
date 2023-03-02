import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/domain/provider/weather_provider.dart';
import 'package:weather_app/ui/ui_theme/app_colors.dart';
import 'package:weather_app/ui/ui_theme/app_style.dart';

class WeatherInfoItems extends StatelessWidget {
  const WeatherInfoItems({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<WeatherProvider>();
    return GridView.builder(
      padding: const EdgeInsets.all(0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 20,

        crossAxisSpacing: 20,
        crossAxisCount: 2,
      ),
      itemCount: 4,
      itemBuilder: (context, i) {
        return SizedBox(
          width: 180,
          height: 180,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: AppColors.sevenDayBoxColor,
            child: Center(
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
                leading: SvgPicture.asset(
                  WeatherInfoIcons.weatherInfoIcons[i],
                  color: AppColors.iconsColor,
                ),
                title: Text(
                  '${model.setValues(i)} ${WeatherInfoUnits.weatherInfoUnits[i]}',
                  style: AppStyle.fontStyle.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                    fontSize: 14,
                  ),
                ),
                subtitle: Text(
                  WeatherInfoDescription.weatherInfoDescription[i],
                  style: AppStyle.fontStyle.copyWith(
                    fontSize: 10,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class WeatherInfoIcons {
  static List<String> weatherInfoIcons = [
    'assets/icons/wind_speed.svg',
    'assets/icons/feels_like.svg',
    'assets/icons/raindrops.svg',
    'assets/icons/visibility.svg',
  ];
}

class WeatherInfoDescription {
  static List<String> weatherInfoDescription = [
    'Скорость ветра',
    'Ощущается',
    'Влажность',
    'Видимость',
  ];
}

class WeatherInfoUnits {
  static List<String> weatherInfoUnits = [
    ' км/ч',
    ' °',
    ' %',
    'км',
  ];
}
