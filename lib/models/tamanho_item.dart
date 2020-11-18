class TamanhoItem {
  TamanhoItem({this.nome, this.preco, this.quantidade});
  TamanhoItem.fromMap(Map<String, dynamic> map) {
    nome = map['nome'] as String;
    preco = map['preco'] as num;
    quantidade = map['stock'] as int;
  }
  String nome;
  num preco;
  int quantidade;
  bool get temEstoque => quantidade > 0;

  @override
  String toString() {
    // TODO: implement toString
    return 'Nome: $nome, Preço: $preco';
  }

  TamanhoItem clone() {
    return TamanhoItem(
      nome: nome,
      preco: preco,
      quantidade: quantidade,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'preco': preco,
      'stock': quantidade,
    };
  }
}
