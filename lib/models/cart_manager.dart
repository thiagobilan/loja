import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loja/models/address.dart';
import 'package:loja/models/produto_carrinho.dart';
import 'package:loja/models/produtos.dart';
import 'package:loja/models/user.dart';
import 'package:loja/models/user_manager.dart';
import 'package:loja/services/cepaberto_service.dart';

class CartManager extends ChangeNotifier {
  List<ProdutoCarrinho> items = [];

  User user;
  Address address;

  num productsPrice = 0.0;
  num deliveryPrice;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  num get totalPrice => productsPrice + (deliveryPrice ?? 0);

  final Firestore firestore = Firestore.instance;

  void updateUser(UserManager userManager) {
    user = userManager.user;
    productsPrice = 0.0;
    items.clear();

    if (user != null) {
      _loadCartItems();
      _loadUserAddress();
      removeAddress();
    }
  }

  Future<void> _loadCartItems() async {
    final QuerySnapshot cartSnap = await user.cartReference.getDocuments();
    items = cartSnap.documents
        .map(
            (d) => ProdutoCarrinho.fromDocument(d)..addListener(_atualizarItem))
        .toList();
  }

  Future<void> _loadUserAddress() async {
    if (user.address != null &&
        await calculateDelivery(user.address.lat, user.address.long)) {
      address = user.address;
      notifyListeners();
    }
  }

  void adicionarAoCarrinho(Produto produto) {
    try {
      final e = items.firstWhere((p) => p.estacavel(produto));
      e.incrementar();
    } catch (e) {
      final carrinhoDeProdutos = ProdutoCarrinho.fromProduto(produto);
      carrinhoDeProdutos.addListener(_atualizarItem);
      items.add(carrinhoDeProdutos);
      user.cartReference
          .add(carrinhoDeProdutos.carrinhoParaMap())
          .then((doc) => carrinhoDeProdutos.id = doc.documentID);
      _atualizarItem();
    }
  }

  void _atualizarItem() {
    productsPrice = 0.0;
    for (var i = 0; i < items.length; i++) {
      final produtosCarrinho = items[i];
      if (produtosCarrinho.quantidade == 0) {
        _removerDoCarrinho(produtosCarrinho);
        i--;
        continue;
      }
      productsPrice += produtosCarrinho.totalPrice;
      _atualizarProdutoNoCarrinho(produtosCarrinho);
    }
    notifyListeners();
  }

  void _atualizarProdutoNoCarrinho(ProdutoCarrinho produtoCarinho) {
    if (produtoCarinho.id != null) {
      user.cartReference
          .document(produtoCarinho.id)
          .updateData(produtoCarinho.carrinhoParaMap());
    }
  }

  void _removerDoCarrinho(ProdutoCarrinho produtoCarrinho) {
    items.removeWhere((p) => p.id == produtoCarrinho.id);
    user.cartReference.document(produtoCarrinho.id).delete();
    produtoCarrinho.removeListener(_atualizarItem);
    notifyListeners();
  }

  bool get isCartValid {
    for (final cartProduct in items) {
      if (!cartProduct.hasStock) return false;
    }
    return true;
  }

  bool get isAddressValid => address != null && deliveryPrice != null;

  //ADDRESS
  Future<void> getAddress(String cep) async {
    loading = true;
    final cepAbertoService = CepAbertoService();

    try {
      final cepAberto = await cepAbertoService.getAdressFromCep(cep);
      if (cepAberto != null) {
        address = Address(
          street: cepAberto.logradouro,
          district: cepAberto.bairro,
          zipCode: cepAberto.cep,
          city: cepAberto.cidade.nome,
          state: cepAberto.estado.sigla,
          lat: cepAberto.latitude,
          long: cepAberto.longitude,
        );
        loading = false;
      }
    } catch (e) {
      loading = false;

      return Future.error('Cep Inválido');
    }
  }

  Future<void> setAddress(Address address) async {
    loading = true;
    this.address = address;
    if (await calculateDelivery(address.lat, address.long)) {
      user.setAddress(address);
      loading = false;
    } else {
      loading = false;
      return Future.error('Endereço fora do raio de entrega!');
    }
  }

  Future<bool> calculateDelivery(double lat, double long) async {
    final DocumentSnapshot doc = await firestore.document('aux/delivery').get();
    final latStore = doc.data['lat'] as double;
    final longStore = doc.data['long'] as double;
    final base = doc.data['base'] as num;
    final km = doc.data['km'] as num;
    final maxkm = doc.data['maxkm'] as num;

    double dis = Geolocator.distanceBetween(latStore, longStore, lat, long);
    dis /= 1000;

    if (dis > maxkm) {
      return false;
    }
    deliveryPrice = base + dis * km;
    return true;
  }

  void removeAddress() {
    address = null;
    deliveryPrice = null;
    notifyListeners();
  }
}
