import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/models/tamanho_item.dart';
import 'package:uuid/uuid.dart';

class Produto extends ChangeNotifier {
  Produto({this.id, this.nome, this.descricao, this.images, this.tamanhos}) {
    images = images ?? [];
    tamanhos = tamanhos ?? [];
  }
  Produto.fromDocument(DocumentSnapshot document) {
    id = document.documentID;
    nome = document['nome'] as String;
    images = List<String>.from(document.data['imgs'] as List<dynamic>);
    descricao = document['descricao'] as String;
    tamanhos = (document.data['sizes'] as List<dynamic> ?? [])
        .map((s) => TamanhoItem.fromMap(s as Map<String, dynamic>))
        .toList();
  }
  bool _loading = false;
  final Firestore firestore = Firestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  DocumentReference get firestoreRef => firestore.document('produtos/$id');
  StorageReference get storageRef => storage.ref().child('products').child(id);
  String id;
  String nome;
  String descricao;
  List<String> images;
  List<TamanhoItem> tamanhos;
  List<dynamic> newImages;
  TamanhoItem _tamanhoSelecionado;

  TamanhoItem get tamanhoSelecionado => _tamanhoSelecionado;
  set tamanhoSelecionado(TamanhoItem tamanho) {
    if (tamanho == _tamanhoSelecionado) {
      _tamanhoSelecionado = null;
    } else {
      _tamanhoSelecionado = tamanho;
    }
    notifyListeners();
  }

  int get estoqueTotal {
    int estoque = 0;
    for (final tamanho in tamanhos) {
      estoque += tamanho.quantidade;
    }
    return estoque;
  }

  bool get temEstoque => estoqueTotal > 0;

  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  TamanhoItem findSize(String nome) {
    try {
      return tamanhos.firstWhere((element) => element.nome == nome);
    } catch (e) {
      return null;
    }
  }

  num get menorPreco {
    num preco = double.infinity;
    for (final tamanho in tamanhos) {
      if (tamanho.preco < preco && tamanho.temEstoque) {
        preco = tamanho.preco;
      }
    }
    return preco;
  }

  Produto clone() {
    return Produto(
      id: id,
      nome: nome,
      descricao: descricao,
      images: List.from(images),
      tamanhos: tamanhos.map((size) => size.clone()).toList(),
    );
  }

  List<Map<String, dynamic>> exportSizeList() {
    return tamanhos.map((size) => size.toMap()).toList();
  }

  Future<void> save() async {
    loading = true;
    final Map<String, dynamic> data = {
      'nome': nome,
      'descricao': descricao,
      'sizes': exportSizeList(),
    };

    if (id == null) {
      final doc = await firestore.collection('produtos').add(data);
      id = doc.documentID;
    } else {
      await firestoreRef.updateData(data);
    }
    final List<String> updateImages = [];
    for (final newImages in newImages) {
      if (images.contains(newImages)) {
        updateImages.add(newImages as String);
      } else {
        final StorageUploadTask task =
            storageRef.child(Uuid().v1()).putFile(newImages as File);
        final StorageTaskSnapshot snapshot = await task.onComplete;
        final String url = await snapshot.ref.getDownloadURL() as String;
        updateImages.add(url);
      }
    }
    for (final image in images) {
      if (!newImages.contains(image)) {
        try {
          final ref = await storage.getReferenceFromUrl(image);
          ref.delete();
        } catch (e) {
          // TODO
          debugPrint('Fala ao Deletar $image');
        }
      }
    }
    firestoreRef.updateData({'imgs': updateImages});
    images = updateImages;
    loading = false;
  }
}
