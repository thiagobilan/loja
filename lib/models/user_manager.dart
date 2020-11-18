import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:loja/helpers/firebase_errors.dart';
import 'package:loja/models/user.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Firestore firestore = Firestore.instance;

  User user;
  bool _loading = false;
  bool get loading => _loading;

  Future<void> signIn({User user, Function onFail, Function onSuccess}) async {
    loading = true;
    try {
      final AuthResult result = await auth.signInWithEmailAndPassword(
          email: user.email, password: user.pass);
      await _loadCurrentUser(firebaseUser: result.user);

      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void sair() {
    auth.signOut();
    user = null;
    notifyListeners();
  }

  bool get isLogged => user != null;
  Future<void> criarConta(
      {User usuario, Function onSuccess, Function onFail}) async {
    loading = true;
    try {
      final AuthResult result = await auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.pass);

      usuario.id = result.user.uid;
      user = usuario;

      await usuario.saveData();
      onSuccess();
    } on PlatformException catch (e) {
      onFail(getErrorString(e.code));
    }
    loading = false;
  }

  Future<void> _loadCurrentUser({FirebaseUser firebaseUser}) async {
    final FirebaseUser currentUser = firebaseUser ?? await auth.currentUser();
    if (currentUser != null) {
      final DocumentSnapshot docUsuario = await firestore
          .collection('usuarios')
          .document(currentUser.uid)
          .get();
      user = User.fromDocument(docUsuario);

      final docAdmin =
          await firestore.collection('admins').document(user.id).get();
      if (docAdmin.exists) {
        user.admin = true;
      }
      notifyListeners();
    }
    notifyListeners();
  }

  bool get adminEnabled => user != null && user.admin;
}
