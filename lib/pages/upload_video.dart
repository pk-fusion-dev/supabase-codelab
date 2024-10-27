import 'dart:async';
// ignore: unused_import
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_lab/network/supabase_service.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
// Provides [VideoController]

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final SupabaseService authService = SupabaseService();
  File? _videoFile;
  bool isLoading = false;
  late Uint8List fileBytes;
  String title = 'Video From Supabase';
  String videoUrl = '';
  //'https://fwvrwhceufgnlvkzxjet.supabase.co/storage/v1/object/public/lab_videos/sample/SampleVideo_720x480_5mb.mp4'; // URL to the video
  String fileInfo = 'Duration: 3:45, Size: 10MB';

  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final _controller = VideoController(player);
  bool showPlayer = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _videoFile = null;
    showPlayer = false;
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      await pickedFile.readAsBytes().then((onValue) {
        fileBytes = onValue;
      });
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    } else {
      Fluttertoast.showToast(
          msg: " No file seleted!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void uploadFile() async {
    isLoading = true;
    await authService.uploadFile(_videoFile!).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value == 'SUCCESS') {
        loadVideo();
        _showSuccessToast();
      } else {
        _showErrorToast();
      }
    });
  }

  void uploadFileProcess() async {
    final uri = Uri.parse(
        'https://fwvrwhceufgnlvkzxjet.supabase.co/storage/v1/object/lab_videos/sample/${_videoFile!.path.split('/').last}');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] =
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZ3dnJ3aGNldWZnbmx2a3p4amV0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjYzODQ4MTIsImV4cCI6MjA0MTk2MDgxMn0.sCw_C0y2AUjxaQWzJlHzDwKqMp0x8O425RZrdvIWkAY';

    int total = _videoFile!.lengthSync();

    request.files.add(http.MultipartFile.fromBytes(
        'file', await _videoFile!.readAsBytes(),
        filename: _videoFile!.path.split('/').last));

/*
    responseStream.listen(
      (streamedResponse) {
        streamedResponse.stream.listen(
          (value) {
            bytesTransferred += value.length;
            setState(() {
              _uploadProgress = bytesTransferred / total;
              dev.log('$_uploadProgress% completed.');
            });
          },
          onDone: () => dev.log('Upload complete!'),
          onError: (e) => dev.log('Error: $e'),
          cancelOnError: true,
        );
      },
    );
    */
    request.send().asStream().listen((response) {
      int bytesSent = 0;
      response.stream.listen((chunk) {
        bytesSent += chunk.length;
        final progress = bytesSent / total;
       
        dev.log(progress.toString());
        setState(() {
          _uploadProgress = progress;
        });
      }, onDone: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Upload Complete')));
      }, onError: (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Upload failed: $e')));
      });
    });
    // await streamedResponse.stream.drain();
  }

  void loadVideo() async {
    await authService.getFilesURL(_videoFile!).then((value) {
      setState(() {
        videoUrl = value!;
        showPlayer = true;
        player.open(Media(videoUrl), play: false);
      });
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

  Widget uploadForm() {
    return Container(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              //backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              minimumSize: const Size(
                  double.infinity, 50), // Set minimum width and height
            ),
            onPressed: _pickVideo,
            child: Text('Pick Video',
                style: Theme.of(context).textTheme.labelMedium),
          ),
          const SizedBox(
            height: 20.0,
          ),
          const SizedBox(
            height: 20.0,
          ),
          if (_videoFile != null) ...[
            Text('Video selected: ${_videoFile!.path.split('/').last}'),
            const SizedBox(
              height: 10.0,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                //backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                minimumSize: const Size(
                    double.infinity, 50), // Set minimum width and height
              ),
              onPressed: () async {
                //uploadFile();
                uploadFileProcess();

                setState(() {
                  isLoading = true;
                });
              },
              child: Text(
                'Upload Video',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
            showPlayer ? videoWidget() : const SizedBox.shrink()
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        uploadForm(),
        isLoading
            ? LinearProgressIndicator(value: _uploadProgress)
            : const SizedBox.shrink(),
      ],
    );
  }

  Widget videoWidget() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          isLoading
              ? const CircularProgressIndicator()
              : const SizedBox.shrink(),
          // Title Row
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          // Video Player Row
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 9.0 / 16.0,
            child: Video(controller: _controller),
          ),
          // File Info Row
        ],
      ),
    );
  }
}
