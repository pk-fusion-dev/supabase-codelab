
import 'package:byte_converter/byte_converter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_lab/network/supabase_service.dart';

class VideoContent extends StatefulWidget {
  const VideoContent({super.key});

  @override
  State<VideoContent> createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  final SupabaseService _authService = SupabaseService();
  List<FileObject> fileList = List.empty();
  bool isLoading = false;
  @override
  initState() {
    super.initState();
    loadFilesList();
  }

  void loadFilesList() async {
    isLoading = true;
    await _authService.getFilesInBucket().then((value) => {
          setState(() {
            fileList = value;
            isLoading = false;
          })
        });
  }

  void deleteFile(String fileName) async {
    await _authService.deleteFile(fileName).then((value) {
      setState(() {
        isLoading = false;
      });
      if (value == 'SUCCESS') {
        loadFilesList();
      } else {}
    });
  }

  Widget getfileCard(FileObject file) {
    int size = (file.metadata?['size']);
    ByteConverter converter = ByteConverter(size.toDouble());
    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.ondemand_video,
        ),
        title: Text(' ${file.name}'),
        subtitle:
            Text('${converter.megaBytes} Mb ${file.metadata?['mimetype']} '),
        trailing: CircleAvatar(
          backgroundColor: Colors.blueAccent,
          radius: 12,
          child: InkWell(
            child: const Icon(
              Icons.delete_sharp,
              color: Colors.white,
              size: 15,
            ),
            onTap: () {
              deleteFile(file.name);
              Fluttertoast.showToast(
                  msg: " ${file.name} is deleted.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white,
                  fontSize: 16.0);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: fileList.length,
              itemBuilder: (context, index) => getfileCard(fileList[index]),
            ),
    );
  }
}
