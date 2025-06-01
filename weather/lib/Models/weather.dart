class Weather {
  final double temperature;
  final int humidity;
  final String description;
  final String cityName;

  Weather({
    required this.temperature,
    required this.humidity,
    required this.description,
    required this.cityName,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      humidity: json['main']['humidity'],
      description: json['weather'][0]['description'],
      cityName: json['name'],
    );
  }
}