import 'package:cloud_firestore/cloud_firestore.dart';


class Database{
  Map<String, dynamic> chatRoom;

  chatRoomInfo(List<String> users, String chatRoomId){

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId": chatRoomId,
    };

    Firestore.instance
        .collection("chatRoom")
        .document(chatRoomId)
        .setData(chatRoom)
        .catchError((e) {
      print(e);
    });
  }
}