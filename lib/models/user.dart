import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String email;
  String pass;
  String nome;
  String validarSenha;

  DocumentReference get firestoreRef =>
      Firestore.instance.document('usuarios/$id');

  User({
    this.id,
    this.email,
    this.pass,
    this.nome,
  });

  User.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    nome = document.data['name'] as String;
    email = document.data['email'] as String;
  }

  Future<void> saveData() async {
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': nome,
      'email': email,
      'id': id,
    };
  }
}
