import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// A plug-and-play service for running TFLite image classification.
///
/// Usage:
/// ```dart
/// final service = TfliteService();
/// await service.init();
///
/// final results = await service.recognize(imageFile);
/// // or with a rank limit:
/// final top3 = await service.recognize(imageFile, topK: 3);
///
/// // results → [ {'name': 'cat', 'confidence': 0.92}, ... ]
///
/// service.dispose();
/// ```
class TfliteService {
  // ── Config ─────────────────────────────────────────────────────────────────

  /// Path to the .tflite model inside your assets folder.
  final String modelPath;

  /// Path to the labels text file inside your assets folder (one label/line).
  final String labelsPath;

  /// The width/height the model expects (e.g. MobileNet → 224).
  final int inputSize;

  /// Pixel normalization mode.
  final NormalizationMode normalization;

  // ── Internal ───────────────────────────────────────────────────────────────
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isInitialized = false;

  // ── Constructor ────────────────────────────────────────────────────────────
  TfliteService({
    this.modelPath = 'assets/models/model.tflite',
    this.labelsPath = 'assets/models/labels.txt',
    this.inputSize = 224,
    this.normalization = NormalizationMode.zeroToOne,
  });

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Call once before using [recognize] — loads the model and labels.
  Future<void> init() async {
    if (_isInitialized) return;

    _interpreter = await Interpreter.fromAsset(modelPath);

    final raw = await rootBundle.loadString(labelsPath);
    _labels = raw
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    _isInitialized = true;
  }

  /// Runs inference on [imageFile] and returns a ranked list of predictions.
  ///
  /// - [topK] — how many results to return (default: 5, pass null for all).
  ///
  /// Each map contains:
  /// ```
  /// {
  ///   'name':       String  — label name,
  ///   'confidence': double  — score between 0.0 and 1.0,
  /// }
  /// ```
  Future<List<Map<String, dynamic>>> recognize(
    File imageFile, {
    int? topK = 5,
  }) async {
    _assertInitialized();

    // 1. Decode & resize image to [inputSize × inputSize]
    final imageBytes = await imageFile.readAsBytes();
    final codec = await instantiateImageCodec(
      imageBytes,
      targetWidth: inputSize,
      targetHeight: inputSize,
    );
    final frame = await codec.getNextFrame();
    final byteData =
        await frame.image.toByteData(format: ImageByteFormat.rawRgba);
    frame.image.dispose();

    if (byteData == null) throw TfliteServiceException('Failed to decode image.');

    // 2. Build input tensor  [1, inputSize, inputSize, 3]
    final input = _buildInputTensor(byteData);

    // 3. Run inference
    final numLabels = _labels.length;
    final outputBuffer =
        List.filled(numLabels, 0.0).reshape([1, numLabels]);

    _interpreter!.run(input, outputBuffer);

    final scores = List<double>.from(outputBuffer[0] as List);

    // 4. Sort → take topK → return as List<Map>
    return _buildResults(scores, topK: topK);
  }

  /// Free the interpreter. Call when the service is no longer needed.
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isInitialized = false;
  }

  bool get isInitialized => _isInitialized;

  // ── Private helpers ────────────────────────────────────────────────────────

  List<List<List<List<double>>>> _buildInputTensor(ByteData byteData) {
    final bytes = byteData.buffer.asUint8List();

    return List.generate(1, (_) {
      return List.generate(inputSize, (y) {
        return List.generate(inputSize, (x) {
          final i = (y * inputSize + x) * 4; // RGBA
          final r = _normalize(bytes[i]);
          final g = _normalize(bytes[i + 1]);
          final b = _normalize(bytes[i + 2]);
          return [r, g, b];
        });
      });
    });
  }

  double _normalize(int value) {
    switch (normalization) {
      case NormalizationMode.zeroToOne:
        // [0, 255] → [0.0, 1.0]
        return value / 255.0;
      case NormalizationMode.minusOneToOne:
        // [0, 255] → [-1.0, 1.0]  (used by MobileNetV2 etc.)
        return (value / 127.5) - 1.0;
    }
  }

  List<Map<String, dynamic>> _buildResults(
    List<double> scores, {
    int? topK,
  }) {
    // Pair each score with its label index, sort descending
    final indexed = scores
        .asMap()
        .entries
        .where((e) => e.key < _labels.length)
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Apply rank limit
    final limited = topK != null ? indexed.take(topK) : indexed;

    return limited
        .map((e) => {
              'name': _labels[e.key],
              'confidence': e.value.clamp(0.0, 1.0),
            })
        .toList();
  }

  void _assertInitialized() {
    if (!_isInitialized) {
      throw TfliteServiceException(
          'TfliteService is not initialized. Call init() first.');
    }
  }
}

// ── Enums & Exceptions ────────────────────────────────────────────────────────

/// How pixel values [0–255] are normalized before feeding the model.
enum NormalizationMode {
  /// Output range [0.0, 1.0] — works for most models.
  zeroToOne,

  /// Output range [-1.0, 1.0] — required by MobileNetV2, EfficientNet, etc.
  minusOneToOne,
}

class TfliteServiceException implements Exception {
  final String message;
  TfliteServiceException(this.message);

  @override
  String toString() => 'TfliteServiceException: $message';
}