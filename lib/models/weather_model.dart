// here we will create model to add those things we want to include
class WeatherModel {
  final String cityName;
  final double temperature;
  final String mainCondition;

  WeatherModel(
      {required this.cityName,
      required this.temperature,
      required this.mainCondition});
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
        cityName: json['name'],
        temperature: json['main']['temp'].toDouble(),
        mainCondition: json['weather'][0]['main']);
  }
}
