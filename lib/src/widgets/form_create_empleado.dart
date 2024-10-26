import 'package:flutter/material.dart';
import 'package:servimsa/empleado.dart';
import 'package:servimsa/services/servicio_api.dart';

class EmpleadoCreate extends StatefulWidget {
  @override
  _EmpleadoCreateState createState() => _EmpleadoCreateState();
}

class _EmpleadoCreateState extends State<EmpleadoCreate> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  int id = 0;
  String nombre = '';
  DateTime fechanaci = DateTime.now();
  String correo = '';
  int activo = 1;
  int iddepartamento = 1;

  final TextEditingController _fechaController = TextEditingController();

  final List<Map<String, dynamic>> departamentos = [
    {'label': 'Sistemas', 'value': 1},
    {'label': 'Contabilidad', 'value': 2},
    {'label': 'Almacen', 'value': 3},
    {'label': 'Compras', 'value': 4},
    {'label': 'Comercial', 'value': 5},
    // Agrega más departamentos si es necesario
  ];

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Empleado nuevoEmpleado = Empleado(
        id: 0, // ID será generado por la API
        nombre: nombre,
        fechanaci: fechanaci,
        correo: correo,
        activo: activo,
        id_departamento: iddepartamento,
      );
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
      try {
        await apiService.createEmpleado(nuevoEmpleado);
        Navigator.pop(context); // Cierra el indicador de carga
        Navigator.pop(context); // Regresa a la pantalla anterior
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Empleado creado exitosamente')),
        ); // Regresar a la página anterior
      } catch (e) {
        // Manejar error
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error al crear empleado')));
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fechanaci,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != fechanaci) {
      setState(() {
        fechanaci = picked;
        _fechaController.text =
            "${picked.toLocal()}".split(' ')[0]; // Formato YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Empleado'),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un nombre' : null,
                onSaved: (value) => nombre = value!,
              ),
              TextFormField(
                controller: _fechaController,
                decoration:
                    const InputDecoration(labelText: 'Fecha de Nacimiento'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese una fecha' : null,
                onTap: () => _selectDate(context),
              ),
              TextFormField(
                initialValue: correo,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) =>
                    value!.isEmpty ? 'Ingrese un correo' : null,
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
                decoration: const InputDecoration(labelText: 'Departamento'),
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
                onPressed: _submit,
                child: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
