import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Timer? _debounce;

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
    _debounce?.cancel();
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
      ref.read(weatherProvider(_searchQuery!));
    } else {
      print("false");
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
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce = Timer(const Duration(seconds: 1), () {
                            setState(() {
                              ref
                                  .watch(placeSuggestionsProvider.notifier)
                                  .fetchSuggestions(localController.text);
                            });
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
                      print("<<_searchQuery = $_searchQuery >>");
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
                // child:
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
}
