# WeatherApp

A simple Flutter weather app that fetches real-time weather data using the WeatherAPI.

## Features
- Search for weather by city name or current location.
- Dynamic theme colors based on weather conditions (e.g., sunny, rainy, cloudy).
- Support for Dark Mode based on system settings.
- Pull-to-refresh to update weather data.
- Retry mechanism for failed API requests.
- Offline caching using SharedPreferences to reduce API calls.


## Setup Instructions
Follow these steps to run the app on your local machine:

1. **Clone the repository**:
   ```bash
   git clone https://github.com/YourUsername/WeatherApp.git
Navigate to the project directory:
  cd WeatherApp
Install dependencies:
  flutter pub get
Set up the API Key:
  Create a .env file in the root of the project.
Add your WeatherAPI key:
  WEATHER_API_KEY=your_api_key_here
  You can get a free API key from WeatherAPI.
Run the app:
```bash
  flutter run
```
Dependencies
The app uses the following packages:

  flutter_bloc - For state management.
  dio - For making HTTP requests to the WeatherAPI.
  shared_preferences - For caching weather data locally.
  geolocator - For fetching the user's current location.
  flutter_dotenv - For managing environment variables (e.g., API keys).
  Project Structure
  lib/Screens/ - Contains the UI screens (e.g., HomeScreen, WeatherScreen).
  lib/Model/ - Contains the data model (WeatherModel).
  lib/Serviecs/ - Contains the API service (WeatherService).
  lib/cubits/ - Contains the state management logic using flutter_bloc.
Usage
  Launch the app.
  Enter a city name in the search bar or use the location button to fetch weather data for your current location.
  The app will display the current temperature, max/min temperatures, and weather condition.
  Pull down to refresh the weather data if needed.
  Contributing
  Contributions are welcome! If you'd like to contribute:
  
  Fork the repository.
  Create a new branch (git checkout -b feature/your-feature).
  Make your changes and commit them (git commit -m "Add your feature").
  Push to the branch (git push origin feature/your-feature).
  Open a Pull Request.
  License
This project is licensed under the MIT License - see the  file for details.

Acknowledgments
  Weather data provided by WeatherAPI.
Built with Flutter.
