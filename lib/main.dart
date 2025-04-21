import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/cubits/get_weather_cubits/get_weather_cubit.dart';
import 'package:weatherapp/Screens/homescreen.dart';
import 'package:weatherapp/cubits/get_weather_cubits/get_weather_states.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<String?> _conditionNotifier = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetWeatherCubit(),
      child: BlocListener<GetWeatherCubit, WeatherState>(
        listener: (context, state) {
          if (state is WeatherLoadedState) {
            _conditionNotifier.value = BlocProvider.of<GetWeatherCubit>(context).weatherModel?.weatherState;
          } else if (state is NoWeatherState) {
            _conditionNotifier.value = null;
          }
        },
        child: ValueListenableBuilder<String?>(
          valueListenable: _conditionNotifier,
          builder: (context, condition, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: getWeatherThemeColorFromCondition(condition),
                scaffoldBackgroundColor: getWeatherThemeColorFromCondition(condition).shade100,
                appBarTheme: AppBarTheme(
                  backgroundColor: getWeatherThemeColorFromCondition(condition),
                ),
              ),
              home: const HomeScreen(),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _conditionNotifier.dispose();
    super.dispose();
  }
}

MaterialColor getWeatherThemeColorFromCondition(String? condition) {
  if (condition == null) return Colors.teal;

  condition = condition.toLowerCase();

  if (condition.contains("sunny") || condition.contains("clear")) {
    return Colors.orange;
  } else if (condition.contains("cloudy")) {
    return Colors.blueGrey;
  } else if (condition.contains("overcast")) {
    return Colors.grey;
  } else if (condition.contains("mist") || condition.contains("fog") || condition.contains("drizzle")) {
    return Colors.indigo;
  } else if (condition.contains("rain") || condition.contains("thunder")) {
    return Colors.deepPurple;
  } else if (condition.contains("snow") || condition.contains("sleet") || condition.contains("freezing")) {
    return Colors.blue;
  } else if (condition.contains("shower") || condition.contains("pellets")) {
    return Colors.cyan;
  } else {
    return Colors.teal;
  }
}