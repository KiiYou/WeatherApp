import 'package:flutter/material.dart';

class NoWeatherScreen extends StatelessWidget {
  const NoWeatherScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off,
            size: 50,
            color: Colors.black,
          ),
          const SizedBox(height: 20),
          Text(
            "There is no weather 😞\nStart searching now 🔍",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
