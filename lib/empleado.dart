class Empleado {
  final int id;
  final String nombre;
  final DateTime fechanaci;
  final String correo;
  final int activo;
  final int id_departamento;
  const Empleado({
    required this.id,
    required this.nombre,
    required this.fechanaci,
    required this.correo,
    required this.activo,
    required this.id_departamento,
  });

  factory Empleado.fromJson(Map<String, dynamic> json) {
    return Empleado(
        id: json['id'],
        nombre: json['nombre'],
        fechanaci: DateTime.parse(json['fechanaci']),
        correo: json['correo'],
        activo: json['activo'],
        id_departamento: json['id_departamento']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'fechanaci': fechanaci.toIso8601String(),
      'correo': correo,
      'activo': activo,
      'id_departamento': id_departamento,
    };
  }
}
