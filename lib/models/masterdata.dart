//import 'dart:html';

class Material_data {
  var material;
  String name;
  String color;
  String talla;
  String bar_code;
  String depto;
  String mvgr1;
  String cantidad;

  @override
  toString() {
    return this.material +
        this.name +
        this.color +
        this.talla +
        this.bar_code +
        this.depto +
        this.mvgr1 +
        this.cantidad;
  }

  Material_data({this.material,
    this.name,
    this.color,
    this.talla,
    this.bar_code,
    this.depto,
    this.mvgr1,
    this.cantidad});

  //To insert the data in the bd, we need to convert it into a Map
  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
    Map<String, dynamic> toMap() =>
      {
        "material": material,
        "name": name,
        "color": color,
        "talla": talla,
        "bar_code": bar_code,
        "depto": depto,
        "mvgr1": mvgr1,
        "cantidad": cantidad,
      };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  //factory Material_data.fromMap(Map<String, dynamic> json) => new Material_data(
  factory Material_data.fromMap(dynamic json) =>
      new Material_data(
        material: json["material"],
        name: json["name"],
        color: json["color"],
        talla: json["talla"],
        bar_code: json["bar_code"],
        depto: json["depto"],
        mvgr1: json["mvgr1"],
        cantidad: json["cantidad"],
      );

  Material_data.fromMap2(Map<String, dynamic> json) {

      //new Material_data(

        material = json["Material"].toString().padLeft(18, '0');
        name = json["Name"];
        color = json["Color"];
        talla = json["Talla"];
        bar_code = json["Barcode"];
        depto =json["Depto"];
        mvgr1 = json["Mvgr1"];
        cantidad = json["Cantidad"];

       cantidad = cantidad.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
        if(cantidad == '000') {
          cantidad = '0';
        }
        if(cantidad == 'UNO') {
          cantidad = '1';
        }
        if(cantidad == 'D') {
          cantidad = '10';
        }
      //  print("$material y $cantidad");
     // );
}
}

class TopTenUsersModelResponse {
   List<Material_data> list;

  TopTenUsersModelResponse({
    this.list,
  });

  factory TopTenUsersModelResponse.fromJson(List<dynamic> parsedJson) {
    List<Material_data> list = new List<Material_data>();
    list = parsedJson.map((i) => Material_data.fromMap2(i)).toList();
    final value = list.length;
    print("tengo tantos" + '$value');
    return new TopTenUsersModelResponse(list: list);
  }
}



final List<String> Material_model = [
  'material',
  'name',
  'color',
  'talla',
  'bar_code',
  'depto',
  'mvgr1',
  'cantidad',
];

final List<Zona_Field>  ZonasCount =[];

final List<String> Zona_Fild_Model = [
  'zona',
  'material',
  'bar_code',
  'canti_count',
  'date' ,
];

class Zona_Field {
  int id;
  var zona;
  String material;
  String bar_code;
  String name;
  int canti_count;
  String date ;
  @override
  toString() {
    return this.zona + this.bar_code + this.canti_count;
  }

  Zona_Field(
      {this.zona, this.material, this.bar_code, this.name, this.canti_count, this.date});

  //To insert the data in the bd, we need to convert it into a Map
  //Para insertar los datos en la bd, necesitamos convertirlo en un Map
  Map<String, dynamic> toMap() => {
        "id": id,
        "zona": zona,
        "material": material,
        "bar_code": bar_code,
        "name": name,
        "canti_count": canti_count,
        "date": date,
      };

  //to receive the data we need to pass it from Map to json
  //para recibir los datos necesitamos pasarlo de Map a json
  //factory Material_data.fromMap(Map<String, dynamic> json) => new Material_data(
  factory Zona_Field.fromMap(dynamic json) => new Zona_Field(
        zona: json["zona"].toString(),
        material: json["material"].toString(),
        bar_code: json["bar_code"].toString(),
        name: json["name"].toString(),
        canti_count: json["canti_count"],
        date: json["date"].toString(),
      );

}
