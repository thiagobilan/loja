class SectionItem {
  SectionItem.fromMap(Map<String, dynamic> map) {
    imagem = map['image'] as String;
    produto = map['product'] as String;
  }
  String imagem;
  String produto;

  @override
  String toString() {
    return 'SectionItem{ image: $imagem, Produto $produto }';
  }
}
