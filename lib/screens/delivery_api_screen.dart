import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:operatorsafe/screens/weather_api_screen.dart';

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  String? streetNumber = '—';
  String? street = '—';
  String? suburb = '—';
  String? city = '—';
  String? country = '—';

  bool isLoading = true;
  String? error;

  final double latitude = -43.5321;
  final double longitude = 172.6362;

  @override
  void initState() {
    super.initState();
    _fetchAddress();
  }

  Future<void> _fetchAddress() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$latitude&lon=$longitude',
    );

    try {
      final response = await http.get(
        url,
        headers: {'User-Agent': 'YourAppName/1.0 (your.email@example.com)'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'] ?? {};

        setState(() {
          streetNumber = address['house_number'] ?? '—';
          street = address['road'] ?? '—';
          suburb = address['suburb'] ?? address['neighbourhood'] ?? '—';
          city =
              address['city'] ?? address['town'] ?? address['village'] ?? '—';
          country = address['country'] ?? '—';
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load address: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Widget buildInputRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(value ?? '—'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMapWidget() {
    return FlutterMap(
      options: MapOptions(center: LatLng(latitude, longitude), zoom: 17.0),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.operatorsafe.deliveryapp',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(latitude, longitude),
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Address')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.8,
                              ),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Map container with its own border & radius inside the card
                                  Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    clipBehavior: Clip.hardEdge,
                                    child: Stack(
                                      children: [
                                        buildMapWidget(),
                                        if (error != null)
                                          Container(
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'Location unavailable',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  buildInputRow('Street Number', streetNumber),
                                  buildInputRow('Street', street),
                                  buildInputRow('Suburb', suburb),
                                  buildInputRow('City', city),
                                  buildInputRow('Country', country),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Back'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                final addressData = {
                                  'streetNumber': streetNumber,
                                  'street': street,
                                  'suburb': suburb,
                                  'city': city,
                                  'country': country,
                                  'latitude': latitude,
                                  'longitude': longitude,
                                };
                                print('Address data: $addressData');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WeatherScreen(),
                                  ),
                                );
                              },
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
}
