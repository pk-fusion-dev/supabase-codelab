import 'package:flutter/material.dart';

class VideoContent extends StatefulWidget {
  const VideoContent({super.key});

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 350,
        width: 400,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Personalia',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Column(
            children: [
              const Row(
                children: [
                  Text('First name:'),
                  SizedBox(
                      width: 200,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(),
                      ))
                ],
              ),
              const Row(
                children: [
                  Text('Last name:'),
                  SizedBox(
                      width: 200,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(),
                      ))
                ],
              ),
              const Row(
                children: [
                  Text('Email:'),
                  SizedBox(
                      width: 200,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(),
                      ))
                ],
              ),
              const Row(
                children: [
                  Text('Birthday:'),
                  SizedBox(
                      width: 200,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          decoration:
                              InputDecoration(hintText: 'dd / mm / yyyy'),
                        ),
                      ))
                ],
              ),
              Align(
                  alignment: Alignment.centerLeft,
                  child:
                      TextButton(onPressed: () {}, child: const Text('Submit')))
            ],
          ),
        ),
      ),
    );
  }
}
