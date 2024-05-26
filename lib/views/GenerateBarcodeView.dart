import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ViewModels/GenerateBarcodeViewModel.dart';
import '../res/AppColor.dart';
import '../res/AppText.dart';

class GenerateBarcodeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BarcodeViewModel(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColor.primary),
          title: Text(
            'Generate Barcode',
            style: TextStyle(
              color: AppColor.primary,
              fontSize: AppText.HeadingOne.fontSize,
              fontWeight: AppText.HeadingOne.fontWeight,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
          ),
        ),
        body: Consumer<BarcodeViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 301,
                    child: Image.asset('assets/img/barcode.png'), // Placeholder for barcode image
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Choose how many barcode you want to generate',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (viewModel.barcodeCount > 1) {
                                  viewModel.barcodeCount--;
                                }
                              },
                            ),
                            SizedBox(width: 16),
                            Text(
                              '${viewModel.barcodeCount}',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(width: 16),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                viewModel.barcodeCount++;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 50),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColor.primary,
                        minimumSize: Size(204, 55),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(17)),
                      ),
                      onPressed: () {

                      },
                      child: Text('Generate', style: AppText.ButtunText),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
