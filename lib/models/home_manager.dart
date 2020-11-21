import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/models/section.dart';

class HomeManager extends ChangeNotifier {
  HomeManager() {
    _loadSections();
  }

  final List<Section> _sections = [];
  List<Section> _editingSections = [];

  bool loading = false;
  bool editing = false;

  final Firestore firestore = Firestore.instance;

  Future<void> _loadSections() async {
    firestore.collection('home').orderBy('pos').snapshots().listen(
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

  // @override
  // void dispose() {
  //   _subscription.cancel();
  //   super.dispose();
  // }

  void enterEditing() {
    editing = true;
    _editingSections = _sections.map((e) => e.clone()).toList();
    notifyListeners();
  }

  Future<void> saveEditing() async {
    //Validação
    bool valid = true;
    for (final section in _editingSections) {
      if (!section.valid()) {
        valid = false;
      }
    }
    if (!valid) {
      return;
    }
    //Salvamento.
    loading = true;
    notifyListeners();
    int pos = 0;
    for (final section in _editingSections) {
      await section.save(pos);
      pos++;
    }

    for (final section in List.from(_sections)) {
      if (!_editingSections.any((element) => element.id == section.id)) {
        await section.delete();
      }
    }

    loading = false;
    editing = false;
    notifyListeners();
  }

  void discartEditing() {
    editing = false;
    notifyListeners();
  }
}
