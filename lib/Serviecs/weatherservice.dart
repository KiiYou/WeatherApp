import 'package:dio/dio.dart';
import 'package:weatherapp/Model/weathermodel.dart';

class WeatherService {
 final Dio dio;

 WeatherService()
     : dio = Dio(BaseOptions(
  connectTimeout: Duration(seconds: 5), // Set connection timeout to 5 seconds
  receiveTimeout: Duration(seconds: 5), // Set receive timeout to 5 seconds
 ));

 Future<WeatherModel> getWeather(final String location) async {
  try {
   // Log the request details
   print("Sending request to fetch weather for: $location");

   final response = await dio.get(
    "http://api.weatherapi.com/v1/forecast.json",
    queryParameters: {
     "key": "094a4298eab8495da8481752251904",
     "q": location,
     "days": 1,
    },
   );

   // Log the response status
   print("Response status code: ${response.statusCode}");

   if (response.statusCode == 200) {
    Map<String, dynamic> jsonData = response.data;
    // Log successful data retrieval
    print("Weather data retrieved successfully for $location");
    return WeatherModel.fromJson(jsonData);
   } else {
    // Log failure with status code and response body
    print("Failed to fetch weather data: Status code ${response.statusCode}");
    print("Response body: ${response.data}");
    throw Exception("Failed to fetch weather data: ${response.statusCode}");
   }
  } on DioException catch (e) {
   // Log Dio-specific errors
   print("DioException occurred: ${e.message}");
   if (e.response != null) {
    print("Error response data: ${e.response?.data}");
    print("Error response status: ${e.response?.statusCode}");
   }
   throw Exception("Connection error: ${e.message}");
  } catch (e) {
   // Log unexpected errors
   print("Unexpected error occurred: $e");
   throw Exception("Unexpected error occurred: $e");
  }
 }
}