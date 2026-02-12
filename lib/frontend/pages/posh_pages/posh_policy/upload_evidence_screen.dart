import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UploadEvidenceScreen extends StatefulWidget {
  const UploadEvidenceScreen({super.key});

  @override
  State<UploadEvidenceScreen> createState() => _UploadEvidenceScreenState();
}

class _UploadEvidenceScreenState extends State<UploadEvidenceScreen> {
  // Mock list to store "uploaded" files
  final List<String> _selectedFiles = [];

  void _pickFiles() {
    HapticFeedback.lightImpact();
    // In a real app, use: FilePicker.platform.pickFiles()
    setState(() {
      _selectedFiles.add("Evidence_${_selectedFiles.length + 1}.jpg");
    });
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Upload Evidence',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildUploadArea(),
                    if (_selectedFiles.isNotEmpty) _buildFileList(),
                    const SizedBox(height: 32),
                    _buildSecurityInfo(),
                  ],
                ),
              ),
            ),
            _buildActionFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickFiles,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.blue.shade100,
            width: 2,
            style: BorderStyle.solid, // Note: For true dashed lines, use a CustomPainter or 'dotted_border' package
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.cloud_upload_outlined, size: 40, color: Color(0xFF2B67E1)),
            ),
            const SizedBox(height: 16),
            const Text(
              "Tap to upload media",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1A1A1A)),
            ),
            const SizedBox(height: 4),
            Text(
              "Maximum file size: 25MB",
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          "SELECTED FILES (${_selectedFiles.length})",
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1.1),
        ),
        const SizedBox(height: 12),
        ...List.generate(_selectedFiles.length, (index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.insert_drive_file_outlined, color: Colors.blueAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(_selectedFiles[index], style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.redAccent),
                  onPressed: () => _removeFile(index),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSecurityInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Privacy Matters',
          style: TextStyle(fontSize: 22, color: Color(0xFF1A1A1A), fontWeight: FontWeight.w800, letterSpacing: -0.6),
        ),
        const SizedBox(height: 12),
        Text(
          'Your files are encrypted before they reach our servers. Only authorized Internal Committee (IC) members can view this evidence.',
          style: TextStyle(fontSize: 15, height: 1.6, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(Icons.verified_user_rounded, color: Colors.green.shade700, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Compliant with data protection policies.',
                  style: TextStyle(color: Colors.green.shade900, fontWeight: FontWeight.w600, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionFooter(BuildContext context) {
    bool hasFiles = _selectedFiles.isNotEmpty;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 62,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A1A1A),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text(
            hasFiles ? 'Continue with ${ _selectedFiles.length} files' : 'Continue without Evidence',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}