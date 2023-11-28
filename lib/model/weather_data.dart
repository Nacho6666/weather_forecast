class WeatherData {
  Location? location;
  Current? current;
  Forecast? forecast;
  Astro? astro;

  WeatherData({this.location, this.current, this.forecast, this.astro});

  WeatherData.fromJson(Map<String, dynamic> json) {
    location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    current =
        json['current'] != null ? Current.fromJson(json['current']) : null;
    forecast =
        json['forecast'] != null ? Forecast.fromJson(json['forecast']) : null;
    astro = json['astro'] != null ? Astro.fromJson(json['astro']) : null;
  }
}

class Astro {
  final String? sunrise;
  final String? sunset;
  final String? moonrise;
  final String? moonset;
  final String? moonPhase;
  final int? moonIllumination;

  Astro(
      {this.sunrise,
      this.sunset,
      this.moonrise,
      this.moonset,
      this.moonPhase,
      this.moonIllumination});

  factory Astro.fromJson(Map<String, dynamic> json) {
    return Astro(
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      moonPhase: json['moon_phase'],
      moonIllumination: json['moon_illumination'],
    );
  }
}

class Forecast {
  final List<DayForecast>? dayForecasts;

  Forecast({this.dayForecasts});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    var list = json['forecastday'] as List;
    List<DayForecast> dayForecasts =
        list.map((i) => DayForecast.fromJson(i)).toList();
    return Forecast(dayForecasts: dayForecasts);
  }
}

class DayForecast {
  final String? date;
  final String? time;
  final double? maxTempC;
  final double? minTempC;
  final double? avgTempC;
  final double? maxTempF;
  final double? minTempF;
  final double? avgTempF;
  final double? maxWindKph;
  final double? totalPrecipMm;
  final double? avgVisKm;
  final double? avgHumidity;
  final Astro? astro;
  final Condition? dayCondition;
  final List<HourForecast>? hourlyForecasts;

  DayForecast({
    this.date,
    this.time,
    this.maxTempC,
    this.minTempC,
    this.avgTempC,
    this.maxTempF,
    this.minTempF,
    this.avgTempF,
    this.maxWindKph,
    this.totalPrecipMm,
    this.avgVisKm,
    this.avgHumidity,
    this.astro,
    this.dayCondition,
    this.hourlyForecasts,
  });

  factory DayForecast.fromJson(Map<String, dynamic> json) {
    var hourlyList = json['hour'] as List;
    List<HourForecast> hourlyForecasts =
        hourlyList.map((i) => HourForecast.fromJson(i)).toList();
    return DayForecast(
      date: json['date'],
      time: json['time'],
      maxTempC: json['day']['maxtemp_c'],
      minTempC: json['day']['mintemp_c'],
      avgTempC: json['day']['avgtemp_c'],
      maxTempF: json['day']['maxtemp_f'],
      minTempF: json['day']['mintemp_f'],
      avgTempF: json['day']['avgtemp_f'],
      maxWindKph: json['day']['maxwind_kph'],
      totalPrecipMm: json['day']['totalprecip_mm'],
      avgVisKm: json['day']['avgvis_km'],
      avgHumidity: json['day']['avghumidity'],
      astro: Astro.fromJson(json['astro']),
      dayCondition: Condition.fromJson(json['day']['condition']),
      hourlyForecasts: hourlyForecasts,
    );
  }
}

class HourForecast {
  final String? time;
  final double? tempC;
  final double? tempF;
  final int? isDay;
  final Condition? condition;
  final double? windMph;
  final double? windKph;
  final double? windDegree;
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
  final int? will_it_rain;
  final int? will_it_snow;

  HourForecast({
    this.time,
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
    this.will_it_rain,
    this.will_it_snow,
  });

  factory HourForecast.fromJson(Map<String, dynamic> json) {
    return HourForecast(
      time: json['time'],
      tempC: json['temp_c'],
      tempF: json['temp_f'],
      isDay: json['is_day'],
      condition: json['condition'] != null
          ? Condition.fromJson(json['condition'])
          : null,
      cloud: json['cloud'],
      will_it_rain: json['will_it_rain'],
      will_it_snow: json['will_it_snow'],
    );
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
