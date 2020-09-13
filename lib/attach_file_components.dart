import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';


class AttachFileBottomSheet extends StatelessWidget {
  const AttachFileBottomSheet({
    Key key,
  }) : super(key: key);

  showFilePicker(FileType fileType) async {
    File file = await FilePicker.getFile(type: fileType);
    //TODO: Send files in the form of messages code.
    // chatBloc.dispatch(SendAttachmentEvent(chat.chatId,file,fileType));
    // Navigator.pop(context);
    // GradientSnackBar.showMessage(context, 'Sending attachment..');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:5.0, bottom: 8.0),
      height: 100.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AttachFileIcon(icon: Icons.image, color: Colors.deepOrange, text: 'Image', onPressed: (){ showFilePicker(FileType.image); }),
          AttachFileIcon(icon: Icons.videocam, color: Colors.blue, text: 'Video', onPressed: (){ showFilePicker(FileType.video); }),
          AttachFileIcon(icon: Icons.insert_drive_file, color: Colors.yellow, text: 'File', onPressed: (){ showFilePicker(FileType.any); }),
        ],
      ),
    );
  }
}


class AttachFileIcon extends StatelessWidget {
  AttachFileIcon({
    @required this.icon, @required this.color, @required this.text, @required this.onPressed
  });
  final IconData icon ;
  final Color color;
  final String text;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(icon: Icon(icon), onPressed: onPressed, color: color, iconSize: 30.0,),
        Text(text, style: TextStyle(color: Colors.blueGrey, fontSize: 16.0),),
      ],
    );
  }
}

