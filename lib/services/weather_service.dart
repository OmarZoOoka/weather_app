import 'package:dio/dio.dart';
import 'package:weather_ui/models/weather_model.dart';

class WeatherService {
  final Dio dio;
  final String baseUrl = 'https://api.weatherapi.com/v1';
  final String apiKey = 'b0d47712d22c4f029e8122236231504';
  WeatherService(this.dio);

  Future<WeatherModel> getCurrentWeather({required String cityName}) async {
    try {
      Response response = await dio.get(
        '$baseUrl/forecast.json?key=$apiKey&q=$cityName',
      );

      WeatherModel weatherModel = WeatherModel.fromJson(response.data);
      return weatherModel;
    } on DioException catch (e) {
      final String errorMessage = e.response?.data['error']['message'] ??
          'oops, there was an error. Try again later!';
      throw Exception(errorMessage);
    } catch (error) {
      print(error.toString());
      throw Exception('oops, there was an error. Try again later!');
    }
  }
}
