import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/models/section.dart';

class HomeManager extends ChangeNotifier {
  StreamSubscription _subscription;
  HomeManager() {
    _loadSections();
  }

  List<Section> _sections = [];
  List<Section> _editingSections = [];

  bool editing = false;

  final Firestore firestore = Firestore.instance;

  Future<void> _loadSections() async {
    _subscription = firestore.collection('home').snapshots().listen(
      (snapshot) {
        _sections.clear();
        for (final DocumentSnapshot document in snapshot.documents) {
          _sections.add(Section.fromDocuiment(document));
        }
        notifyListeners();
      },
    );
  }

  void addSection(Section section) {
    _editingSections.add(section);
    notifyListeners();
  }

  void removeSection(Section section) {
    _editingSections.remove(section);
    notifyListeners();
  }

  List<Section> get sections {
    if (editing) {
      return _editingSections;
    } else {
      return _sections;
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void enterEditing() {
    editing = true;
    _editingSections = _sections.map((e) => e.clone()).toList();
    notifyListeners();
  }

  void saveEditing() {
    editing = false;
    notifyListeners();
  }

  void discartEditing() {
    editing = false;
    notifyListeners();
  }
}
