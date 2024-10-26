import 'dart:convert';
import 'package:http/http.dart' as http;
import '../empleado.dart';

class ApiService {
  //final String baseUrl ='http://10.0.2.2:8000/ServimsaLaravel/public/api/empleados';
  final String baseUrl = 'http://10.0.2.2:8000/api/empleados';

  Future<List<Empleado>> fetchEmpleados() async {
    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<dynamic> empleadosJson = jsonResponse['data'];
      return empleadosJson
          .map((empleado) => Empleado.fromJson(empleado))
          .toList();
    } else {
      throw Exception('Error al Obtener Empleado');
    }
  }

  Future<Empleado> createEmpleado(Empleado empleado) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(empleado.toJson()),
    );

    if (response.statusCode == 201) {
      return Empleado.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al Crear Empleado');
    }
  }

  Future<Empleado> updateEmpleado(Empleado empleado) async {
    http.Response response = await http.put(
      Uri.parse('$baseUrl/${empleado.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(empleado.toJson()),
    );

    if (response.statusCode == 200) {
      return Empleado.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al Actualizar Empleado');
    }
  }

  Future<void> deleteEmpleado(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Error al Eliminar Empleado: ${response.body}');
    }
  }
}
