import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:retailappcount/models/masterdata.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  DatabaseProvider._();

  static final DatabaseProvider db = DatabaseProvider._();
  Database _database;
  List<Zona_Field> listg = new List<Zona_Field>();

  //para evitar que abra varias conexciones una y otra vez podemos usar algo como esto..
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await getDatabaseInstanace();
    return _database;
  }

  Future<Database> getDatabaseInstanace() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "data.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Material ("
          "material varchar(18) primary key,"
          "name TEXT,"
          "color TEXT,"
          "talla TEXT,"
          "bar_code TEXT,"
          "depto TEXT,"
          "mvgr1 TEXT,"
          "cantidad TEXT)  ");
      await db.execute("CREATE TABLE Zona ("
          "id integer ,"
          "zona varchar(18)  ,"
          "material varchar(18)   ,"
          "bar_code TEXT,"
          "name TEXT,"
          "canti_count int,"
          "date TEXT,"
          "PRIMARY KEY ( id  , zona, material) ) ");
      await db.execute(" CREATE UNIQUE INDEX idx_mate_matetial " +
          "ON Material(material,bar_code)");
     //await db.execute(" CREATE UNIQUE INDEX idx_mate_barcode " +
         // "ON Material (bar_code)");
    });
  }

  //Query
  //muestra todos los clientes de la base de datos
  Future<List<Material_data>> getAllMaterial() async {
    final db = await database;
    var response = await db.query("Material");
    List<Material_data> list =
        response.map((c) => Material_data.fromMap(c)).toList();
    return list;
  }

  //Query
  //muestra un solo cliente por el id la base de datos
  Future<Material_data> getMaterialWithId(var id) async {
    final db = await database;
    var response =
        await db.query("Material", where: "material = ?", whereArgs: [id]);
    return response.isNotEmpty ? Material_data.fromMap(response.first) : null;
    // final fire = await Api("material");
    //  fire.ref.document(id).get().then((DocumentSnapshot) {
    //    print("codigo de barras " + DocumentSnapshot.data["bar_code"]);
    //   return DocumentSnapshot.exists ? Material_data.fromMap(DocumentSnapshot.data) : null;
    // }
    // );

    //documents.map((data) => list.add(Zona_Field.fromMap(data.data))).toList();
  }

  Future<Material_data> getMaterialBarCodeWithId(var id) async {
    final db = await database;
    var response =
        await db.query("Material", where: "bar_code = ?", whereArgs: [id]);
    return response.isNotEmpty ? Material_data.fromMap(response.first) : null;
  }

  //Insert
  addMaterialToDatabase(Material_data material) async {
    final db = await database;
    //var table = await db.rawQuery("SELECT MAX(material)+1 as material FROM Material");
    //int id = table.first["material"];
    // material.material = id;
    final batch = db.batch();

    var raw = await batch.insert(
      "Material",
      material.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
      await batch.commit(noResult: true);
    return raw;
  }

  addMaterialToDatabaseBatch(List<Material_data> material) async {
    final db = await database;
    db.transaction((txn) async {
      Batch batch = txn.batch();
      for (var rows in material) {

        batch.insert('Material', rows.toMap() , conflictAlgorithm: ConflictAlgorithm.replace);
      }
      batch.commit();
    });
    //return raw;
  }
  //Delete
  //Delete client with id
  deleteMaterialWithId(int id) async {
    final db = await database;
    return db.delete("Material", where: "material = ?", whereArgs: [id]);
  }

  //Delete all clients
  deleteAllMaterial() async {
    final db = await database;
    db.delete("Material");
  }

  //Update
  updateMaterial(Material_data material) async {
    final db = await database;
    var response = await db.update("Material", material.toMap(),
        where: "material = ?", whereArgs: [material.material]);
    return response;
  }

// INICIO DE ZONAS DB
  //Query
  //muestra todos los clientes de la base de datos
  Future<List<Zona_Field>> getAllZona() async {
    final db = await database;

    var response = await db.rawQuery(
        'SELECT zona,date, SUM(canti_count) as canti_count from ZONA GROUP BY zona,date');
       // 'SELECT zona,date,canti_count from ZONA GROUP BY zona,date');
    List<Zona_Field> list = response.map((c) => Zona_Field.fromMap(c)).toList();

    return list;
  }


  //Query
  //muestra un solo cliente por el id la base de datos
  Future<List<Zona_Field>> getZonaWithId(var id) async {
    final db = await database;
    var response = await db.query("Zona ", where: "zona = ?", whereArgs: [id]);
    List<Zona_Field> list = response.map((c) => Zona_Field.fromMap(c)).toList();

    return list;
  }

  Future<List<Zona_Field>> getZonaWithIddate(var id, var date) async {
    final db = await database;
    var response = await db
     .query("Zona ", where: "zona = ? and date = ?", whereArgs: [id, date]);
    List<Zona_Field> list = response.map((c) => Zona_Field.fromMap(c)).toList();
    return list;
  }

  Future<Zona_Field> getZonaWithIdMaterial(var id, var mat) async {
    final db = await database;
    var response = await db.query("Zona",
        where: "zona = ? and material = ?", whereArgs: [id, mat]);
    return response.isNotEmpty ? Zona_Field.fromMap(response.first) : null;
  }

  Future<List<Zona_Field>> getZonaBarcodeCount() async {
    final db = await database;

    var response = await db.rawQuery(
        'SELECT bar_code , SUM(canti_count) as canti_count from ZONA GROUP BY bar_code');

    List<Zona_Field> list = response.map((c) => Zona_Field.fromMap(c)).toList();
    //print(list);
    return list;
  }
  Future<List<Zona_Field>> getZonaBarcodeCountZona() async {
    final db = await database;

    var response = await db.rawQuery(
        'SELECT zona, bar_code , SUM(canti_count) as canti_count from ZONA GROUP BY zona, bar_code');

    List<Zona_Field> list = response.map((c) => Zona_Field.fromMap(c)).toList();
   // print(list);
    return list;
  }

  //Insert
 /* addZonaToDatabase(Zona_Field material) async {
    final db = await database;

    var promise =
        getZonaWithIdMaterial("" + material.zona, "" + material.material);
    promise.then((res) {
      print("agregando");

      if (res != null) {
        print("existe");

        res.canti_count = material.canti_count + res.canti_count;

        return updateZona(res);
      } else {
        print("nuevo");

        var raw = db.insert(
          "Zona",
          material.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return raw;
      }
    }).catchError((onError) {
      print('Caught $onError'); // Handle the error.
    });
  }*/
  addZonaToDatabase(Zona_Field material) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM ZONA");
    int id = table.first["id"];
    material.id = id;

    var promise =
    getZonaWithIdMaterial("" + material.zona, "" + material.material);
    promise.then((res) {
      print("agregando");


        print("nuevo");

        var raw = db.insert(
          "Zona",
          material.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return raw;

    }).catchError((onError) {
      print('Caught $onError'); // Handle the error.
    });
  }
  //Delete
  //Delete client with id
  deleteZonaWithId(var id) async {
    final db = await database;
    return db.delete("Zona", where: "zona = ?", whereArgs: [id]);
  }

  deleteZonaWithIddate(var id, var date) async {
    final db = await database;
     return db
        .delete("Zona", where: "zona = ? and date = ?", whereArgs: [id, date]);
  }

  deleteZonaWithIdMat(var id, var date, var mat) async {
    final db = await database;

    return db.delete("Zona",
        where: "zona = ? and material = ? and date = ?",
        whereArgs: [id, mat, date]);
  }

  //Delete all clients
  deleteAllZona() async {
    final db = await database;
    db.delete("Zona");
  }

  //Update
  updateZona(Zona_Field zona) async {
    final db = await database;


    var response = await db.update("Zona", zona.toMap(),
        where: "zona = ? and  material = ?",
        whereArgs: [zona.zona, zona.material]);


    return response;
  }
}
