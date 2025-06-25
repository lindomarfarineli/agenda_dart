
import 'package:agenda/app/core/database/migrations/migration.dart';
import 'package:agenda/app/core/database/migrations/migration_v1.dart';
import 'package:agenda/app/core/database/migrations/migration_v2.dart';

class SqliteMigrationsFactory {

  List<Migration> getCreateMigration() => [
    MigrationV1(),
    MigrationV2()
  ];

   List<Migration> getUpgradeMigration(int version)  {
    final migrations = <Migration>[];

    if(version ==1){
      migrations.add(MigrationV2());
    }

    return migrations;
   }
  
}