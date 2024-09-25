import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_lab/network/supabase_service.dart';
import 'package:video_player/video_player.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({super.key});

  @override
  State<UploadVideo> createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  final SupabaseService authService = SupabaseService();
  File? _videoFile;
  bool isLoading = false;

  String title = 'Video From Supabase';
  String videoUrl = '';
  //'https://fwvrwhceufgnlvkzxjet.supabase.co/storage/v1/object/public/lab_videos/sample/SampleVideo_720x480_5mb.mp4'; // URL to the video
  String fileInfo = 'Duration: 3:45, Size: 10MB';
  late VideoPlayerController _controller;
  bool showPlayer = false;

  @override
  void initState() {
    super.initState();
    _videoFile = null;
    showPlayer = false;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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

  void loadVideo() async {
    await authService.getFilesURL(_videoFile!).then((value) {
      setState(() {
        videoUrl = value!;
        showPlayer = true;
        _controller = VideoPlayerController.networkUrl(Uri.parse(videoUrl))
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          });
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ElevatedButton(
            onPressed: _pickVideo,
            child: const Text('Pick Video'),
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
              onPressed: () {
                uploadFile();
                setState(() {
                  isLoading = true;
                });
              },
              child: const Text('Upload Video'),
            ),
            showPlayer ? videoWidget() : const SizedBox.shrink()
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return uploadForm();
  }

  Widget videoWidget() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          // Video Player Row
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _controller.value.isInitialized
                ? VideoPlayer(_controller)
                : const Center(child: CircularProgressIndicator()),
          ),
          // File Info Row
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _controller.value.isPlaying
                      ? _controller.pause()
                      : _controller.play();
                });
              },
              child: Text(
                _controller.value.isPlaying ? 'Pause' : 'Play',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
