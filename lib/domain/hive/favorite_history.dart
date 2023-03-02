import 'package:hive/hive.dart';

part 'favorite_history.g.dart';


// flutter pub add hive_generator --dev
// flutter pub add build_runner --dev

//flutter packages pub run build_runner build

@HiveType(typeId: 0)
class FavouriteHistory {
  
  @HiveField(0)
  String cityName;
  
  @HiveField(1)
  String bg;
  
  @HiveField(2)
  int color;
  
  
  
  FavouriteHistory(this.cityName, this.bg, this.color);
}