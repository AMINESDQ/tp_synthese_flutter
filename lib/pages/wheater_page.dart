import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tp_synthse_flutter/global.dart';

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  String _weatherInfo = '';

  Future<void> _fetchWeather(String city) async {
    // Remplacez par votre clé API WeatherApi
    final url = 'http://api.weatherapi.com/v1/current.json?key=$weatherApi&q=$city';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _weatherInfo = 'Température: ${data['current']['temp_c']}°C\n'
                         'Condition: ${data['current']['condition']['text']}';
        });
      } else {
        setState(() {
          _weatherInfo = 'Erreur lors de la récupération des données météorologiques';
        });
      }
    } catch (e) {
      setState(() {
        _weatherInfo = 'Erreur lors de la récupération des données météorologiques';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Entrez le nom de la ville',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.blueAccent),
                ),
                style: TextStyle(color: Colors.blueAccent),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _fetchWeather(_controller.text);
                },
                child: Text('Obtenir la météo'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Text(
                  _weatherInfo,
                  style: TextStyle(fontSize: 20, color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blue[100],
    );
  }
}
