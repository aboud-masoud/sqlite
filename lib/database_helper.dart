import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<sql.Database> _db() async {
    return sql.openDatabase(
      'nabindhakal.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
      },
    );
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DatabaseHelper._db();
    return db.query('items', orderBy: "id");
  }

  // Create new item
  static Future<void> createItem(String? title, String? descrption) async {
    final db = await DatabaseHelper._db();

    final data = {'title': title, 'description': descrption};
    await db.insert('items', data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String title, String? descrption) async {
    final db = await DatabaseHelper._db();

    final data = {'title': title, 'description': descrption, 'createdAt': DateTime.now().toString()};

    final result = await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await DatabaseHelper._db();

    await db.delete("items", where: "id = ?", whereArgs: [id]);
  }
}
