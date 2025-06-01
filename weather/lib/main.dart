import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();  
}

class _WeatherScreenState extends State<WeatherScreen> {
  Weather? _weather;
  bool _loading = false;
  final TextEditingController _controller = TextEditingController();

  static const String apiKey =
      '977943d7781fce72e42f5f3f627be1d2'; 

  @override
  void initState() {
    super.initState();
    _fetchWeatherByLocation();
  }

  Future<void> _fetchWeatherByCity(String city) async {
    setState(() {
      _loading = true;
    });

    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final weatherJson = json.decode(response.body);
      setState(() {
        _weather = Weather.fromJson(weatherJson);
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      _showErrorDialog('Kota "$city" tidak ditemukan!');
    }
  }

  Future<void> _fetchWeatherByLocation() async {
    // Koordinat Bengkalis
    const defaultLat = 1.4897;
    const defaultLon = 102.0797;

    setState(() {
      _loading = true;
    });

    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$defaultLat&lon=$defaultLon&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final weatherJson = json.decode(response.body);
      setState(() {
        _weather = Weather.fromJson(weatherJson);
        _loading = false;
      });
    } else {
      setState(() {
        _loading = false;
      });
      _showErrorDialog('Gagal mengambil data cuaca');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _onSearch() {
    final city = _controller.text.trim();
    if (city.isNotEmpty) {
      _fetchWeatherByCity(city);
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Cari kota',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _onSearch, child: const Text('Cari')),
              ],
            ),
            const SizedBox(height: 20),
            _loading
                ? const Center(child: CircularProgressIndicator())
                : _weather == null
                ? const Text('Tidak ada data cuaca')
                : Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _weather!.cityName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${_weather!.temperature} °C',
                          style: const TextStyle(fontSize: 48),
                        ),
                        Text(
                          _weather!.description,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        Text('Kelembapan: ${_weather!.humidity}%'),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}