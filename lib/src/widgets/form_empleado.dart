import 'package:flutter/material.dart';
import 'package:servimsa/empleado.dart';
import 'package:servimsa/services/servicio_api.dart';
import 'package:intl/intl.dart';
import 'package:servimsa/src/pages/HomeEmpleado.dart';

class EmpleadoCRUD extends StatefulWidget {
  final Empleado empleado;
  const EmpleadoCRUD({super.key, required this.empleado});
  @override
  _EmpleadoCRUDState createState() => _EmpleadoCRUDState();
}

class _EmpleadoCRUDState extends State<EmpleadoCRUD> {
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

  void updateEmpleado() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      Empleado empleado = Empleado(
        id: id,
        nombre: nombre,
        fechanaci: fechanaci, //DateTime
        correo: correo,
        activo: activo,
        id_departamento: iddepartamento,
      );
      try {
        await apiService.updateEmpleado(empleado);
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomeEmpleado()), // Cambia por la ruta a HomeEmpleado
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado actualizado exitosamente')),
        );
      } catch (e) {
        Navigator.pop(context); // Cierra el indicador de carga
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al actualizar empleado')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Empleado'),
        leading: Container(),
        actions: [
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
              TextFormField(
                initialValue: nombre,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  suffixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un nombre';
                  }
                  return null;
                },
                onSaved: (value) => nombre = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Fecha de Nacimiento',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  DateTime validDate = fechanaci.isBefore(DateTime(1900, 1, 1))
                      ? DateTime
                          .now() // Cambiar a la fecha actual si es muy antigua
                      : fechanaci; // Cierra el teclado
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: validDate, // Inicializa con la fecha actual
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );

                  if (pickedDate != null) {
                    setState(() {
                      fechanaci =
                          pickedDate; // Asigna directamente como DateTime
                    });
                  }
                },
                readOnly: true, // Evitar teclado
                controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd')
                        .format(fechanaci)), // Mostrar fecha
              ),
              TextFormField(
                initialValue: correo,
                decoration: const InputDecoration(
                  labelText: 'Correo',
                  suffixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un correo';
                  }
                  return null;
                },
                onSaved: (value) => correo = value!,
              ),
              SwitchListTile(
                title: Text(activo == 1 ? 'Activo' : 'Inactivo'),
                value: activo == 1,
                onChanged: (value) {
                  setState(() {
                    activo = value ? 1 : 0;
                  });
                },
              ),
              DropdownButtonFormField<int>(
                value: iddepartamento,
                decoration: const InputDecoration(
                  labelText: 'Departamento',
                  suffixIcon: Icon(Icons.business),
                ),
                items: departamentos.map((departamento) {
                  return DropdownMenuItem<int>(
                    value: departamento['value'],
                    child: Text(departamento['label']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    iddepartamento = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un departamento';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateEmpleado,
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
