import 'package:flutter/material.dart';
import 'package:servimsa/empleado.dart';
import 'package:servimsa/services/servicio_api.dart';
import 'package:servimsa/src/widgets/info_empleado.dart';
import 'package:servimsa/src/widgets/form_create_empleado.dart';

class HomeEmpleado extends StatefulWidget {
  const HomeEmpleado({super.key});

  @override
  State<HomeEmpleado> createState() => _HomeEmpleadoState();
}

class _HomeEmpleadoState extends State<HomeEmpleado> {
  late Future<List<Empleado>> empleados;
  final ApiService apiService = ApiService();
  List<Empleado> empleadosFiltrados = []; // Lista filtrada
  String query = '';

  @override
  void initState() {
    super.initState();
    empleados = apiService.fetchEmpleados();
  }

  Future<void> fetchEmpleados() async {
    empleados = apiService.fetchEmpleados(); // Llamar a la API
    empleados.then((empleadosList) {
      setState(() {
        empleadosFiltrados = empleadosList; // Guardar la lista completa
      });
    });
  }

  void filterEmpleados(String query) {
    setState(() {
      this.query = query; // Actualiza el estado del query
    });

    if (query.isEmpty) {
      fetchEmpleados(); // Si el campo está vacío, recargar todos los empleados
      return;
    }

    empleados.then((empleadosList) {
      final filteredList = empleadosList.where((empleado) {
        //return empleado.nombre.toLowerCase().contains(query.toLowerCase());
        return empleado.id
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();

      setState(() {
        empleadosFiltrados = filteredList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text('App de Empleados Servimsa'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: filterEmpleados,
              decoration: const InputDecoration(
                labelText: 'Buscar empleados por ID',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Empleado>>(
              future: empleados,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No hay empleados disponibles.'));
                }
                final displayedList =
                    query.isEmpty ? empleadosFiltrados : empleadosFiltrados;
                return ListView.builder(
                  itemCount: displayedList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(displayedList[index].nombre),
                      subtitle: Text('ID: ${displayedList[index].id}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.info),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmpleadoInfo(
                                  empleado: displayedList[
                                      index]), // Navega a EmpleadoCRUD
                            ),
                          ).then((_) {
                            fetchEmpleados(); // Actualiza la lista de empleados al regresar, si es necesario
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmpleadoCreate(), // Navega al formulario
            ),
          ).then((_) {
            fetchEmpleados(); // Actualiza la lista de empleados al regresar
          });
        },
        child: const Icon(Icons.person_add), // Ícono para agregar empleado
        tooltip: 'Agregar Empleado', // Tooltip para describir la acción
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
