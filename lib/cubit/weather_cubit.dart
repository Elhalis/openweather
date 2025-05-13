import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'weather_state.dart';
import '../repo/repo.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherInitial());

  Future<void> fetchWeather() async {
    try {
      emit(WeatherLoading());
      debugPrint('WeatherCubit: Fetching weather data...');
      
      final apiService = ApiService();
      final weather = await apiService.fetchData();
      
      debugPrint('WeatherCubit: Weather data received: $weather');
      emit(WeatherSuccess(weather));
    } catch (e) {
      debugPrint('WeatherCubit: Error fetching weather - $e');
      emit(WeatherFailure(e.toString()));
    }
  }
}
