import 'package:contactappp/models/contact.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbServices {
  static final DbServices _instance = DbServices._init();
  static Database? _database;

  DbServices._init();

  factory DbServices() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("contacts.db");
    return _database!;
  }

  // Initialize database
  Future<Database> _initDB(String dbName) async {
    try {
      String dbpath = await getDatabasesPath();
      String path = join(dbpath, dbName);

      return await openDatabase(
        path,
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE contact(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              firstName TEXT,
              lastName TEXT,
              email TEXT,
              phone TEXT,
              photoUrl TEXT
            )
          ''');
        },
        onUpgrade: (db, oldVersion, newVersion) async {
          if (oldVersion < newVersion) {
            db.execute('''
           INSERT INTO contact (firstName, lastName, email, phone, photoUrl) VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', NULL),
('Jane', 'Smith', 'jane.smith@example.com', '9876543210', NULL),
('Michael', 'Johnson', 'michael.johnson@example.com', '5551234567', NULL),
('Emily', 'Davis', 'emily.davis@example.com', '4449876543', NULL),
('David', 'Brown', 'david.brown@example.com', '3331112222', NULL),
('Sarah', 'Wilson', 'sarah.wilson@example.com', '2223334444', NULL),
('Daniel', 'Taylor', 'daniel.taylor@example.com', '1112223333', NULL),
('Laura', 'Anderson', 'laura.anderson@example.com', '7778889999', NULL),
('Matthew', 'Thomas', 'matthew.thomas@example.com', '6665554444', NULL),
('Sophia', 'Martinez', 'sophia.martinez@example.com', '9990001111', NULL),
('James', 'Garcia', 'james.garcia@example.com', '5554443333', NULL),
('Olivia', 'Rodriguez', 'olivia.rodriguez@example.com', '1231231234', NULL),
('William', 'Martins', 'william.martins@example.com', '3213213210', NULL),
('Isabella', 'Hernandez', 'isabella.hernandez@example.com', '7897897890', NULL),
('Alexander', 'Lopez', 'alexander.lopez@example.com', '1472583690', NULL),
('Mia', 'Gonzalez', 'mia.gonzalez@example.com', '2583691470', NULL),
('Benjamin', 'Perez', 'benjamin.perez@example.com', '3691472580', NULL),
('Charlotte', 'Hall', 'charlotte.hall@example.com', '7418529630', NULL),
('Ethan', 'Young', 'ethan.young@example.com', '8529637410', NULL),
('Amelia', 'Allen', 'amelia.allen@example.com', '9637418520', NULL),
('Henry', 'King', 'henry.king@example.com', '1111111111', NULL),
('Ava', 'Wright', 'ava.wright@example.com', '2222222222', NULL),
('Lucas', 'Scott', 'lucas.scott@example.com', '3333333333', NULL),
('Grace', 'Green', 'grace.green@example.com', '4444444444', NULL),
('Mason', 'Adams', 'mason.adams@example.com', '5555555555', NULL),
('Ella', 'Baker', 'ella.baker@example.com', '6666666666', NULL),
('Logan', 'Nelson', 'logan.nelson@example.com', '7777777777', NULL),
('Chloe', 'Carter', 'chloe.carter@example.com', '8888888888', NULL),
('Sebastian', 'Mitchell', 'sebastian.mitchell@example.com', '9999999999', NULL),
('Lily', 'Perez', 'lily.perez@example.com', '1010101010', NULL),
('Jack', 'Roberts', 'jack.roberts@example.com', '1212121212', NULL),
('Aria', 'Turner', 'aria.turner@example.com', '1313131313', NULL),
('Owen', 'Phillips', 'owen.phillips@example.com', '1414141414', NULL),
('Scarlett', 'Campbell', 'scarlett.campbell@example.com', '1515151515', NULL),
('Elijah', 'Parker', 'elijah.parker@example.com', '1616161616', NULL),
('Victoria', 'Evans', 'victoria.evans@example.com', '1717171717', NULL),
('Jackson', 'Edwards', 'jackson.edwards@example.com', '1818181818', NULL),
('Sofia', 'Collins', 'sofia.collins@example.com', '1919191919', NULL),
('Carter', 'Stewart', 'carter.stewart@example.com', '2020202020', NULL),
('Layla', 'Sanchez', 'layla.sanchez@example.com', '2121212121', NULL),
('Aiden', 'Morris', 'aiden.morris@example.com', '2223232323', NULL),
('Zoe', 'Rogers', 'zoe.rogers@example.com', '2323232323', NULL),
('Grayson', 'Reed', 'grayson.reed@example.com', '2424242424', NULL),
('Hannah', 'Cook', 'hannah.cook@example.com', '2525252525', NULL),
('Levi', 'Morgan', 'levi.morgan@example.com', '2626262626', NULL),
('Nora', 'Bell', 'nora.bell@example.com', '2727272727', NULL),
('Wyatt', 'Murphy', 'wyatt.murphy@example.com', '2828282828', NULL),
('Evelyn', 'Bailey', 'evelyn.bailey@example.com', '2929292929', NULL),
('Dylan', 'Rivera', 'dylan.rivera@example.com', '3030303030', NULL);

           ''');
          }
        },
      );
    } catch (e) {
      print("Database init error: $e");
      rethrow; // propagate DB failure
    }
  }

  // Create another table dynamically
  Future<bool> createTable(String tableName) async {
    try {
      final db = await database;
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $tableName(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          firstName TEXT,
          lastName TEXT,
          email TEXT,
          phone TEXT,
          photoUrl TEXT
        )
      ''');
      return true;
    } catch (e) {
      print("Create table error: $e");
      return false;
    }
  }

  // Insert
  Future<int> insertSingleData(myContactModel con, String tableName) async {
    try {
      final db = await database;
      int res = await db.insert(
        tableName,
        con.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      // print("Insert result: $res");
      return res;
    } catch (e) {
      print("Insert error: $e");
      return -1;
    }
  }

  Future<List<int>> insertMultipleData(
    List<myContactModel> contacts,
    String tableName,
  ) async {
    final db = await database;
    List<int> result = [];
    try {
      for (var item in contacts) {
        int res = await db.insert(
          tableName,
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        result.add(res);
      }
      return result;
    } catch (e) {
      print("Insert error: $e");
      return [];
    }
  }

  // Get all
  Future<List<myContactModel>> getData(String tableName) async {
    try {
      final db = await database;
      final result = await db.query(tableName);
      List<myContactModel> res = result.map((e) => myContactModel.fromMap(e)).toList();
      // for(var item in res) {
      //   print("Fetched contact: ${item.firstName} ${item.lastName}");
      // }
      return res;
    } catch (e) {
      print("Get data error: $e");
      return [];
    }
  }

  // Delete one
  Future<int> deleteRecord(int id, String tableName) async {
    try {
      final db = await database;
      return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Delete record error: $e");
      return -1;
    }
  }

  // Delete all
  Future<int> deleteAllData(String tableName) async {
    try {
      final db = await database;
      return await db.delete(tableName);
    } catch (e) {
      print("Delete all data error: $e");
      return -1;
    }
  }

  // Update
  Future<int> updateData(int id, myContactModel data, String tableName) async {
    try {
      final db = await database;
      return await db.update(
        tableName,
        data.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Update error: $e");
      return -1;
    }
  }

  // Close DB
  Future<bool> closeDatabase() async {
    try {
      final db = await database;
      await db.close();
      _database = null;
      return true;
    } catch (e) {
      print("Close DB error: $e");
      return false;
    }
  }

  Future<myContactModel> getDataById(int id, String tableName) async {
    try {
      final db = await database;
      final result = await db.query(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        return myContactModel.fromMap(result.first);
      } else {
        throw Exception("No contact found with id: $id");
      }
    } catch (e) {
      print("Get data by ID error: $e");
      rethrow; // propagate error
    }
  }

  Future<bool> deleteDb() async {
    try {
      String dbpath = await getDatabasesPath();
      String path = join(dbpath, "contacts.db");
      await deleteDatabase(path);
      _database = null;
      return true;
    } catch (e) {
      print("Delete DB error: $e");
      return false;
    }
  }
}
