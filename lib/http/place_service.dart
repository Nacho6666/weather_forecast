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
    String trimmedInput = input.trim();
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

  final sessionToken;

  static final apiKey = 'AIzaSyAd0jf90j4TY7zZR1qqQj2oWpEiKnXoDE4';

  Future<List<String>> fetchSuggestions(String input) async {
    if(input.isNotEmpty){
      try {
        final response = await client.get(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json',
          queryParameters: {
            'input': input,
            'language': 'zh-TW',
            'key': apiKey,
          },
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
