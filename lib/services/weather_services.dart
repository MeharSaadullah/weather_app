import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  //'https://api.openweathermap.org/data/3.0/onecall';
  //'https://home.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherServices(this.apiKey);
  Future<WeatherModel> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&unit=metric'));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    // convert the location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    // extract the city name from the first placemak
    String? city = placemarks[0].locality;
    print('City: $city');

    return city ?? "";
  }
}
