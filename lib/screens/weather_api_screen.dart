import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:operatorsafe/screens/sling_configuration_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final borderRadius = BorderRadius.circular(16);

  final List<IconData> weatherIcons = [
    Icons.wb_sunny, // Sunny
    Icons.cloud, // Cloudy
    Icons.grain, // Rain
    Icons.ac_unit, // Snow
    Icons.flash_on, // Thunderstorm
    Icons.wind_power, // Windy/Fog/Drizzle
  ];

  int selectedIndex = 0;

  final _windSpeedController = TextEditingController(text: '0');
  final _temperatureController = TextEditingController(text: '20');
  final _humidityController = TextEditingController(text: '50');
  final _precipitationController = TextEditingController(text: '0');
  final _visibilityController = TextEditingController(text: '10');

  String? _locationName;
  bool _loading = true;
  bool _noInternet = false;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() {
      _loading = true;
      _noInternet = false;
    });

    const double lat = -43.5321, lon = 172.6362;
    try {
      // Optional: reverse-geocode for display
      List<Placemark> marks = await placemarkFromCoordinates(lat, lon);
      if (marks.isNotEmpty) {
        final p = marks.first;
        final city =
            p.locality ?? p.subAdministrativeArea ?? p.administrativeArea ?? '';
        final country = p.country ?? '';
        _locationName = city.isNotEmpty ? '$city, $country' : country;
      }

      final uri = Uri.parse(
        'https://api.open-meteo.com/v1/forecast'
        '?latitude=$lat'
        '&longitude=$lon'
        '&current_weather=true'
        '&hourly=relative_humidity_2m,precipitation,visibility'
        '&timezone=auto',
      );

      final resp = await http.get(uri).timeout(const Duration(seconds: 5));
      if (resp.statusCode != 200) throw 'HTTP ${resp.statusCode}';
      final data = jsonDecode(resp.body);

      final cur = data['current_weather'];
      final hourly = data['hourly'];
      final times = List<String>.from(hourly['time'] ?? []);

      final prefix = DateTime.now().toIso8601String().substring(0, 13);
      final idx = times.indexWhere((t) => t.startsWith(prefix));

      if (cur != null && idx != -1) {
        final double temp = (cur['temperature'] as num).toDouble();
        final double wind = (cur['windspeed'] as num).toDouble();
        final int code = cur['weathercode'] as int;
        final double hum =
            (hourly['relative_humidity_2m'][idx] as num).toDouble();
        final double prec = (hourly['precipitation'][idx] as num).toDouble();
        final num rawVis = hourly['visibility'][idx] as num;
        final double vis = rawVis.toDouble() / 1000;

        setState(() {
          _temperatureController.text = temp.toStringAsFixed(1);
          _windSpeedController.text = wind.toStringAsFixed(1);
          _humidityController.text = hum.toStringAsFixed(0);
          _precipitationController.text = prec.toStringAsFixed(1);
          _visibilityController.text = vis.toStringAsFixed(1);
          selectedIndex = _mapWeatherCodeToIconIndex(code);
          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _noInternet = true;
        });
      }
    } catch (_) {
      // No internet or API failed
      setState(() {
        _loading = false;
        _noInternet = true;
      });
    }
  }

  int _mapWeatherCodeToIconIndex(int code) {
    if (code == 0) return 0;
    if ([1, 2, 3].contains(code)) return 1;
    if ([61, 63, 65, 80, 81, 82].contains(code)) return 2;
    if ([71, 73, 75].contains(code)) return 3;
    if (code == 95) return 4;
    return 5;
  }

  @override
  void dispose() {
    _windSpeedController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _precipitationController.dispose();
    _visibilityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showFields = !_loading && !_noInternet;

    return Scaffold(
      appBar: AppBar(title: const Text('Weather Conditions')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: borderRadius),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Weather${_locationName != null ? ' · $_locationName' : ''}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Icon(
                            weatherIcons[selectedIndex],
                            size: 80,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 60,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: weatherIcons.length,
                            separatorBuilder:
                                (_, __) => const SizedBox(width: 12),
                            itemBuilder: (ctx, idx) {
                              final isSel = idx == selectedIndex;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = idx;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        isSel
                                            ? Theme.of(
                                              context,
                                            ).primaryColor.withOpacity(0.2)
                                            : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    weatherIcons[idx],
                                    size: isSel ? 40 : 30,
                                    color:
                                        isSel
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey[600],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        if (showFields) ...[
                          const SizedBox(height: 24),
                          _buildField(
                            'Wind Speed (km/h)',
                            _windSpeedController,
                          ),
                          _buildField(
                            'Temperature (°C)',
                            _temperatureController,
                          ),
                          _buildField('Humidity (%)', _humidityController),
                          _buildField(
                            'Precipitation (mm)',
                            _precipitationController,
                          ),
                          _buildField('Visibility (km)', _visibilityController),
                        ],
                        if (_loading) ...[
                          const SizedBox(height: 24),
                          const Center(child: CircularProgressIndicator()),
                        ] else if (_noInternet) ...[
                          const SizedBox(height: 12),
                          const Text(
                            'No internet – please select icon manually',
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed:
                            (!_loading && (!_noInternet || selectedIndex != 0))
                                ? () {
                                  final weatherData = {
                                    'selectedWeather': selectedIndex,
                                    'windSpeed': _windSpeedController.text,
                                    'temperature': _temperatureController.text,
                                    'humidity': _humidityController.text,
                                    'precipitation':
                                        _precipitationController.text,
                                    'visibility': _visibilityController.text,
                                  };
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => SlingConfigurationScreen(),
                                      settings: RouteSettings(
                                        arguments: weatherData,
                                      ),
                                    ),
                                  );
                                }
                                : null,
                        child: const Text('Next'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}
