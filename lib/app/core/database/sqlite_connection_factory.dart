import 'package:agenda/app/core/database/sqlite_migrations_factory.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class SqliteConnectionFactory {
  static SqliteConnectionFactory? _instance;
  static const _version = 1;
  static const _databaseName = 'AGENDA_PROVIDER';

  Database? _db;
  final lock = Lock();

  SqliteConnectionFactory._();

  factory SqliteConnectionFactory() {
    _instance ??= _instance = SqliteConnectionFactory._();

    return _instance!;
  }

  Future<Database> oppenConection() async {
    var databasePath = await getDatabasesPath();
    var databasePahtfinal = join(databasePath, _databaseName);
    if (_db == null) {
      await lock.synchronized(() async {
        _db ??= _db = await openDatabase(
          databasePahtfinal,
          version: _version,
          onConfigure: _onConfigure,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onDowngrade: _onDowngrade
        );
      });
    }

    return _db!;
  }

  void closeConnection() {
    _db?.close();
    _db = null;
  }

  Future<void> _onConfigure(Database db)async{
    await db.execute('PRAGMA foreign_keys = ON');
  }
  Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch();

    final migrations = SqliteMigrationsFactory().getCreateMigration();

    for (var migration in migrations) {
      migration.create(batch);      
    }

    batch.commit();
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int version) async {

    final batch = db.batch();

    final migrations = SqliteMigrationsFactory().getUpgradeMigration(oldVersion);

    for (var migration in migrations) {
      migration.upgrade(batch);      
    }

    batch.commit();
  }
  Future<void> _onDowngrade(Database db, int oldVersion, int version) async {}


}
