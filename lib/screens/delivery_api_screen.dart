import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // For RenderRepaintBoundary
import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:pdf/widgets.dart' as pw; // PDF widgets and Document
import 'package:pdf/pdf.dart'; // PdfPageFormat
import 'package:printing/printing.dart';

import 'package:operatorsafe/screens/weather_api_screen.dart';

/*
  Class widget for handling collecting addresses...
  - reverse geocoding using lat long
  - displays
    -street info
      -fields
    -map
  This is using a free api atm that doesnt related buildings to street addresses, the improve functionality it 
  would be best to seek alternative options.
*/

class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  // ─────────────────────────────────────────────────────────────
  //  SECTION: Widget capture
  // ─────────────────────────────────────────────────────────────
  final GlobalKey _cardKey = GlobalKey();

  // +++++++++++++++++Testing+++++++++++++++++
  Future<void> _exportCardToPdf() async {
    try {
      final RenderRepaintBoundary boundary =
          _cardKey.currentContext?.findRenderObject() as RenderRepaintBoundary;

      if (boundary == null) {
        print('Boundary is null');
        return;
      }

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      final pw.ImageProvider capturedImage = pw.MemoryImage(pngBytes);

      // This is the awaited call that generates and opens the PDF:
      await Printing.layoutPdf(
        format: PdfPageFormat.a4.landscape,
        onLayout: (PdfPageFormat format) async {
          final pdf = pw.Document();

          final double usableWidth = format.availableWidth;
          final double usableHeight = format.availableHeight;

          final double col1Width = usableWidth * 0.25;
          final double col2Width = usableWidth * 0.25;
          final double col3Width = usableWidth * 0.5;

          pdf.addPage(
            pw.Page(
              pageFormat: format,
              build: (context) {
                return pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: col1Width,
                      height: usableHeight,
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Align(
                        alignment: pw.Alignment.topLeft,
                        child: pw.Image(capturedImage, fit: pw.BoxFit.contain),
                      ),
                    ),
                    pw.Container(
                      width: col2Width,
                      height: usableHeight,
                      padding: const pw.EdgeInsets.all(8),
                      color: PdfColors.grey300,
                      child: pw.Text(
                        'Column 2\nExample content...',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ),
                    pw.Container(
                      width: col3Width,
                      height: usableHeight,
                      padding: const pw.EdgeInsets.all(8),
                      color: PdfColors.grey100,
                      child: pw.Text(
                        'Column 3 (half page width)\n\nMore detailed content.',
                        style: const pw.TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                );
              },
            ),
          );

          return pdf.save();
        },
      );
    } catch (e) {
      print('Error exporting card to PDF: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Text Controllers for Input Fields
  // ─────────────────────────────────────────────────────────────
  final TextEditingController streetNumberController = TextEditingController(
    text: '—',
  );
  final TextEditingController streetController = TextEditingController(
    text: '—',
  );
  final TextEditingController suburbController = TextEditingController(
    text: '—',
  );
  final TextEditingController cityController = TextEditingController(text: '—');
  final TextEditingController countryController = TextEditingController(
    text: '—',
  );

  // ─────────────────────────────────────────────────────────────
  // SECTION: Additional State for Refresh
  // ─────────────────────────────────────────────────────────────
  bool _isRefreshingAddress = false;

  // ─────────────────────────────────────────────────────────────
  // SECTION: State Variables
  // ─────────────────────────────────────────────────────────────
  bool isLoading = true;
  String? error;
  double? latitude;
  double? longitude;

  // ─────────────────────────────────────────────────────────────
  // SECTION: Initialization
  // ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Fetch location on load
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Get Current Location
  // ─────────────────────────────────────────────────────────────
  Future<void> _getCurrentLocation() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        error = 'Location services are disabled.';
        isLoading = false;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          error = 'Location permissions are denied';
          isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        error = 'Location permissions are permanently denied';
        isLoading = false;
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
      isLoading = false;
    });

    print("Latitude: $latitude, Longitude: $longitude");

    _fetchAddress(); // Fetch address after location is set
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Fetch Address from OpenStreetMap (Reverse Geocode)
  // ─────────────────────────────────────────────────────────────
  Future<void> _fetchAddress({bool showLoader = false}) async {
    if (latitude == null || longitude == null) {
      setState(() {
        error = 'Latitude or Longitude is null.';
      });
      return;
    }

    if (showLoader) {
      setState(() {
        _isRefreshingAddress = true;
      });
    }

    final url = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=$latitude&lon=$longitude',
    );

    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'OperatorSafeApp/1.0 (support@operatorsafe.com)',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'] ?? {};

        print("Address data: $address");

        setState(() {
          streetNumberController.text = address['house_number'] ?? '';
          streetController.text = address['road'] ?? '';
          suburbController.text =
              address['suburb'] ?? address['neighbourhood'] ?? '';
          cityController.text =
              address['city'] ?? address['town'] ?? address['village'] ?? '';
          countryController.text = address['country'] ?? '';
        });
      } else {
        setState(() {
          error = 'Failed to load address: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error: $e';
      });
    } finally {
      if (showLoader) {
        setState(() {
          _isRefreshingAddress = false;
        });
      }
    }
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Input Field Builder
  // ─────────────────────────────────────────────────────────────
  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: error == null, // Make editable only on error
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter $label',
          border: const OutlineInputBorder(),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 12,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Map Widget
  // ─────────────────────────────────────────────────────────────
  Widget buildMapWidget() {
    if (latitude == null || longitude == null) return const SizedBox();

    return SizedBox(
      height: 180,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: LatLng(latitude!, longitude!),
                zoom: 16.0,
                interactiveFlags:
                    InteractiveFlag.pinchZoom |
                    InteractiveFlag.drag |
                    InteractiveFlag.doubleTapZoom,
                onTap: (tapPosition, point) {
                  setState(() {
                    latitude = point.latitude;
                    longitude = point.longitude;
                  });
                  _fetchAddress(showLoader: true);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.operatorsafe.deliveryapp',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(latitude!, longitude!),
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
            ),
            if (error != null)
              Container(
                color: Colors.black.withOpacity(0.5),
                alignment: Alignment.center,
                child: const Text(
                  'Location unavailable',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Dispose Controllers
  // ─────────────────────────────────────────────────────────────
  @override
  void dispose() {
    streetNumberController.dispose();
    streetController.dispose();
    suburbController.dispose();
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // SECTION: Build UI
  // ─────────────────────────────────────────────────────────────
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 420),
                              child: RepaintBoundary(
                                key: _cardKey,
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        // ───── Title + Refresh Button Row (No Layout Shift) ─────
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Your Location',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 36,
                                              height: 36,
                                              child: Center(
                                                child: AnimatedSwitcher(
                                                  duration: const Duration(
                                                    milliseconds: 200,
                                                  ),
                                                  child:
                                                      _isRefreshingAddress
                                                          ? const SizedBox(
                                                            key: ValueKey(
                                                              'loader',
                                                            ),
                                                            width: 24,
                                                            height: 24,
                                                            child:
                                                                CircularProgressIndicator(
                                                                  strokeWidth:
                                                                      2,
                                                                ),
                                                          )
                                                          : IconButton(
                                                            key: const ValueKey(
                                                              'icon',
                                                            ),
                                                            icon: const Icon(
                                                              Icons.refresh,
                                                            ),
                                                            tooltip:
                                                                'Refresh Address',
                                                            padding:
                                                                EdgeInsets.zero,
                                                            iconSize: 24,
                                                            onPressed: () async {
                                                              await _fetchAddress(
                                                                showLoader:
                                                                    true,
                                                              );
                                                              if (mounted &&
                                                                  error ==
                                                                      null) {
                                                                ScaffoldMessenger.of(
                                                                  context,
                                                                ).showSnackBar(
                                                                  const SnackBar(
                                                                    content: Text(
                                                                      'Address refreshed',
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                            },
                                                          ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        buildMapWidget(),
                                        const SizedBox(height: 16),
                                        buildInputField(
                                          'Street Number',
                                          streetNumberController,
                                        ),
                                        buildInputField(
                                          'Street',
                                          streetController,
                                        ),
                                        buildInputField(
                                          'Suburb',
                                          suburbController,
                                        ),
                                        buildInputField('City', cityController),
                                        buildInputField(
                                          'Country',
                                          countryController,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // ───── Bottom Buttons Row ─────
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
                              onPressed: () {
                                final addressData = {
                                  'streetNumber': streetNumberController.text,
                                  'street': streetController.text,
                                  'suburb': suburbController.text,
                                  'city': cityController.text,
                                  'country': countryController.text,
                                  'latitude': latitude,
                                  'longitude': longitude,
                                };
                                print('Address data: $addressData');

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const WeatherScreen(),
                                  ),
                                );
                              },
                              child: const Text('Next'),
                            ),
                          ),
                          // const SizedBox(width: 12),
                          // Expanded(
                          //   child: ElevatedButton(
                          //     onPressed: _exportCardToPdf,
                          //     child: const Text('Export PDF'),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
        ),
      ),
    );
  }
}
