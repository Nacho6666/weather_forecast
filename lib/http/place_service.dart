import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final placeApiProvider = Provider((ref) => PlaceApiProvider("YOUR_SESSION_TOKEN"));

final placeSuggestionsProvider = StateNotifierProvider<PlaceSuggestionsNotifier, List<String>>((ref) {
  return PlaceSuggestionsNotifier(ref);
});


class PlaceSuggestionsNotifier extends StateNotifier<List<String>> {
  final Ref ref;

  PlaceSuggestionsNotifier(this.ref) : super([]);

  Future<void> fetchSuggestions(String input) async {
    String trimmedInput = input.trim(); //輸入空格不處理 減少 api 呼叫
    if (trimmedInput.isNotEmpty && trimmedInput != state){
      final placeApi = ref.read(placeApiProvider);
      try {
        final result = await placeApi.fetchSuggestions(input);
        state = result;
      } catch (e) {
        state = ['Error occurred: $e'];
      }
    }
  }
}

class PlaceApiProvider {
  final Dio client;

  PlaceApiProvider(this.sessionToken) : client = Dio();
  CancelToken _cancelToken = CancelToken();

  final sessionToken;

  static final apiKey = 'AIzaSyAd0jf90j4TY7zZR1qqQj2oWpEiKnXoDE4';

  Future<List<String>> fetchSuggestions(String input) async {
    if(input.isNotEmpty){
      if (!_cancelToken.isCancelled) {
        _cancelToken.cancel();
      }
      _cancelToken = CancelToken();

      try {
        final response = await client.get(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json',
          queryParameters: {
            'input': input,
            'language': 'zh-TW',
            'key': apiKey,
          },
          cancelToken: _cancelToken,
        );
              print("PlaceApi Provider Response: ${response.data}");
              if (response.statusCode == 200) {
                final List predictions = response.data['predictions'];

                return [input] + await predictions.where((prediction) {
                  bool isCityOrCountry = prediction['types'].any((type) => type == 'country' || type == 'locality');
                  return isCityOrCountry;
                }).map<String>((prediction) => prediction['description']).toList();
              } else {
                return ['Failed to fetch suggestions'];
              }
      } catch (e) {
          print('Error occurred: $e');
        rethrow;
      }
    } else {
      return ["請輸入"];
    }
  }
}
