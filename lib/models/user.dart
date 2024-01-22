import 'package:uuid/uuid.dart';

class User {
  String id;
  String? email;

  User({String? uuid, required this.email})
      : id = uuid ?? const Uuid().v1();
}
