import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  String? description;
  DateTime? datetime;
  List<String> tags;
  bool done = false;
  bool canceled = false;

  Task({String? uuid, required this.title, this.description, this.datetime, this.tags = const [], this.done = false, this.canceled = false})
      : id = uuid ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'datetime': datetime == null ? null : DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(datetime!),
    'tags': tags.join(', '),
    'done': done,
    'canceled': canceled,
  };

  factory Task.fromJson(Map<String, dynamic> responseData) {
    // List<String> tagListStr = (responseData['tags'] ?? '').toString().split(',');

    return Task(
      uuid: responseData['id'],
      title: responseData['title'],
      description: responseData['description'],
      // datetime: responseData['datetime'].toString().fromTimeStamp,
      datetime: DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(responseData['datetime']),
      tags: (responseData['tags'] ?? '').toString().split(','),
      done: responseData['done'],
      canceled: responseData['canceled'],
    );
  }
}