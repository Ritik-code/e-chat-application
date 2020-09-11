import 'package:flutter/material.dart';



class AttachFileBottomSheet extends StatelessWidget {
  const AttachFileBottomSheet({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top:5.0, bottom: 8.0),
      height: 100.0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AttachFileIcon(icon: Icons.image, color: Colors.deepOrange, text: 'Image',),
          AttachFileIcon(icon: Icons.videocam, color: Colors.blue, text: 'Video',),
          AttachFileIcon(icon: Icons.insert_drive_file, color: Colors.yellow, text: 'File',),
        ],
      ),
    );
  }
}


class AttachFileIcon extends StatelessWidget {
  AttachFileIcon({
    @required this.icon, @required this.color, @required this.text
  });
  final IconData icon ;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(icon: Icon(icon), onPressed: (){}, color: color, iconSize: 30.0,),
        Text(text, style: TextStyle(color: Colors.blueGrey, fontSize: 16.0),),
      ],
    );
  }
}
