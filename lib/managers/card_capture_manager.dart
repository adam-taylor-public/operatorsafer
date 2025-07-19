import 'dart:typed_data';

/// ─────────────────────────────────────────────────────────────
/// ABSTRACT BASE: Defines what a "capture" should be able to do
/// ─────────────────────────────────────────────────────────────
abstract class CardCapture {
  void capture(); // e.g., take a screenshot or snapshot
  Uint8List? getCapturedImage(); // returns the image bytes
}

/// ─────────────────────────────────────────────────────────────
/// SINGLETON MANAGER: Manages all card captures across the app
/// ─────────────────────────────────────────────────────────────
class CardCaptureManager {
  // Private constructor
  CardCaptureManager._internal();

  // Singleton instance
  static final CardCaptureManager _instance = CardCaptureManager._internal();

  // Public accessor
  factory CardCaptureManager() => _instance;

  // Stores registered card captures using a unique key per screen
  final Map<String, CardCapture> _registeredCaptures = {};

  // Register a capture instance by screen or identifier key
  void registerCapture(String key, CardCapture capture) {
    _registeredCaptures[key] = capture;
  }

  // Retrieve a specific capture instance by key
  CardCapture? getCapture(String key) => _registeredCaptures[key];

  // Collect all available captured images
  List<Uint8List> exportAllCapturedImages() {
    return _registeredCaptures.values
        .map((capture) => capture.getCapturedImage())
        .whereType<Uint8List>()
        .toList();
  }

  // Optional: Clear all registered captures
  void clear() {
    _registeredCaptures.clear();
  }
}
