// lib/widgets/scan_result_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanResultCard extends StatelessWidget {
  final String scannedText;
  final bool isLoading;
  final bool? isSuccess;

  const ScanResultCard({
    super.key,
    required this.scannedText,
    required this.isLoading,
    this.isSuccess,
  });

  bool get _isUrl {
    final uri = Uri.tryParse(scannedText);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isSuccess == null
              ? Colors.grey.shade200
              : isSuccess!
                  ? const Color(0xFF4CAF50).withOpacity(0.4)
                  : const Color(0xFFE53935).withOpacity(0.4),
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _isUrl
                        ? const Color(0xFF1565C0).withOpacity(0.1)
                        : const Color(0xFF37474F).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isUrl ? Icons.link_rounded : Icons.text_fields_rounded,
                        size: 14,
                        color: _isUrl
                            ? const Color(0xFF1565C0)
                            : const Color(0xFF37474F),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isUrl ? 'URL' : 'TEXT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: _isUrl
                              ? const Color(0xFF1565C0)
                              : const Color(0xFF37474F),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Copy button
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: scannedText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Scanned text
            Text(
              scannedText,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A2E),
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),

            // Status row
            Row(
              children: [
                if (isLoading)
                  const Row(
                    children: [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Saving to database...',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1565C0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  )
                else if (isSuccess != null)
                  Row(
                    children: [
                      Icon(
                        isSuccess!
                            ? Icons.check_circle_rounded
                            : Icons.error_rounded,
                        size: 16,
                        color: isSuccess!
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFE53935),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isSuccess! ? 'Saved successfully' : 'Failed to save',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSuccess!
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFE53935),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}