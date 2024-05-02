import 'dart:convert';
import 'dart:typed_data';

List<Task> TaskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String TaskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  String? id;
  String Userid;
  String Content;
  String DateCreate;
  String DateDone;
  bool Done;
  bool SentByMe;

  Task({
    this.id,
    required this.Userid,
    required this.DateCreate,
    required this.Content,
    required this.DateDone,
    required this.Done,
    required this.SentByMe,
  });

  Task.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'].toString(),
        Userid = res['Userid'].toString(),
        Content = res['Content'].toString(),
        DateCreate = res['DateCreate'].toString(),
        Done = res['Done'] == true,
        SentByMe = res['SenByMe'] == false,
        DateDone = res['DateDone'].toString();

  Map<String, Object?> toMap() {
    return {
      "id": id,
      "Userid": Userid,
      "DateCreate": DateCreate,
      "Content": Content,
      "DateDone": DateDone,
      "Done": Done,
      "SenByMe": SentByMe,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) => Task(
      id: json["id"],
      Userid: json["Userid"],
      DateCreate: json["DateCreate"],
      Content: json["Content"],
      Done: json['Done'] ?? false,
      SentByMe: json['SenByMe'] ?? false,
      DateDone: json["DateDone"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "Userid": Userid,
        "DateCreate": DateCreate,
        "Content": Content,
        "DateDone": DateDone,
        "SenByMe": SentByMe,
        "Done": Done
      };
  @override
  String toString() {
    return 'Task( id: $id, DateCreate: $DateCreate, Done: $Done, SentByMe: $SentByMe, DateDone: $DateDone, Content: $Content, Userid: $Userid)';
  }
}
