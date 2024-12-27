import 'dart:convert';

Rooms roomsFromMap(String str) => Rooms.fromMap(json.decode(str));

String roomsToMap(Rooms data) => json.encode(data.toMap());

class Rooms {
    String roomName;
    String ownerId;
    int capacity;
    String questionSetId;
    List<String> participants;

    Rooms({
       required this.roomName,
       required this.ownerId,
       required this.capacity,
       required this.questionSetId,
       required this.participants,
    });

    factory Rooms.fromMap(Map<String, dynamic> json) => Rooms(
        roomName: json["room_name"],
        ownerId: json["owner_id"],
        capacity: json["capacity"],
        questionSetId: json["question_set_id"],
        participants: List<String>.from(json["participants"].map((x) => x)),
    );

    Map<String, dynamic> toMap() => {
        "room_name": roomName,
        "owner_id": ownerId,
        "capacity": capacity,
        "question_set_id": questionSetId,
        "participants": List<dynamic>.from(participants.map((x) => x)),
    };
}
