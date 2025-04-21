import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/cubits/get_weather_cubits/get_weather_cubit.dart';
import '../Model/weathermodel.dart';

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the theme is dark
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    // Ensure weatherModel exists before using it
    final weatherModel = BlocProvider.of<GetWeatherCubit>(context).weatherModel;
    if (weatherModel == null) {
      return Center(child: Text("No weather data available", style: TextStyle(color: textColor)));
    }

    // Get the weather condition for dynamic gradient
    final condition = weatherModel.weatherState?.toLowerCase();
    final themeColor = getWeatherThemeColorFromCondition(condition);

    // Define gradient colors based on theme
    final gradientColors = [
      themeColor,
      isDarkMode ? themeColor.shade900 : themeColor.shade100,
    ];

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh the weather data for the current city
        if (weatherModel.location.isNotEmpty) {
          await BlocProvider.of<GetWeatherCubit>(context)
              .getWeather(cityName: weatherModel.location);
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(), // Ensure scrollable for pull-to-refresh
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height, // Full height for scrollable content
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weatherModel.location,
                style: TextStyle(
                  fontSize: 30,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Updated at: ${_formatTime(weatherModel.lastUpdate)}",
                style: TextStyle(fontSize: 20, color: textColor),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.network(
                    "https:${weatherModel.weatherIcon}",
                    height: 50,
                    width: 50,
                  ),
                  Text(
                    "${weatherModel.temp.toStringAsFixed(1)}°C",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Column(
                    children: [
                      Text("Max: ${weatherModel.maxTemp}°C", style: TextStyle(color: textColor)),
                      Text("Min: ${weatherModel.minTemp}°C", style: TextStyle(color: textColor)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 50),
              Text(
                weatherModel.weatherState,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Extract just the time from the full DateTime string
  String _formatTime(String fullDateTime) {
    final DateTime time = DateTime.tryParse(fullDateTime)?.toLocal() ?? DateTime.now();
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  // Get the theme color based on weather condition
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
}