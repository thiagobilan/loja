import 'dart:io';
import 'package:dio/dio.dart';
import 'package:loja/models/cepaberto_address.dart';

const token = '2e672e08b2ed3dd6f4167ca27998cbef';

class CepAbertoService {
  Future<CepAbertoAddress> getAdressFromCep(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endPoint = 'https://www.cepaberto.com/api/v3/cep?cep=$cleanCep';
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Token token=$token';
    try {
      final response = await dio.get<Map<String, dynamic>>(endPoint);
      if (response.data.isEmpty) {
        return Future.error('Cep Inválido');
      }
      final CepAbertoAddress address = CepAbertoAddress.fromMap(response.data);
      return address;
    } on DioError catch (e) {
      return Future.error('Erro ao buscar CEP');
    }
  }
}
