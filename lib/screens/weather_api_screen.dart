import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // Geolocator package
import 'dart:convert';
import 'package:http/http.dart' as http; // HTTP request package
import 'package:geocoding/geocoding.dart'; // Reverse geocoding
import 'package:operatorsafe/screens/lift_configuration_screen.dart';

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

  final List<String> weatherIconNames = [
    'Sunny',
    'Cloudy',
    'Rain',
    'Snow',
    'Thunderstorm',
    'Windy',
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

  String? _localTimeString;
  String? _timeDescriptor;

  // ─────────────────────────────────────────────────────────────
  // SECTION: Offline dropdown selections
  // ─────────────────────────────────────────────────────────────
  String? _offlineWindDesc;
  String? _offlineTempDesc;

  double? latitude;
  double? longitude;

  // ─────────────────────────────────────────────────────────────
  // SECTION: Helper methods
  // ─────────────────────────────────────────────────────────────

  // Helper method to describe temperature
  String _describeTemperature(double temp) {
    if (temp <= 0) {
      return "Freezing";
    } else if (temp > 0 && temp <= 10) {
      return "Cold";
    } else if (temp > 10 && temp <= 20) {
      return "Cool";
    } else if (temp > 20 && temp <= 30) {
      return "Warm";
    } else {
      return "Hot";
    }
  }

  // Helper method to describe precipitation (rain)
  String _describeRain(double rain) {
    if (rain <= 0) {
      return "No rain";
    } else if (rain > 0 && rain <= 2) {
      return "Light rain";
    } else if (rain > 2 && rain <= 10) {
      return "Moderate rain";
    } else if (rain > 10 && rain <= 30) {
      return "Heavy rain";
    } else {
      return "Very heavy rain";
    }
  }

  String _formatLocalTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final ampm = hour >= 12 ? 'PM' : 'AM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $ampm';
  }

  String _getTimeDescriptor(int hour) {
    if (hour >= 5 && hour < 8) return 'Early Morning';
    if (hour >= 8 && hour < 12) return 'Morning';
    if (hour >= 12 && hour < 14) return 'Midday';
    if (hour >= 14 && hour < 17) return 'Afternoon';
    if (hour >= 17 && hour < 20) return 'Evening';
    if (hour >= 20 && hour < 22) return 'Night';
    return 'Late Night';
  }

  // Helper method to describe wind speed
  String _describeWindSpeed(double windSpeed) {
    if (windSpeed <= 0) {
      return "No wind";
    } else if (windSpeed > 0 && windSpeed <= 10) {
      return "Light breeze";
    } else if (windSpeed > 10 && windSpeed <= 30) {
      return "Moderate breeze";
    } else if (windSpeed > 30 && windSpeed <= 50) {
      return "Strong breeze";
    } else if (windSpeed > 50 && windSpeed <= 75) {
      return "Gale";
    } else {
      return "Storm";
    }
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Lifecycle
  // ─────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _offlineWindDesc = "No wind";
    _offlineTempDesc = "Cool";
    _getCurrentLocation();
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

  // ─────────────────────────────────────────────────────────────
  // SECTION: Location & Weather Fetching
  // ─────────────────────────────────────────────────────────────

  Future<void> _getCurrentLocation() async {
    setState(() {
      _loading = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _loading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _loading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });

      if (latitude != null && longitude != null) {
        _fetchWeather(latitude!, longitude!);
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _noInternet = true;
      });
    }
  }

  Future<void> _fetchWeather(double lat, double lon) async {
    setState(() {
      _loading = true;
      _noInternet = false;
    });

    try {
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

      final now = DateTime.now();
      final prefix = now.toIso8601String().substring(0, 13);
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

          _localTimeString = _formatLocalTime(now);
          _timeDescriptor = _getTimeDescriptor(now.hour);

          _loading = false;
        });
      } else {
        setState(() {
          _loading = false;
          _noInternet = true;
        });
      }
    } catch (_) {
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

  // ─────────────────────────────────────────────────────────────
  // SECTION: UI Build
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool showFields = !_loading && !_noInternet;
    final bool showOfflineDropdowns = !_loading && _noInternet;

    return Scaffold(
      appBar: AppBar(title: const Text('Weather Conditions')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: borderRadius,
                            ),
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
                                    child: Column(
                                      children: [
                                        Icon(
                                          weatherIcons[selectedIndex],
                                          size: 80,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          weatherIconNames[selectedIndex],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        if (_localTimeString != null) ...[
                                          const SizedBox(height: 12),
                                          Text(
                                            'Time: $_localTimeString${_timeDescriptor != null ? ' ($_timeDescriptor)' : ''}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Temp: ${_describeTemperature(double.tryParse(_temperatureController.text) ?? 20)} · Wind: ${_describeWindSpeed(double.tryParse(_windSpeedController.text) ?? 0)} · Rain: ${_describeRain(double.tryParse(_precipitationController.text) ?? 0)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.grey[600],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ],
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
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.2)
                                                      : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              weatherIcons[idx],
                                              size: isSel ? 40 : 30,
                                              color:
                                                  isSel
                                                      ? Theme.of(
                                                        context,
                                                      ).primaryColor
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
                                      'Temperature (°C)',
                                      _temperatureController,
                                    ),
                                    _buildField(
                                      'Wind Speed (km/h)',
                                      _windSpeedController,
                                    ),
                                    _buildField(
                                      'Precipitation (mm)',
                                      _precipitationController,
                                    ),
                                    _buildField(
                                      'Humidity (%)',
                                      _humidityController,
                                    ),
                                    _buildField(
                                      'Visibility (km)',
                                      _visibilityController,
                                    ),
                                  ],
                                  if (showOfflineDropdowns) ...[
                                    const SizedBox(height: 24),
                                    _buildWindDropdown(),
                                    const SizedBox(height: 16),
                                    _buildTemperatureDropdown(),
                                  ],
                                  if (_loading) ...[
                                    const SizedBox(height: 24),
                                    const Center(
                                      child: CircularProgressIndicator(),
                                    ),
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
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
                                  'windSpeed':
                                      _noInternet
                                          ? _offlineWindDesc
                                          : _windSpeedController.text,
                                  'temperature':
                                      _noInternet
                                          ? _offlineTempDesc
                                          : _temperatureController.text,
                                  'humidity': _humidityController.text,
                                  'precipitation':
                                      _precipitationController.text,
                                  'visibility': _visibilityController.text,
                                };
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LiftConfigurationScreen(),
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
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildWindDropdown() {
    return DropdownButtonFormField<String>(
      value: _offlineWindDesc,
      items:
          [
                'No wind',
                'Light breeze',
                'Moderate breeze',
                'Strong breeze',
                'Gale',
                'Storm',
              ]
              .map((desc) => DropdownMenuItem(value: desc, child: Text(desc)))
              .toList(),
      onChanged: (val) {
        setState(() {
          _offlineWindDesc = val;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Wind Speed',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildTemperatureDropdown() {
    return DropdownButtonFormField<String>(
      value: _offlineTempDesc,
      items:
          ['Freezing', 'Cold', 'Cool', 'Warm', 'Hot']
              .map((desc) => DropdownMenuItem(value: desc, child: Text(desc)))
              .toList(),
      onChanged: (val) {
        setState(() {
          _offlineTempDesc = val;
        });
      },
      decoration: const InputDecoration(
        labelText: 'Temperature',
        border: OutlineInputBorder(),
      ),
    );
  }
}
