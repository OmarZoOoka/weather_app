class WeatherModel {
  final String cityName;
  final String date;
  final String? image;
  final double minTemp;
  final double maxTemp;
  final double temp;
  final String condition;

  WeatherModel(
      {required this.cityName,
      required this.date,
      this.image,
      required this.minTemp,
      required this.maxTemp,
      required this.temp,
      required this.condition});

  factory WeatherModel.fromJson(json) {
    var jsonData = json['forecast']['forecastday'][0]['day'];
    return WeatherModel(
      cityName: json['location']['name'],
      date: json['current']['last_updated'],
      minTemp: jsonData['mintemp_c'],
      maxTemp: jsonData['maxtemp_c'],
      temp: jsonData['avgtemp_c'],
      condition: jsonData['condition']['text'],
      image: jsonData['condition']['icon']
    );
  }
}
