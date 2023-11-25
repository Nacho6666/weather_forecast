import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/weather_data.dart';

///weather provider
final httpProvider = Provider((_) => WeatherClient());

final weatherProvider =
FutureProvider.family<WeatherData, String>((ref, location) async {
  print("Fetching weather for $location");
  final httpClient = ref.watch(httpProvider);
  final response = await httpClient.getInfoFromLocation(location);
  return WeatherData.fromJson(response.data);
});

///

class WeatherClient {
  static const String weather_key = "e89bd8f012934be7af6100013232311";
  final Dio _weatherClient;

  WeatherClient() : _weatherClient = Dio();

  Future<Response> getInfoFromLocation(String location) async {
    try {
      final response = await _weatherClient.get(
        "https://api.weatherapi.com/v1/current.json",
        queryParameters: {
          'key': weather_key,
          'q': location,
          'aqi': 'no',
        },
      );

      print(response.data);
      return response;
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }
}
