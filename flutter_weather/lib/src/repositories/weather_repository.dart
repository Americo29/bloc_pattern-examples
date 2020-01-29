import 'package:flutter_weather/src/models/models.dart';
import 'package:meta/meta.dart';
import 'package:flutter_weather/src/repositories/repositories.dart';




class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({@required this.weatherApiClient})
      : assert(weatherApiClient != null);

  Future<Weather> getWeather(String city) async {
    final int locationId = await weatherApiClient.getLocationId(city);
    return weatherApiClient.fetchWeather(locationId);
  }

}