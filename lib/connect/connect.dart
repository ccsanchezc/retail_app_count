import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retailappcount/models/masterdata.dart';
class connect {
  static Future<List<Material_data>> CallOdata(String user, String pass) async {

    const filter = "\$filter";
    print(filter);
    Map<String, String> qParams = {
      'sap-client': '300',
      '\$format': 'json',
    };
    String basicAuth =
       'Basic ' + base64Encode(utf8.encode('$user:$pass'));
     //'Basic ' + base64Encode(utf8.encode('CON_ABAP2:Ronny1033801286****'));


  //  var uri = Uri.http('fdseccdev.fueradeserie.com.co:8004', //dev
      var uri = Uri.http('fdseccdev.fueradeserie.com.co:8000',
        '/sap/opu/odata/sap/ZMM_APP_001_SRV/InputParamSet', qParams);

    var response = await http
        .get(uri, headers: {HttpHeaders.authorizationHeader: basicAuth});
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final jsonResponse2 = jsonResponse["d"];
      final jsonResponse3 = jsonResponse2["results"];
      print("infomración cargada");
      TopTenUsersModelResponse value = new TopTenUsersModelResponse();
      value = TopTenUsersModelResponse.fromJson(jsonResponse3);
      final List<Material_data> list = value.list;
     // print("YA LO HICE ");
      return list;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
