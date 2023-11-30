import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RegistroScreen extends StatefulWidget {
  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController marcaAutoController = TextEditingController();
  final TextEditingController placaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: direccionController,
              decoration: InputDecoration(labelText: 'Dirección'),
            ),
            TextField(
              controller: telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextField(
              controller: marcaAutoController,
              decoration: InputDecoration(labelText: 'Marca del Auto'),
            ),
            TextField(
              controller: placaController,
              decoration: InputDecoration(labelText: 'Placa'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _insertData();
                Navigator.pop(context);
              },
              child: Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _insertData() async {
    final Database database = await openDatabase(
      join(await getDatabasesPath(), 'registro_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE registros(id INTEGER PRIMARY KEY AUTOINCREMENT, nombre TEXT, direccion TEXT, telefono TEXT, marcaAuto TEXT, placa TEXT)',
        );
      },
      version: 1,
    );

    await database.insert(
      'registros',
      {
        'nombre': nombreController.text,
        'direccion': direccionController.text,
        'telefono': telefonoController.text,
        'marcaAuto': marcaAutoController.text,
        'placa': placaController.text,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
