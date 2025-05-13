import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:openweather/model/weather.dart';
import 'package:openweather/services/services.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String _baseUrl =
      'https://api.openweathermap.org/data/2.5/forecast';
  final String? _apiKey = dotenv.env['API_KEY'];

  // Simulate an API call
  Future<Weather> fetchData() async {
    final locationService = LocationService();
    final location = await locationService.getLocation();
    
    try {
      final response = await _dio.get(_baseUrl, queryParameters: {
        'lon': location.longitude.toString(),
        'lat': location.latitude.toString(),
        'appid': _apiKey,
        'units': 'metric',
      });
      debugPrint('Debug: API Response status code: ${response.statusCode}');
      debugPrint('Debug: API Response data: ${response.data}');
      
      if (response.statusCode == 200) {
        final weather = Weather.fromJson(response.data);
        return weather;
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      rethrow;
    }
  }
}
