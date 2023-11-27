import 'dart:async';

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

  void _refrash() {
    setState(() {});
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
                          setState(() {
                            ref
                                .watch(placeSuggestionsProvider.notifier)
                                .fetchSuggestions(localController.text);
                          });
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
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: const Icon(Icons.search, size: 30),
                    onPressed: () {
                      print("<< search weather >>");
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
        onPressed: _refrash,
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget weatherView(WeatherData? weather) {
    if (weather == null) {
      return Text("非常抱歉，找不到資料，請再試一次。");
ㄙ    } else {
      return Text('Temperature: ${weather.current?.tempC}°C');
    }
  }
}
