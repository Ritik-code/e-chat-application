import 'package:flutter/material.dart';

class AttachFileBottomSheet extends StatefulWidget {
  @override
  _AttachFileBottomSheetState createState() => _AttachFileBottomSheetState();
}

class _AttachFileBottomSheetState extends State<AttachFileBottomSheet> {
  // File _file;
  //
  // Future uploadFile(BuildContext context) async {
  //   String fileName = basename(_file.path);
  //   StorageReference firebaseStorageRef =
  //       FirebaseStorage.instance.ref().child(fileName);
  //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_file);
  //   var dowUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
  //   url = dowUrl.toString();
  //   print(url);
  //   StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
  //   setState(() {
  //     print("Profile Picture uploaded");
  //     // Scaffold.of(context)
  //     //     .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0, bottom: 8.0),
      height: 100.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AttachFileIcon(
              icon: Icons.image,
              color: Colors.deepOrange,
              text: 'Image',
              onPressed: () {
                // showFilePicker(FileType.image);
              }),
          AttachFileIcon(
              icon: Icons.videocam,
              color: Colors.blue,
              text: 'Video',
              onPressed: () {
                // showFilePicker(FileType.video);
              }),
          AttachFileIcon(
              icon: Icons.insert_drive_file,
              color: Colors.yellow,
              text: 'File',
              onPressed: () {
                // showFilePicker(FileType.any);
              }),
        ],
      ),
    );
  }
}

class AttachFileIcon extends StatelessWidget {
  AttachFileIcon(
      {@required this.icon,
      @required this.color,
      @required this.text,
      @required this.onPressed});

  final IconData icon;
  final Color color;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          color: color,
          iconSize: 30.0,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.blueGrey, fontSize: 16.0),
        ),
      ],
    );
  }
}
