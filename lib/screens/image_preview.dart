import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final Uint8List imageData;
  final Function(Uint8List) onEdit;

  ImagePreviewScreen({required this.imageData, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Signature')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                height: 400,
                child: Image.memory(imageData)), // Display the saved image
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onEdit(imageData); // Pass imageData back for editing
                Navigator.pop(context); // Return to the canvas screen
              },
              child: Text('Edit on Canvas'),
            ),
          ],
        ),
      ),
    );
  }
}
