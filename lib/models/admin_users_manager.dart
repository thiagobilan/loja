import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/models/user.dart';
import 'package:loja/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier {
  StreamSubscription _subscription;
  final Firestore firestore = Firestore.instance;
  List<User> users = [];
  void updateUser(UserManager userManager) {
    _subscription?.cancel();
    if (userManager.adminEnabled) {
      _listenToUsers();
    } else {
      users.clear();
      notifyListeners();
    }
  }

  void _listenToUsers() {
    _subscription =
        firestore.collection('usuarios').snapshots().listen((value) {
      users = value.documents.map((e) => User.fromDocument(e)).toList();
      users.sort(
        (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()),
      );
      notifyListeners();
    });
  }

  List<String> get names => users.map((e) => e.nome).toList();

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
