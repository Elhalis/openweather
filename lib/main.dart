import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:openweather/cubit/weather_cubit.dart';

import 'screens/home_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        return WeatherCubit()..fetchWeather();
      },
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      )
    );
  }
}

