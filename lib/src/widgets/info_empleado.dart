import 'package:flutter/material.dart';
import 'package:servimsa/empleado.dart';
import 'package:servimsa/services/servicio_api.dart';
import 'package:intl/intl.dart';
import 'package:servimsa/src/widgets/form_empleado.dart';

class EmpleadoInfo extends StatefulWidget {
  final Empleado empleado;
  const EmpleadoInfo({super.key, required this.empleado});
  @override
  _EmpleadoInfoState createState() => _EmpleadoInfoState();
}

class _EmpleadoInfoState extends State<EmpleadoInfo> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  late int id;
  late String nombre;
  late DateTime fechanaci;
  late String correo;
  late int activo;
  late int iddepartamento;

  TextEditingController fechanaciController = TextEditingController();

  final List<Map<String, dynamic>> departamentos = [
    {'label': 'Sistemas', 'value': 1},
    {'label': 'Contabilidad', 'value': 2},
    {'label': 'Almacen', 'value': 3},
    {'label': 'Compras', 'value': 4},
    {'label': 'Comercial', 'value': 5},
    // Agrega más departamentos si es necesario
  ];
  String getDepartamentoNombre(int id) {
    final departamento = departamentos.firstWhere((dep) => dep['value'] == id,
        orElse: () => {'label': 'Desconocido'});
    return departamento['label'];
  }

  @override
  void initState() {
    super.initState();
    id = widget.empleado.id;
    nombre = widget.empleado.nombre;
    fechanaci = widget.empleado.fechanaci;
    correo = widget.empleado.correo;
    activo = widget.empleado.activo;
    iddepartamento = widget.empleado.id_departamento;
  }

  void deleteEmpleado() async {
    id = widget.empleado.id;
    try {
      await apiService.deleteEmpleado(id); // Llama a la API para eliminar
      Navigator.pop(context); // Cierra el indicador de carga
      Navigator.pop(context); // Regresa a la pantalla anterior
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Empleado eliminado exitosamente')),
      ); // Regresa a la pantalla anterior
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al eliminar empleado')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información Empleado'),
        leading: Container(),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navega al widget EmpleadoCRUD pasando el empleado actual
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmpleadoCRUD(empleado: widget.empleado),
                ),
              ).then((_) {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Mostrar diálogo de confirmación
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Confirmar eliminación'),
                    content: const Text('¿Deseas eliminar al empleado?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Cierra el diálogo
                        },
                        child: const Text('Cancelar'),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteEmpleado(); // Llama a la función de eliminación
                        },
                        child: const Text('Eliminar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context); // Regresa a la página anterior
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller:
                    TextEditingController(text: id.toString()), // Muestra el ID
                decoration: const InputDecoration(
                  labelText: 'ID',
                  suffixIcon: Icon(Icons.badge),
                ),
                readOnly: true, // Campo solo lectura
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller:
                    TextEditingController(text: nombre), // Muestra el nombre
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  suffixIcon: Icon(Icons.person),
                ),
                readOnly: true, // Campo solo lectura
              ),
              TextField(
                controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd')
                        .format(fechanaci)), // Muestra la fecha
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true, // Campo solo lectura
              ),
              TextField(
                controller:
                    TextEditingController(text: correo), // Muestra el correo
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  suffixIcon: Icon(Icons.email),
                ),
                readOnly: true, // Campo solo lectura
              ),
              const SizedBox(height: 20),
              Text(
                activo == 1 ? 'Activo' : 'Inactivo',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: TextEditingController(
                    text: getDepartamentoNombre(iddepartamento)),
                decoration: const InputDecoration(
                  labelText: 'Departamento',
                  suffixIcon: Icon(Icons.business),
                ),
                readOnly: true, // Campo solo lectura
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Salir'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
