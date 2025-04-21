import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/Screens/noweatherscreen.dart';
import 'package:weatherapp/Screens/weatherscreen.dart';
import 'package:weatherapp/cubits/get_weather_cubits/get_weather_cubit.dart';
import 'package:weatherapp/cubits/get_weather_cubits/get_weather_states.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();
  DateTime? _lastSearchTime; // Track the last search time for debouncing

  // Calculate contrast color for text and icons based on background color
  Color getContrastColor(Color backgroundColor) {
    double luminance = (0.299 * backgroundColor.red +
        0.587 * backgroundColor.green +
        0.114 * backgroundColor.blue) /
        255;

    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    // Get the AppBar color from the theme, fallback to blue if not available
    final appBarColor = Theme.of(context).appBarTheme.backgroundColor ?? Colors.blue;
    final contrastColor = getContrastColor(appBarColor);

    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
          controller: searchController,
          autofocus: true,
          onSubmitted: (value) {
            // Debouncing: Ensure at least 1 second between requests
            final now = DateTime.now();
            if (_lastSearchTime != null &&
                now.difference(_lastSearchTime!).inSeconds < 1) {
              print("Please wait before making another search.");
              return;
            }

            // Check if the input is not empty
            if (value.trim().isEmpty) {
              print("Search input is empty, ignoring request.");
              return;
            }

            // Log the search action
            print("Searching for city: $value");

            // Make the weather request
            BlocProvider.of<GetWeatherCubit>(context)
                .getWeather(cityName: value.trim());
            _lastSearchTime = now;

            setState(() {
              isSearching = false;
              searchController.clear();
            });
          },
          decoration: InputDecoration(
            hintText: "Enter city name",
            hintStyle: TextStyle(color: contrastColor.withOpacity(0.7)),
            border: InputBorder.none,
          ),
          style: TextStyle(color: contrastColor, fontSize: 18),
        )
            : Text(
          "Weather App",
          style: TextStyle(
            color: contrastColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isSearching ? Icons.close : Icons.search,
              color: contrastColor,
            ),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) searchController.clear();
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<GetWeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is NoWeatherState) {
            return const NoWeatherScreen();
          } else if (state is WeatherLoadedState) {
            return WeatherScreen();
          } else if (state is WeatherFailureState) {
            return const Center(
              child: Text(
                "Oops, there was an error fetching weather.",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            );
          } else if (state is WeatherLoadingState) {
            // Show CircularProgressIndicator while loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Fallback case (shouldn't happen with proper state management)
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}