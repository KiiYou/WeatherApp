import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/Model/weathermodel.dart';
import 'package:weatherapp/Serviecs/weatherservice.dart';
import 'package:weatherapp/cubits/get_weather_cubits/get_weather_states.dart';

class GetWeatherCubit extends Cubit<WeatherState> {
  GetWeatherCubit() : super(NoWeatherState());

  WeatherModel? weatherModel;
  String? _lastCityName; // Track the last searched city
  bool _isRequestInProgress = false; // Prevent concurrent requests

  Future<void> getWeather({required String cityName}) async {
    // If a request is already in progress, ignore the new request
    if (_isRequestInProgress) {
      print("Request already in progress, ignoring new request for: $cityName");
      return;
    }

    // If the city is the same as the last one and we have data, return cached data
    if (_lastCityName == cityName && weatherModel != null) {
      print("Returning cached data for: $cityName");
      emit(WeatherLoadedState());
      return;
    }

    _isRequestInProgress = true;

    // Emit loading state to show the CircularProgressIndicator
    emit(WeatherLoadingState());

    try {
      // Add a small delay to avoid rate limiting (optional)
      await Future.delayed(Duration(milliseconds: 500));

      print("Fetching weather for: $cityName");
      weatherModel = await WeatherService().getWeather(cityName);
      _lastCityName = cityName; // Update the last searched city
      emit(WeatherLoadedState());
    } catch (e, stackTrace) {
      // Log the error to understand the cause of failure
      print("Error fetching weather for $cityName: $e");
      print("Stack trace: $stackTrace");
      emit(WeatherFailureState());
    } finally {
      _isRequestInProgress = false;
    }
  }
}