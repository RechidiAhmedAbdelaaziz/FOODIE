part of 'qr_service.dart';

class _QRScanScreen extends StatefulWidget {
  const _QRScanScreen();

  @override
  State<_QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<_QRScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: AppColors.green,
          borderRadius: 10.r,
          borderLength: 30.r,
          borderWidth: 10.r,
          cutOutSize: 300.r,
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      if (mounted) {
        Navigator.of(context).pop(scanData.code);
      } // Close the scanner screen
    });
  }
}
