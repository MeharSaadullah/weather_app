import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_services.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // api key
  final _weatherservice = WeatherServices('0086b44ec77fd070bbcaa4aaec0ff149');
  WeatherModel? _weather;

  // fetch weather
  _fetchWeather() async {
    // get the current city

    String cityName = await _weatherservice.getCurrentCity();
    // get weather for city
    try {
      final weather = await _weatherservice.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    // any error
    catch (e) {
      print(e);
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; // set as default
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/rain.json';
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    // fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // city name
            Text(
              _weather?.cityName ?? "loading city...",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            //animations
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            //Lottie.asset('assets/thunder.json'),
            // temperature
            Text('${_weather?.temperature.round()}°C',
                style: TextStyle(fontSize: 20, color: Colors.white)),

            //weather condition
            Text(_weather?.mainCondition ?? "",
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
