import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_forecast/model/weather_data.dart';
import 'http/place_service.dart';
import 'http/weather_service.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final BorderRadiusGeometry customRadius = BorderRadius.circular(10);
  String? _searchQuery = "";
  SearchController searchController = SearchController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        _searchQuery = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void updateSearchQuery() {
    setState(() {
      _searchQuery = searchController.text;
    });
  }

  void _searchWeather() {
    print("Initiating search for $_searchQuery");
    if (_searchQuery != null && _searchQuery!.isNotEmpty) {
      ref
          .read(weatherProvider(_searchQuery!).notifier)
          .fetchWeather(_searchQuery!);
    } else {
      print("No search query provided");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Column(
        children: [
          PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: Consumer(builder: (context, ref, child) {
                return SearchAnchor(
                    searchController: searchController,
                    isFullScreen: false,
                    builder: (BuildContext context, localController) {
                      localController.addListener(() {
                        setState(() {});
                      });
                      return SearchBar(
                        elevation: const MaterialStatePropertyAll(0),
                        hintText: "請輸入想查詢的國家",
                        controller: localController,
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: customRadius),
                        ),
                        onTap: () {
                          localController.openView();
                        },
                        onChanged: (_) {
                          ref
                              .watch(placeSuggestionsProvider.notifier)
                              .fetchSuggestions(localController.text);
                        },
                      );
                    },
                    suggestionsBuilder:
                        (BuildContext context, SearchController controller) {
                      final suggestions = ref.watch(placeSuggestionsProvider);
                      ref
                          .read(placeSuggestionsProvider.notifier)
                          .fetchSuggestions(controller.text);

                      if (suggestions.isNotEmpty) {
                        return suggestions.map<Widget>((suggestion) {
                          return ListTile(
                            title: Text(suggestion),
                            onTap: () {
                              controller.text = suggestion;
                              controller.closeView(suggestion);
                            },
                          );
                        }).toList();
                      } else {
                        return [Center(child: CircularProgressIndicator())];
                      }
                    });
              }),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton(
                    icon: const Icon(Icons.search, size: 30),
                    onPressed: () {
                      _searchWeather();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 60.0, left: 15, right: 15),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: customRadius,
                ),
                child: Consumer(
                  builder: (context, ref, _) {
                    final weatherState =
                        ref.watch(weatherProvider(_searchQuery ?? ""));

                    //讀取狀態
                    if (weatherState.isLoading) {
                      return Center(child: CircularProgressIndicator());
                    }

                    //錯誤狀態
                    else if (weatherState.error != null) {
                      if (weatherState.error == "客戶端錯誤 - 請求包含錯誤的語法或無法被滿足") {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text(
                                  '錯誤: ${searchController.text} 搜尋無結果, 請試著輸入國家或城市再試一次')),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Text('錯誤: ${weatherState.error}, 請再試一次')),
                        );
                      }
                    } else if (weatherState.weatherData != null) {
                      return weatherView(weatherState.weatherData);
                    }
                    //初始狀態
                    return Center(child: Text('請輸入國家或城市以獲取天氣'));
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _searchWeather,
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget weatherView(WeatherData? weather) {
    if (weather == null) {
      return Text("非常抱歉，找不到資料，請再試一次。");
    } else {
      var hourlyForecastsList =
          weather.forecast?.dayForecasts?[0].hourlyForecasts;
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (weather.location?.name != weather.location?.country)
                    ? '現在位置: ${weather.location?.name}-${weather.location?.country}'
                    : '現在位置: ${weather.location?.name}',
                style: TextStyle(fontSize: 20),
              ),
              Text('${weather.location?.tzId}'),
              Text(
                '經緯度: (${weather.location?.lat},${weather.location?.lon})',
                style: TextStyle(fontSize: 10),
              ),
              Divider(),
              Text('最後更新時間: ${weather.current?.lastUpdated}'),
              Text(
                  '實際溫度: ${weather.current?.tempC}°C /  ${weather.current?.tempF}°F'),
              Text(
                  '體感溫度: ${weather.current?.feelslikeC}°C /  ${weather.current?.feelslikeF}°F'),
              Text('紫外線指數: ${weather.current?.uv}'),
              Divider(),
              Text("每小時預報",style: TextStyle(fontSize: 20),),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('時間'),
                          Text('溫度'),
                          Text('雨/雪機率'),
                        ],
                      ),
                    ),
                    ...List.generate(
                    hourlyForecastsList?.length ?? 0,
                    (index) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                  '${hourlyForecastsList?[index].time?.split(' ')[1]}'),
                              Text(
                                '${hourlyForecastsList?[index].tempC}°C / ${hourlyForecastsList?[index].tempF}°F',
                                style: TextStyle(fontSize: 11),
                              ),
                              Text(
                                '${hourlyForecastsList?[index].will_it_rain}% / ${hourlyForecastsList?[index].will_it_snow}%',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),]
                ),
              ),
              Divider(),
              Text("天氣預測:", style: TextStyle(fontSize: 20)),
              Text(
                  "今日溫差:${weather.forecast?.dayForecasts?.first.maxTempC} ~ ${weather.forecast?.dayForecasts?.first.minTempC}°C / ${weather.forecast?.dayForecasts?.first.maxTempF} ~ ${weather.forecast?.dayForecasts?.first.minTempF}°F"),
              Text(
                  '最大風速: ${weather.forecast?.dayForecasts?.first.maxWindKph} Km/h'),
              Text(
                  '平均濕度: ${weather.forecast?.dayForecasts?.first.avgHumidity}'),
              Text(
                  '降水量: ${weather.forecast?.dayForecasts?.first.totalPrecipMm}mm'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '日出時間: ${weather.forecast?.dayForecasts?.first.astro?.sunrise}'),
                  Text(
                      '日落時間: ${weather.forecast?.dayForecasts?.first.astro?.sunset}'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '月出時間: ${weather.forecast?.dayForecasts?.first.astro?.moonrise}'),
                  Text(
                      '月落時間: ${weather.forecast?.dayForecasts?.first.astro?.moonset}'),
                ],
              ),
              Text(
                  '注意事項: ${weather.forecast?.dayForecasts?.first.dayCondition?.text}'),
            ],
          ),
        ),
      );
    }
  }
}
