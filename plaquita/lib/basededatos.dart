import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<void> initDatabase() async {
  final Database database = await openDatabase(
    join(await getDatabasesPath(), 'registro_database.db'),
    onCreate: (db, version) {
      return db.execute(
        '''
        CREATE TABLE registros(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nombre TEXT,
          direccion TEXT,
          telefono TEXT,
          marcaAuto TEXT,
          placa TEXT
        )
        ''',
      );
    },
    version: 1,
  );
}

Future<void> insertRegistro(Map<String, dynamic> registro) async {
  final Database database = await openDatabase(
    join(await getDatabasesPath(), 'registro_database.db'),
  );

  await database.insert(
    'registros',
    registro,
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

Future<List<Map<String, dynamic>>> getRegistros() async {
  final Database database = await openDatabase(
    join(await getDatabasesPath(), 'registro_database.db'),
  );

  return await database.query('registros');
}
