import 'dart:convert';
import 'dart:typed_data';

List<Note> TaskFromJson(String str) =>
    List<Note>.from(json.decode(str).map((x) => Note.fromJson(x)));

String NoteToJson(List<Note> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Note {
  String? id;
  String Userid;
  String Name;
  String Content;
  String DateCreate;
  String DateDone;
  String Receiver;

  Note(
      {this.id,
      required this.Name,
      required this.Userid,
      required this.DateCreate,
      required this.Content,
      required this.DateDone,
      required this.Receiver});

  Note.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        Userid = res['Userid'],
        Name = res['Name'] ?? "",
        Content = res['Content'] ?? "",
        DateCreate = res['DateCreate'] ?? "",
        DateDone = res['DateDone'] ?? "",
        Receiver = res['Receiver'] ?? "";

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "Name": Name,
      "Userid": Userid,
      "DateCreate": DateCreate,
      "Content": Content,
      "DateDone": DateDone,
      "Receiver": Receiver
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) => Note(
      id: json["id"],
      Name: json["Name"],
      Userid: json["Userid"],
      DateCreate: json["DateCreate"],
      DateDone: json["Datedone"],
      Receiver: json["Receiver"],
      Content: json["Content"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "Name": Name,
        "Userid": Userid,
        "DateCreate": DateCreate,
        "DateDone": DateDone,
        "Receiver": Receiver,
        "Content": Content,
      };
  @override
  String toString() {
    return 'Note(Name: $Name, id: $id, Receiver: $Receiver,  DateCreate: $DateCreate, DateDone: $DateDone, Content: $Content, Userid: $Userid)';
  }
}
