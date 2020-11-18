class SectionItem {
  SectionItem({this.imagem, this.produto});
  dynamic imagem;
  String produto;

  SectionItem.fromMap(Map<String, dynamic> map) {
    imagem = map['image'] as String;
    produto = map['product'] as String;
  }

  @override
  String toString() {
    return 'SectionItem{ image: $imagem, Produto $produto }';
  }

  SectionItem clone() {
    return SectionItem(
      imagem: imagem,
      produto: produto,
    );
  }
}
