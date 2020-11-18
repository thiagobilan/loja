import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:loja/models/produtos.dart';

class ProductManager extends ChangeNotifier {
  final Firestore firestore = Firestore.instance;
  List<Produto> todosProdutos = [];
  String _search = '';
  set search(String value) {
    _search = value;
    notifyListeners();
  }

  String get search => _search;

  ProductManager() {
    _loadAllProdutos();
  }

  List<Produto> get produtosFiltrados {
    final List<Produto> produtosFiltrados = [];
    if (search.isEmpty) {
      produtosFiltrados.addAll(todosProdutos);
    } else {
      produtosFiltrados.addAll(
        todosProdutos.where(
          (p) => p.nome.toLowerCase().contains(
                search.toLowerCase(),
              ),
        ),
      );
    }
    return produtosFiltrados;
  }

  Future<void> _loadAllProdutos() async {
    final QuerySnapshot snapProdutos =
        await firestore.collection('produtos').getDocuments();

    todosProdutos =
        snapProdutos.documents.map((e) => Produto.fromDocument(e)).toList();
    notifyListeners();
  }

  Produto findProductById(String id) {
    try {
      return todosProdutos.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void update(Produto product) {
    todosProdutos.removeWhere((p) => p.id == product.id);
    todosProdutos.add(product);
    notifyListeners();
  }
}
