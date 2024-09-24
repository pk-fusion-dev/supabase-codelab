import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_lab/network/supabase_service.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final SupabaseService authService = SupabaseService();
  File? _videoFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _videoFile = null;
  }

  Future<void> _pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    } else {
      Fluttertoast.showToast(
          msg: " No Video!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void uploadFile(File file) async {
    await authService.uploadFile(_videoFile!).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value == 'SUCCESS') {
        _showSuccessToast();
      } else {
        _showErrorToast();
      }
    });
  }

  void _showSuccessToast() {
    Fluttertoast.showToast(
        msg: " Upload Completed.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _showErrorToast() {
    Fluttertoast.showToast(
        msg: " Upload Fail.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_videoFile != null) ...[
            Text('Video selected: ${_videoFile!.path.split('/').last}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                uploadFile(_videoFile!);
                setState(() {
                  isLoading = true;
                });
              },
              child: const Text('Upload Video'),
            ),
          ],
          if (isLoading) const Center(child: CircularProgressIndicator()),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickVideo,
            child: const Text('Pick Video'),
          ),
        ],
      ),
    );
  }
}
