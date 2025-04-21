class WeatherModel {
  late double temp;
  late double maxTemp;
  late double minTemp;
  late String weatherState;
  late String lastUpdate;
  late String weatherIcon;
  late String location;

  WeatherModel({
    required this.temp,
    required this.maxTemp,
    required this.minTemp,
    required this.lastUpdate,
    required this.weatherState,
    required this.weatherIcon,
    required this.location,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    try {
      // Extract forecast data for the first day
      final forecastDay = json['forecast']?['forecastday']?[0]?['day'] as Map<String, dynamic>? ?? {};
      final condition = forecastDay['condition'] as Map<String, dynamic>? ?? {};

      // Extract values with fallback to default if null or missing
      final temp = (json['current']?['temp_c'] as num?)?.toDouble() ?? 0.0;
      final maxTemp = (forecastDay['maxtemp_c'] as num?)?.toDouble() ?? 0.0;
      final minTemp = (forecastDay['mintemp_c'] as num?)?.toDouble() ?? 0.0;
      final weatherState = condition['text'] as String? ?? 'Unknown';
      final weatherIcon = condition['icon'] as String? ?? '//cdn.weatherapi.com/weather/64x64/day/113.png';
      final lastUpdate = json['current']?['last_updated'] as String? ?? DateTime.now().toString();
      final location = json['location']?['name'] as String? ?? 'Unknown';

      // Log the extracted data for debugging
      print("WeatherModel created - Location: $location, Temp: $temp, Weather: $weatherState");

      return WeatherModel(
        temp: temp,
        maxTemp: maxTemp,
        minTemp: minTemp,
        lastUpdate: lastUpdate,
        weatherState: weatherState,
        weatherIcon: weatherIcon,
        location: location,
      );
    } catch (e, stackTrace) {
      // Log any errors during JSON parsing
      print("Error parsing WeatherModel from JSON: $e");
      print("Stack trace: $stackTrace");

      // Return a default WeatherModel in case of error
      return WeatherModel(
        temp: 0.0,
        maxTemp: 0.0,
        minTemp: 0.0,
        lastUpdate: DateTime.now().toString(),
        weatherState: 'Unknown',
        weatherIcon: '//cdn.weatherapi.com/weather/64x64/day/113.png',
        location: 'Unknown',
      );
    }
  }
}