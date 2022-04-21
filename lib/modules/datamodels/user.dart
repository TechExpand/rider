import 'package:firebase_database/firebase_database.dart';

class UserP {
  late final fullName;
  late final  email;
  late final   phone;
  late final   id;

  UserP({
    this.email,
    this.fullName,
    this.phone,
    this.id,
  });
  UserP.fromSnapshot(snapshot) {
    id = snapshot.key;
    Map val = snapshot.value;
    phone = val['phone'];
    email = val['email'];
    fullName = val['fullname'];
  }
}
