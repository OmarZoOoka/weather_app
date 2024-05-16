import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_ui/cubit/weather_state_cubit.dart';
import 'package:weather_ui/models/weather_model.dart';
import 'package:weather_ui/services/weather_service.dart';

class GetWeatherCubit extends Cubit<WeatherStates> {
  GetWeatherCubit() : super(InitialState());
     WeatherModel? weatherModel;
  getWeather({required String cityName}) async {
    
    try {
      weatherModel =
          await WeatherService(Dio()).getCurrentWeather(cityName: cityName);
      emit(WeatherSucessState(weatherModel!));
    } catch (e) {
      log(e.toString());
      emit(WeatherFailureState());
    }
  }
}
