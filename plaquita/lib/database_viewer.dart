import 'package:flutter/material.dart';
import 'basededatos.dart';

class DatabaseViewerScreen extends StatelessWidget {
  Future<List<Map<String, dynamic>>> _getDatabaseRecords() async {
    // Inicializa la base de datos antes de obtener los registros
    await initDatabase();

    final List<Map<String, dynamic>> records = await getRegistros();
    return records;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Visualización de la Base de Datos'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getDatabaseRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final List<Map<String, dynamic>>? records = snapshot.data;

            if (records == null || records.isEmpty) {
              return Center(
                child: Text('No hay registros en la base de datos.'),
              );
            }

            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                return ListTile(
                  title: Text(record['nombre'] ?? ''),
                  subtitle: Text(record['placa'] ?? ''),
                );
              },
            );
          }
        },
      ),
    );
  }
}
