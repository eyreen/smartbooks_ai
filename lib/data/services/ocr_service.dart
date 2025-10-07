import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  static OcrService? _instance;
  static OcrService get instance => _instance ??= OcrService._();

  OcrService._();

  final TextRecognizer _textRecognizer = TextRecognizer();

  Future<String> extractTextFromImage(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      return recognizedText.text;
    } catch (e) {
      throw Exception('Failed to extract text: $e');
    }
  }

  Future<Map<String, String>> extractReceiptData(String imagePath) async {
    try {
      final text = await extractTextFromImage(imagePath);

      // Basic pattern matching for receipt data
      final lines = text.split('\n');
      String? merchant;
      String? date;
      String? total;

      for (var i = 0; i < lines.length; i++) {
        final line = lines[i].trim();

        // Try to find merchant name (usually at the top)
        if (i < 3 && line.isNotEmpty && merchant == null) {
          merchant = line;
        }

        // Try to find date
        if (line.contains(RegExp(r'\d{1,2}[/-]\d{1,2}[/-]\d{2,4}'))) {
          date ??= line;
        }

        // Try to find total amount
        if (line.toLowerCase().contains('total') ||
            line.toLowerCase().contains('amount')) {
          // Extract number from line
          final match = RegExp(r'\d+\.?\d*').firstMatch(line);
          if (match != null) {
            total = match.group(0);
          }
        }
      }

      return {
        'merchant': merchant ?? 'Unknown',
        'date': date ?? DateTime.now().toString(),
        'total': total ?? '0.00',
        'full_text': text,
      };
    } catch (e) {
      throw Exception('Failed to extract receipt data: $e');
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
