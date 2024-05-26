import 'package:flutter/material.dart';

import '../Services/network_service.dart';

class BarcodeViewModel extends ChangeNotifier {
  final NetworkService _networkService = NetworkService();
  int _barcodeCount = 1;

  int get barcodeCount => _barcodeCount;

  set barcodeCount(int value) {
    _barcodeCount = value;
    notifyListeners();
  }

  Future<void> generateBarcodes() async {
    // Logic to generate and save barcodes in Firestore
    List<Map<String, dynamic>> barcodes = List.generate(_barcodeCount, (index) => {'barcode': '0123456789${index.toString().padLeft(3, '0')}'});
    for (var barcode in barcodes) {
      await _networkService.sendData('barcodes', barcode);
    }
  }
}
