
import 'package:agenda/app/core/database/migrations/migration.dart';
import 'package:sqflite/sqlite_api.dart';

class MigrationV1 implements Migration {

  @override
  void create(Batch batch) {
    batch.execute('''
    CREATE TABLE agenda(
      id INTEGER PRIMARY KEY AUTOINCREMENT
      descricao varchar(500) NOT NULL,
      data_hora DATETIME,
      finalizado INTEGER
    )
    ''');
  }

  @override
  void upgrade(Batch batch) {}
  
}