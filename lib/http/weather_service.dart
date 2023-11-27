import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/weather_data.dart';

final httpProvider = Provider((_) => WeatherClient());

final weatherProvider =
    StateNotifierProvider.family<WeatherNotifier, WeatherState, String>(
  (ref, location) => WeatherNotifier(ref.watch(httpProvider)),
);

class WeatherClient {
  static const String weather_key = "e89bd8f012934be7af6100013232311";
  final Dio _weatherClient;
  static const String weatherURL = "https://api.weatherapi.com/v1/current.json";

  WeatherClient()
      : _weatherClient = Dio(BaseOptions(
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 5),
          sendTimeout: Duration(seconds: 5),
        ));

  Future<Response> getInfoFromLocation(String location) async {
    try {
      print("trying");
      final response = await _weatherClient.get(
        weatherURL,
        queryParameters: {
          'key': weather_key,
          'q': location,
          'aqi': 'true',
        },
      );
      var data = response.data;
      if (data is Map) {
        printFormatted(data);
        print('printFormatted');
      } else {
        print(data);
      }
      return response;
    } catch (e) {
      print('Error occurred: $e');
      rethrow;
    }
  }

  void printFormatted(Map data, [String prefix = '']) {
    data.forEach((key, value) {
      if (value is Map) {
        print('$prefix$key:');
        print('$prefix  {');
        printFormatted(value, '$prefix    ');
        print('$prefix  }');
      } else {
        print('$prefix  $key: $value');
      }
    });
  }
}

class WeatherState {
  final WeatherData? weatherData;
  final bool isLoading;
  final String? error;

  WeatherState({this.weatherData, this.isLoading = false, this.error});

  WeatherState.loading() : this(isLoading: true);
  WeatherState.success(WeatherData weatherData)
      : this(weatherData: weatherData);
  WeatherState.error(String error) : this(error: error);
}

class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherClient _weatherClient;

  WeatherNotifier(this._weatherClient) : super(WeatherState());

  Future<void> fetchWeather(String location) async {
    state = WeatherState.loading();
    try {
      print("WeatherNotifier trying");
      final response = await _weatherClient.getInfoFromLocation(location);
      final weatherData = WeatherData.fromJson(response.data);
      state = WeatherState.success(weatherData);
    } catch (e) {
      //錯誤處理
      if (e is DioError && e.response?.statusCode == 400) {
        state = WeatherState.error("客戶端錯誤 - 請求包含錯誤的語法或無法被滿足");
      } else {
        state = WeatherState.error(e.toString());
      }
    }
  }
}
