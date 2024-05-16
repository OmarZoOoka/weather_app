import 'package:weather_ui/models/weather_model.dart';

abstract class WeatherStates {}

class InitialState extends WeatherStates {}

class WeatherSucessState extends WeatherStates {
  final WeatherModel weatherModel;

  WeatherSucessState(this.weatherModel);
}

class WeatherFailureState extends WeatherStates {}
