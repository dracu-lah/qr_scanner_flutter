import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  String? code;
  List<String> qrCodes = <String>[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "QR Scanner",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: qrCodes.isEmpty
          ? Container(
              alignment: Alignment.center,
              child: const Text("Scan For Listing Qr codes"))
          : qrList(),
      bottomNavigationBar: ElevatedButton(
          onPressed: () {
            _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                context: context,
                onCode: (code) {
                  setState(() {
                    qrCodes.add(code.toString());
                  });
                });
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.all(16),
              shape: const LinearBorder()),
          child: const Icon(
            Icons.qr_code_scanner_outlined,
            color: Colors.white,
          )),
    );
  }

  ListView qrList() {
    return ListView.separated(
        separatorBuilder: (BuildContext context, index) => const SizedBox(
              height: 10,
            ),
        padding: const EdgeInsets.all(8),
        itemCount: qrCodes.length,
        itemBuilder: (BuildContext context, int index) {
          return ElevatedButton(
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(20)),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: qrCodes[index])).then(
                  (value) =>
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          'Text Copied To Clipboard',
                          style: TextStyle(color: Colors.black),
                        ),
                      )));
            },
            child: Text(qrCodes[index]),
          );
        });
  }
}
