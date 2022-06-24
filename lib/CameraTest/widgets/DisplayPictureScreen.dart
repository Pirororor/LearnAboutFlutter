import 'dart:io';

import 'package:flutter/material.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final void Function() onBack;
  final void Function(String imagePath) onSave;

  const DisplayPictureScreen(
      {super.key,
      required this.imagePath,
      required this.onBack,
      required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Image.file(File(imagePath)),
        floatingActionButton:
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
              onPressed: onBack, child: const Icon(Icons.arrow_back)),
          FloatingActionButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    void closeDialog() {
                      Navigator.pop(context, false);
                    }

                    return AlertDialog(
                        title: const Text('Save this image to gallery?'),
                        actions: [
                          TextButton(
                              onPressed: closeDialog,
                              child: const Text('Cancel')),
                          TextButton(
                              onPressed: () {
                                onSave(imagePath);
                                closeDialog();
                              },
                              child: const Text('Ok'))
                        ]);
                  }),
              child: const Icon(Icons.save))
        ]));
  }
}
