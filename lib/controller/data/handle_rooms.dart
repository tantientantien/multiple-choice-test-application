import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_app/model/class/rooms.dart';

class HandleRooms {
  Future<bool> IsRoomExist(TextEditingController room_id) async {
    String roomID = room_id.text.trim();
    if (roomID.isNotEmpty) {
      DocumentSnapshot roomSnapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomID)
          .get();
      if (roomSnapshot.exists) {
        return true;
      }
    }
    return false;
  }

  Future<bool> IsNotOverParticipant(TextEditingController room_id) async {
    String roomID = room_id.text.trim();
    if (roomID.isNotEmpty) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('rooms')
          .doc(roomID)
          .get();
      if (snapshot.exists &&
          snapshot["participants"].length < snapshot["capacity"]) {
        return true;
      }
    }
    return false;
  }

  Future<Rooms> fetchAllRoomInfo(String room_id) async {
    DocumentSnapshot snap =
        await FirebaseFirestore.instance.collection('rooms').doc(room_id).get();
    return Rooms.fromMap(snap.data() as Map<String, dynamic>);
  }

  // Future<void> addRoom() {
  //   CollectionReference room = FirebaseFirestore.instance.collection('room');
  //   return room
  //       .add({
  //         'capacity': int.parse(_capacity.text),
  //         'user_id': FirebaseAuth.instance.currentUser?.uid
  //       })
  //       .then((value) => print("Thêm phòng thành công"))
  //       .onError((error, stackTrace) => print("Thất bại $error"));
  // }
}
