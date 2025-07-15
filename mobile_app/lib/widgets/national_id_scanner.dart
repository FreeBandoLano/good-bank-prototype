import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/auth_service.dart';

class NationalIdScanner extends StatefulWidget {
  const NationalIdScanner({super.key});

  @override
  State<NationalIdScanner> createState() => _NationalIdScannerState();
}

class _NationalIdScannerState extends State<NationalIdScanner> {
  static const MethodChannel _channel = MethodChannel('smartscanner_mrz');
  
  bool _isScanning = false;
  bool _hasPermissions = false;
  String? _statusMessage;
  Map<String, dynamic>? _scanResult;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final cameraStatus = await Permission.camera.request();
    
    setState(() {
      _hasPermissions = cameraStatus.isGranted;
      if (!_hasPermissions) {
        _statusMessage = 'Camera permission required for ID scanning';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan National ID'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthService>(
        builder: (context, authService, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: _hasPermissions 
                      ? _buildScannerInterface(authService)
                      : _buildPermissionRequest(),
                ),
                if (authService.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: CircularProgressIndicator(),
                  ),
                if (authService.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      authService.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_statusMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      _statusMessage!,
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                if (_scanResult != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _buildScanResult(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPermissionRequest() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.camera_alt,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 24),
          const Text(
            'Camera Access Required',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'We need camera access to scan your National ID card.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _checkPermissions,
            child: const Text('Grant Permissions'),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerInterface(AuthService authService) {
    return Column(
      children: [
        // Scanner Preview Area
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: _isScanning 
                ? _buildScanningView()
                : _buildScanPrompt(),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Instructions
        Expanded(
          flex: 1,
          child: Column(
            children: [
              const Text(
                'Position your Barbadian National ID card within the frame',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                children: [
                  _buildScanStepChip('📱 MRZ Scan', _isScanning ? Colors.blue : Colors.grey),
                  _buildScanStepChip('📷 OCR Ready', Colors.grey),
                  _buildScanStepChip('📡 NFC Ready', Colors.grey),
                ],
              ),
            ],
          ),
        ),
        
        // Scan Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: authService.isLoading ? null : _startSmartScannerMRZ,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
            ),
            child: Text(
              _isScanning ? 'Scanning...' : 'Start MRZ Scan',
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Demo/Test Button (for Phase 1 testing)
        TextButton(
          onPressed: authService.isLoading ? null : _simulateSuccessfulScan,
          child: const Text('Use Demo Data (Phase 1 Testing)'),
        ),
      ],
    );
  }

  Widget _buildScanPrompt() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Tap "Start MRZ Scan" to begin',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanningView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 16),
          Text(
            'Scanning MRZ...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanResult() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Scan Result:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text('Name: ${_scanResult!['givenNames']} ${_scanResult!['surname']}'),
          Text('Document: ${_scanResult!['documentNumber']}'),
          Text('Country: ${_scanResult!['issuingCountry']}'),
          Text('DOB: ${_scanResult!['dateOfBirth']}'),
        ],
      ),
    );
  }

  Widget _buildScanStepChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // SmartScanner Core MRZ Scanning via Intent
  Future<void> _startSmartScannerMRZ() async {
    setState(() {
      _isScanning = true;
      _statusMessage = 'Launching SmartScanner...';
    });

    try {
      // Use platform channel to call SmartScanner intent
      final result = await _channel.invokeMethod('scanMRZ');
      
      if (result != null && result is Map) {
        final scanData = Map<String, dynamic>.from(result);
        setState(() {
          _scanResult = scanData;
          _statusMessage = 'Scan successful! Processing data...';
        });
        
        // Process the MRZ data for authentication
        await _processSmartScannerResult(scanData);
      } else {
        setState(() {
          _statusMessage = 'Scan cancelled or failed';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error: $e';
      });
      
      // Fallback to demo data if SmartScanner not available
      await _simulateSuccessfulScan();
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _processSmartScannerResult(Map<String, dynamic> result) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    // Extract data from SmartScanner MRZ result
    String? firstName = result['givenNames'];
    String? lastName = result['surname'];
    String? documentNumber = result['documentNumber'];
    String? dobString = result['dateOfBirth'];
    
    DateTime? dateOfBirth;
    if (dobString != null) {
      // Parse date from YYMMDD format to DateTime
      try {
        final year = int.parse(dobString.substring(0, 2));
        final month = int.parse(dobString.substring(2, 4));
        final day = int.parse(dobString.substring(4, 6));
        
        // Assume 20xx for years 00-30, 19xx for years 31-99
        final fullYear = year <= 30 ? 2000 + year : 1900 + year;
        
        dateOfBirth = DateTime(fullYear, month, day);
      } catch (e) {
        print('Error parsing date: $e');
      }
    }

    if (firstName != null && lastName != null && documentNumber != null && dateOfBirth != null) {
      final success = await authService.signInWithNationalId(
        nationalId: documentNumber,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
      );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      setState(() {
        _statusMessage = 'Invalid scan data. Please try again.';
      });
    }
  }

  Future<void> _simulateSuccessfulScan() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    // Demo data for Phase 1 testing
    final success = await authService.signInWithNationalId(
      nationalId: 'BB123456789',
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: DateTime(1995, 5, 15),
      photoUrl: null, // No photo for demo user
    );

    if (success && mounted) {
      // Navigate to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _isScanning = false;
        _statusMessage = 'Authentication failed. Please try again.';
      });
    }
  }
} 