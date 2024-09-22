import 'package:flutter/material.dart';

class VideoContent extends StatefulWidget {
  const VideoContent({super.key});

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Video Cntent'),
    );
  }
}
