import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final double temperature;
  final String description;
  final Map<String, dynamic> main;
  final List<dynamic> weather;
  final String city;
  final String condition;
  final String icon;
  final int sunrise;
  final int sunset;
  final DateTime date;
  final double currentTemp;
  final double feelsLike;
  final double maxTemp;
  final double minTemp;
  final double humidity;
  final double windSpeed;
  final double pressure;
  final int code;
  final List<Forecast> forecasts;
  final List<DailySummary> dailySummaries;

  const Weather({
    required this.temperature,
    required this.description,
    required this.main,
    required this.weather,
    required this.city,
    required this.condition,
    required this.icon,
    required this.sunrise,
    required this.sunset,
    required this.date,
    required this.currentTemp,
    required this.feelsLike,
    required this.maxTemp,
    required this.minTemp,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.code,
    required this.forecasts,
    required this.dailySummaries,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    // reusable data access variables 
    final firstWeather = json['list'][0];
    final mainData = firstWeather['main'];
    final weatherData = firstWeather['weather'][0];
    
    return Weather(
      temperature: mainData['temp'].toDouble(),
      description: weatherData['description'],
      main: mainData,
      weather: firstWeather['weather'],
      city: json['city']?['name'] ?? 'Unknown',
      condition: weatherData['main'],
      icon: weatherData['icon'],
      sunrise: json['city']?['sunrise'] ?? 0,
      sunset: json['city']?['sunset'] ?? 0,
      date: DateTime.parse(firstWeather['dt_txt']),
      currentTemp: mainData['temp'].toDouble(),
      feelsLike: mainData['feels_like'].toDouble(),
      maxTemp: mainData['temp_max'].toDouble(),
      minTemp: mainData['temp_min'].toDouble(),
      humidity: mainData['humidity'].toDouble(),
      windSpeed: firstWeather['wind']['speed'].toDouble(),
      pressure: mainData['pressure'].toDouble(),
      code: weatherData['id'],
      forecasts: (json['list'] as List<dynamic>)
          .skip(1)
          .take(5)
          .map((e) => Forecast.fromJson(e))
          .toList(),
      dailySummaries: _createDailySummaries(json['list'] as List<dynamic>),
    );
  }

  static List<DailySummary> _createDailySummaries(List<dynamic> list) {
    Map<String, List<Map<String, dynamic>>> dailyData = {};
    
    for (var item in list) {
      String date = item['dt_txt'].split(' ')[0];
      if (!dailyData.containsKey(date)) {
        dailyData[date] = [];
      }
      dailyData[date]!.add(item);
    }

    return dailyData.entries.map((entry) {
      var dayForecasts = entry.value;
      var maxTemp = dayForecasts.map((f) => f['main']['temp_max'] as num).reduce((a, b) => a > b ? a : b);
      var minTemp = dayForecasts.map((f) => f['main']['temp_min'] as num).reduce((a, b) => a < b ? a : b);
      var mostFrequentWeather = _getMostFrequentWeather(dayForecasts);

      return DailySummary(
        date: DateTime.parse(entry.key),
        maxTemp: maxTemp.toDouble(),
        minTemp: minTemp.toDouble(),
        condition: mostFrequentWeather['main'],
        icon: mostFrequentWeather['icon'],
        code: mostFrequentWeather['id'],
      );
    }).toList();
  }

  static Map<String, dynamic> _getMostFrequentWeather(List<Map<String, dynamic>> forecasts) {
    Map<String, int> weatherCount = {};
    Map<String, Map<String, dynamic>> weatherData = {};

    for (var forecast in forecasts) {
      var weather = forecast['weather'][0];
      var key = weather['main'];
      weatherCount[key] = (weatherCount[key] ?? 0) + 1;
      weatherData[key] = weather;
    }

    String mostFrequent = weatherCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;

    return weatherData[mostFrequent]!;
  }

  @override
  List<Object?> get props => [
        temperature,
        description,
        main,
        weather,
        city,
        condition,
        icon,
        sunrise,
        sunset,
        date,
        currentTemp,
        feelsLike,
        maxTemp,
        minTemp,
        humidity,
        windSpeed,
        pressure,
        code,
        forecasts,
        dailySummaries,
      ];

  @override
  String toString() {
    return 'Weather(temperature: $temperature, description: $description, city: $city, condition: $condition, currentTemp: $currentTemp)';
  }
}

class Forecast extends Equatable {
  final int dateTime;
  final double temp;
  final String condition;
  final String icon;
  final String code;

  const Forecast({
    required this.dateTime,
    required this.temp,
    required this.condition,
    required this.icon,
    required this.code,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    final weather = json['weather'][0];
    return Forecast(
      dateTime: json['dt'],
      temp: json['main']['temp'].toDouble(),
      condition: weather['main'],
      icon: weather['icon'],
      code: weather['id'].toString(),
    );
  }

  @override
  List<Object?> get props => [dateTime, temp, condition, icon, code];

  @override
  String toString() {
    return 'Forecast(dateTime: $dateTime, temp: $temp, condition: $condition)';
  }
}

class DailySummary extends Equatable {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String condition;
  final String icon;
  final int code;

  const DailySummary({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.condition,
    required this.icon,
    required this.code,
  });

  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      date: json['date'] as DateTime,
      maxTemp: (json['maxTemp'] as num).toDouble(),
      minTemp: (json['minTemp'] as num).toDouble(),
      condition: json['condition'] as String,
      icon: json['icon'] as String,
      code: json['code']! as int,
    );
  }

  @override
  List<Object?> get props => [date, maxTemp, minTemp, condition, icon, code];

  @override
  String toString() {
    return 'DailySummary(date: $date, maxTemp: $maxTemp, minTemp: $minTemp, condition: $condition)';
  }
}
