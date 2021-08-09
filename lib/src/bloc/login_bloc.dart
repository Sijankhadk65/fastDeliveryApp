import 'dart:io';

import 'package:fastdeliveryapp/src/models/user.dart';
import 'package:fastdeliveryapp/src/resources/repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  final _repo = Repository();

  final BehaviorSubject<String> _emailSubject = BehaviorSubject<String>();
  Stream<String> get email => _emailSubject.stream;
  Function(String) get changeEmail => _emailSubject.sink.add;

  final BehaviorSubject<String> _passwordSubject = BehaviorSubject<String>();
  Stream<String> get password => _passwordSubject.stream;
  Function(String) get changePassword => _passwordSubject.sink.add;

  Stream<bool> canLogin() => Rx.combineLatest2(email, password, (a, b) => true);

  Future<AuthResult> login() async {
    var token = await FirebaseMessaging().getToken();
    _repo.loginIn(_emailSubject.value, _passwordSubject.value);
    await _repo.saveToken(
      _emailSubject.value,
      {
        "token": token,
        "createdAt": DateTime.now(),
        "platfrom": Platform.operatingSystem,
      },
    );
  }

  Future<void> get logout => _repo.logOut();

  Stream<User> getUser(String email) => _repo.getUser(email);
  Stream<FirebaseUser> getCurrentUser() => _repo.getCurrentUser();
  Stream<String> getUserRole(String email) => _repo.getUserRole(email);
  dispose() {
    _emailSubject.close();
    _passwordSubject.close();
  }
}
