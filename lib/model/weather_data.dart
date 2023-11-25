class WeatherData {
  Location? location;
  Current? current;

  WeatherData({this.location, this.current});

  WeatherData.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
    current =
    json['current'] != null ? new Current.fromJson(json['current']) : null;
  }
}

class Location {
  final String? name;
  final String? region;
  final String? country;
  final double? lat;
  final double? lon;
  final String? tzId;
  final int? localtimeEpoch;
  final String? localtime;

  Location({
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.tzId,
    this.localtimeEpoch,
    this.localtime,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json['name'],
        region: json['region'],
        country: json['country'],
        lat: json['lat'],
        lon: json['lon'],
        tzId: json['tz_id'],
        localtimeEpoch: json['localtime_epoch'],
        localtime: json['localtime'],
      );
}

class Current {
  final int? lastUpdatedEpoch;
  final String? lastUpdated;
  final double? tempC;
  final double? tempF;
  final int? isDay;
  final Condition? condition;
  final double? windMph;
  final double? windKph;
  final int? windDegree;
  final String? windDir;
  final double? pressureMb;
  final double? pressureIn;
  final double? precipMm;
  final double? precipIn;
  final int? humidity;
  final int? cloud;
  final double? feelslikeC;
  final double? feelslikeF;
  final double? visKm;
  final double? visMiles;
  final double? uv;
  final double? gustMph;
  final double? gustKph;

  Current({
    this.lastUpdatedEpoch,
    this.lastUpdated,
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
    this.windMph,
    this.windKph,
    this.windDegree,
    this.windDir,
    this.pressureMb,
    this.pressureIn,
    this.precipMm,
    this.precipIn,
    this.humidity,
    this.cloud,
    this.feelslikeC,
    this.feelslikeF,
    this.visKm,
    this.visMiles,
    this.uv,
    this.gustMph,
    this.gustKph,
  });

  factory Current.fromJson(Map<String, dynamic> json) {
    try {
      return Current(
        lastUpdatedEpoch: json['last_updated_epoch'],
        lastUpdated: json['last_updated'],
        tempC: json['temp_c'],
        tempF: json['temp_f'],
        isDay: json['is_day'],
        condition: json['condition'] != null
            ? Condition.fromJson(json['condition'])
            : null,
        windMph: json['wind_mph'],
        windKph: json['wind_kph'],
        windDegree: json['wind_degree'],
        windDir: json['wind_dir'],
        pressureMb: json['pressure_mb'],
        pressureIn: json['pressure_in'],
        precipMm: json['precip_mm'],
        precipIn: json['precip_in'],
        humidity: json['humidity'],
        cloud: json['cloud'],
        feelslikeC: json['feelslike_c'],
        feelslikeF: json['feelslike_f'],
        visKm: json['vis_km'],
        visMiles: json['vis_miles'],
        uv: json['uv'],
        gustMph: json['gust_mph'],
        gustKph: json['gust_kph'],
      );
    } catch (e) {
      print(e);
      return Current();
    }
  }
}

class Condition {
  final String? text;
  final String? icon;
  final int? code;

  Condition({this.text, this.icon, this.code});

  // factory Condition.fromJson(Map<String, dynamic> json) => Condition(
  //   text: json['text'],
  //   icon: json['icon'],
  //   code: json['code'],
  // );
  factory Condition.fromJson(Map<String, dynamic> json) {
    try {
      return Condition(
        text: json['text'],
        icon: json['icon'],
        code: json['code'],
      );
    } catch (e) {
      print('Error parsing Current: $e');
      return Condition();
    }
  }
}
