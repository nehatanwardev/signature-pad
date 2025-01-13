import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quick_signature/screens/image_preview.dart';
import 'package:quick_signature/widgets/custom_button.dart';
import 'package:quick_signature/widgets/pen_width_dropdown.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'dart:html' as html;

class SignaturePadScreen extends StatefulWidget {
  @override
  _SignaturePadScreenState createState() => _SignaturePadScreenState();
}

class _SignaturePadScreenState extends State<SignaturePadScreen> {
  final _signatureKey = GlobalKey<SignatureState>();
  final ScreenshotController _screenshotController = ScreenshotController();
  Color penColor = Colors.black;
  Color canvasColor = Colors.white;
  double penWidth = 5.0;
  Uint8List? savedSignature;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signature Pad',
          style: TextStyle(
              fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: MouseRegion(
        onEnter: (_) {
          SystemMouseCursors.click;
        },
        onExit: (_) {
          // Reset cursor when mouse leaves the signature pad area
          SystemMouseCursors.basic;
        },
        child: Column(
          children: [
            Expanded(
              child: Screenshot(
                controller: _screenshotController,
                child: Container(
                  decoration: BoxDecoration(
                    color: canvasColor,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Stack(
                    children: [
                      // Show the saved signature as background if available
                      if (savedSignature != null)
                        Image.memory(
                          savedSignature!,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      // Signature drawing area
                      Signature(
                        color: penColor,
                        strokeWidth: penWidth,
                        key: _signatureKey,
                      ),
                    ],
                  ),
                ),
              ),

              // child: Screenshot(
              //   controller: _screenshotController,
              //   child: Container(
              //     decoration: BoxDecoration(
              //       color: canvasColor,
              //       border: Border.all(color: Colors.black, width: 2),
              //     ),
              //     width: 700,
              //     child: Signature(
              //       color: penColor,
              //       strokeWidth: penWidth,
              //       key: _signatureKey,
              //     ),
              //   ),
              // ),
            ),
            SizedBox(height: 20),
            _buildRow(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  onPressed: () => _showColorPicker(isPenColor: false),
                  label: 'Canvas Color',
                  color: Colors.purple, // Custom color for the Clear button
                ),
                CustomButton(
                  onPressed: () => _showColorPicker(isPenColor: true),
                  label: 'Pen Color',
                  color: Colors.pink, // Custom color for the Clear button
                ),
                PenWidthDropdown(
                  penWidth: penWidth,
                  onChanged: (value) {
                    if (value != null) _setPenWidth(value);
                  },
                )
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  _buildRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CustomButton(
          onPressed: _clearSignature,
          label: 'Clear',
          color: Colors.red, // Custom color for the Clear button
        ),
        CustomButton(
          onPressed: _saveSignature,
          label: 'Save & Download',
          color: Colors.green,
        ),
        CustomButton(
          onPressed: _retrieveSavedSignature,
          label: 'Retrieve Saved',
          color: Colors.orangeAccent,
        ),
      ],
    );
  }

// Future<void> _loadSavedImage() async {
  //   try {
  //     // Retrieve the base64 image string from localStorage
  //     String? base64Image = html.window.localStorage['saved_signature'];

  //     if (base64Image != null) {
  //       Uint8List imageData = base64Decode(base64Image);
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => ImagePreviewScreen(
  //             imageData: imageData,
  //             onEdit: (Uint8List editedImage) {
  //               setState(() {
  //                 savedSignature =
  //                     editedImage; // Set the edited image as the new signature
  //               });
  //             },
  //           ),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('No saved signature found!')),
  //       );
  //     }
  //   } catch (e) {
  //     print('Error loading image: $e');
  //   }
  // }

  Future<void> _saveSignature() async {
    final image = await _screenshotController.capture();
    if (image != null) {
      String timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_'); // Format timestamp
      String fileName = 'signature_$timestamp.png';

      if (kIsWeb) {
        final base64Image = base64Encode(image);
        html.window.localStorage['saved_signature'] = base64Image;
        final blob = html.Blob([image]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..target = 'blank'
          ..download = fileName
          ..click();
        html.Url.revokeObjectUrl(url);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/$fileName';
        final file = File(imagePath);
        await file.writeAsBytes(image);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signature saved at $imagePath')),
        );
      }
    }
  }

  void _clearSignature() {
    _signatureKey.currentState?.clear();
    canvasColor = Colors.white;
    savedSignature = null; // S
    setState(() {});
  }

  Future<void> _retrieveSavedSignature() async {
    if (kIsWeb) {
      final base64Image = html.window.localStorage['saved_signature'];
      if (base64Image != null) {
        setState(() {
          savedSignature = base64Decode(base64Image);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No saved signature to retrieve!')),
        );
      }
    } else {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/signature.png';
        final file = File(imagePath);
        if (await file.exists()) {
          final signatureBytes = await file.readAsBytes();
          setState(() {
            savedSignature = signatureBytes;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No saved signature to retrieve!')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error retrieving signature: $e')),
        );
      }
    }
  }

  void _showColorPicker({required bool isPenColor}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isPenColor ? 'Pick Pen Color' : 'Pick Canvas Background'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: isPenColor ? penColor : canvasColor,
            onColorChanged: (color) {
              setState(() {
                if (isPenColor) {
                  penColor = color;
                } else {
                  canvasColor = color;
                }
              });
            },
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Select'),
          ),
        ],
      ),
    );
  }

  void _setPenWidth(double width) {
    setState(() {
      penWidth = width;
    });
  }
}
