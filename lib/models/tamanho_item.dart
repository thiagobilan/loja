class TamanhoItem {
  TamanhoItem.fromMap(Map<String, dynamic> map) {
    nome = map['nome'] as String;
    preco = map['preco'] as num;
    quantidade = map['stock'] as int;
  }
  String nome;
  num preco;
  int quantidade;
  bool get temEstoque => quantidade > 0;
}
