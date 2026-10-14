import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PickedDocument {
  const PickedDocument({required this.name, required this.text});
  final String name;
  final String text;
}

/// Lets the user pick a PDF and extracts its text on the device.
/// Limits: 5 MB file, 30,000 characters.
/// Works across Web, Windows, macOS, Android, and iOS.
class DocumentPicker {
  static const int maxBytes = 5 * 1024 * 1024;
  static const int maxCharacters = 30000;

  /// Returns null if the user cancels. Throws [FormatException] for bad files.
  static Future<PickedDocument?> pickPdf() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
    if (files.isEmpty) return null;

    final file = files.single;
    final bytes = await file.readAsBytes();

    if (bytes.isEmpty) {
      throw const FormatException('Could not read the selected file.');
    }
    if (bytes.length > maxBytes) {
      throw const FormatException('That PDF is larger than 5 MB.');
    }

    final document = PdfDocument(inputBytes: bytes);
    try {
      final text = PdfTextExtractor(document).extractText().trim();
      if (text.isEmpty) {
        throw const FormatException(
            'No readable text found. Scanned PDFs need image OCR first.');
      }
      return PickedDocument(
        name: file.name,
        text: text.length > maxCharacters ? text.substring(0, maxCharacters) : text,
      );
    } finally {
      document.dispose();
    }
  }
}

