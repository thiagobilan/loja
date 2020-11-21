import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja/models/address.dart';

class User {
  String id;
  String email;
  String pass;
  String nome;
  String validarSenha;
  bool admin = false;
  Address address;
  DocumentReference get firestoreRef =>
      Firestore.instance.document('usuarios/$id');

  CollectionReference get cartReference => firestoreRef.collection('chart');

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
    if (document.data.containsKey('address')) {
      address =
          Address.fromMap(document.data['address'] as Map<String, dynamic>);
    }
  }

  Future<void> saveData() async {
    await firestoreRef.setData(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': nome,
      'email': email,
      'id': id,
      if (address != null) 'address': address.toMap(),
    };
  }

  void setAddress(Address address) {
    this.address = address;
    saveData();
  }
}
