import 'package:flutter/material.dart';
import 'package:quick_signature/screens/screen_pad_screen.dart';

void main() {
  runApp(SignatureApp());
}

class SignatureApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signature Pad',
      theme: ThemeData(colorScheme: ColorScheme.light()
          // primarySwatch: Colors.blue,
          ),
      home: SignaturePadScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
