import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_lab/network/supabase_service.dart';
import 'package:media_kit/media_kit.dart'; // Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart'; // Provides [VideoController]

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

  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final _controller = VideoController(player);
  bool showPlayer = false;

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
              onPressed: () {
                uploadFile();
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
        isLoading ? const CircularProgressIndicator() : const SizedBox.shrink(),
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
