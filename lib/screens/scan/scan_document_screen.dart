import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/transaction_provider.dart';
import '../../data/services/ocr_service.dart';
import '../../data/services/ai_service.dart';
import '../../data/models/transaction_model.dart';
import '../transactions/add_transaction_screen.dart';

class ScanDocumentScreen extends StatefulWidget {
  const ScanDocumentScreen({super.key});

  @override
  State<ScanDocumentScreen> createState() => _ScanDocumentScreenState();
}

class _ScanDocumentScreenState extends State<ScanDocumentScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;
  String? _status;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        await _processImage(image.path);
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }

  Future<void> _processImage(String imagePath) async {
    if (!mounted) return;

    setState(() {
      _isProcessing = true;
      _status = 'Extracting text from image...';
    });

    try {
      // Step 1: OCR - Extract text
      final ocrService = OcrService.instance;
      final extractedText = await ocrService.extractTextFromImage(imagePath);

      if (!mounted) return;
      setState(() {
        _status = 'Analyzing document with AI...';
      });

      // Step 2: AI Analysis - Parse the extracted text
      final aiService = AiService.instance;
      final analysisResult = await aiService.analyzeDocumentWithGPT(
        extractedText: extractedText,
        documentType: 'receipt',
      );

      if (!mounted) return;
      setState(() {
        _status = 'Creating transaction...';
      });

      // Step 3: Parse AI response and create transaction
      final data = jsonDecode(analysisResult);

      final transaction = TransactionModel.create(
        userId:
            '00000000-0000-0000-0000-000000000000', // Replace with actual user ID from auth
        title: data['merchant'] ?? 'Unknown Merchant',
        amount: double.tryParse(data['amount'].toString()) ?? 0.0,
        category: data['category'] ?? 'Other',
        type: TransactionType.expense,
        date: DateTime.tryParse(data['date']) ?? DateTime.now(),
        description: data['items']?.join(', ') ?? '',
        isAiGenerated: true,
      );

      // Step 4: Save transaction
      if (mounted) {
        await Provider.of<TransactionProvider>(context, listen: false)
            .addTransaction(transaction);

        // Show success and go back
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaction added successfully!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      _showError('Failed to process document: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _status = null;
        });
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      setState(() {
        _isProcessing = false;
        _status = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Scan Document'),
      ),
      body: _isProcessing
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    _status ?? 'Processing...',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.document_scanner,
                    size: 100,
                    color: AppTheme.primaryColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Scan Receipt or Invoice',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'AI will automatically extract merchant, amount, date, and category from your document',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  _buildOptionCard(
                    context,
                    icon: Icons.camera_alt,
                    title: 'Take Photo',
                    subtitle: 'Use camera to capture document',
                    onTap: () => _pickImage(ImageSource.camera),
                  ),
                  const SizedBox(height: 16),
                  _buildOptionCard(
                    context,
                    icon: Icons.photo_library,
                    title: 'Choose from Gallery',
                    subtitle: 'Select existing photo',
                    onTap: () => _pickImage(ImageSource.gallery),
                  ),
                  const SizedBox(height: 32),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddTransactionScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Or enter manually'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.primaryColor,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}
