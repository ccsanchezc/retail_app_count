import 'dart:math';

//import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:retailappcount/models/masterdata.dart';
import 'package:flutter/material.dart';
import 'package:retailappcount/utils/colors.dart';
import 'package:retailappcount/models/masterdata.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/services.dart';
import 'package:retailappcount/db/database.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class FormPage extends StatefulWidget {
  String namezone;

  FormPage({Key key, @required this.namezone}) : super(key: key);
  @override
  FormPageState createState() => FormPageState(this.namezone);
}

class FormPageState extends State<FormPage> {
  final material = new TextEditingController();
  final name = new TextEditingController();
  final color = new TextEditingController();
  final talla = new TextEditingController();
  final bar_code = new TextEditingController();
  final depto = new TextEditingController();
  final mvgr1 = new TextEditingController();
  final cantidad = new TextEditingController();

  String namezone;
  Material_data materialinfo = new Material_data();
  FormPageState(this.namezone);
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String barcodeaux;
  bool _sumbit;
  var _selectedOption = "1";
  var _options = [
    "1",
    "5",
    "10",
    "15",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Zona: ' + this.namezone),
        backgroundColor: AppColors.primaryColor,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return new SimpleDialog(
                        title: new Text('Modificar cantidad en lectura'),
                        children: <Widget>[
                          new SimpleDialogOption(
                            onPressed: () {
                               Navigator.of(context).pop();
                            },
                            child: new Center(
                              child: new DropdownButton<String>(
                                  hint: new Text("Select your problem"),
                                  value: _selectedOption,
                                  items: _options.map((String val) {
                                    return new DropdownMenuItem<String>(
                                      value: val,
                                      child: new Text(val),
                                    );
                                  }).toList(),
                                  onChanged: (newVal) {
                                    setState(() {
                                      _selectedOption = newVal;
                                      Navigator.of(context).pop();
                                    });
                                  }),
                            ),
                          ),
                        ],
                      );
                    });
              })
          //}
        ],
      ),
      //body: _buildTableControll(),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Expanded(flex: 8, child: FormBuilder()),
        ]),
      ),

      backgroundColor: AppColors.statusBarColor,
    );
  }

  Widget FormBuilder() {
    return Form(
      key: _formKey,
      autovalidate: true,
      child: new ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: <Widget>[
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.view_week),
              hintText: 'Codigo de barras',
              labelText: 'Codigo de barras',
            ),
            controller: this.bar_code,
            autofocus: true,
            onFieldSubmitted: (value){
              print("entre");
              _submitForm();
            },
            onChanged: (value)  async{
              if (value.length >= 13) {
                if(barcodeaux != null) {
                  final startIndex = value.indexOf(barcodeaux);
                  if (startIndex == 0) {
                    final longitud = barcodeaux.length;
                    value = (value.substring(longitud, value.length));
                  } else {
                    value = (value.substring(0, barcodeaux.length));
                  }
                  if(barcodeaux.length  == value.length  && _sumbit){

                    _submitForm();
                    _sumbit = false;
                    this.bar_code.text = "";
                  }else{
                    value = barcodeaux ;
                  }

                }
                barcodeaux = value;
                print("voy a buscar");
                var promise =
                    await DatabaseProvider.db.getMaterialBarCodeWithId(value);
                if(promise  != null ) {
                  _sumbit = true;

                  setState(()  {

                    this.materialinfo = promise;
                     _updatecontroller();
                  });
                }else{
                  _sumbit = false;
                }
              }
            },
            validator: (value) =>
                value.isEmpty ? 'Codigo de barras requerido' : null,
            keyboardType: TextInputType.number,
          ),
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.extension),
              hintText: 'Material',
              labelText: 'Material',
            ),
            controller: this.material,
            onChanged: (value) async{
              if (value.length > 7) {
                value = value.toString().padLeft(18, '0');
                var promise = await DatabaseProvider.db.getMaterialWithId(value);
                setState(() async{
                  this.materialinfo = promise;
                  await _updatecontroller();
                });
              }
            },
            validator: (value) => value.isEmpty ? 'Material requerido' : null,
            keyboardType: TextInputType.number,
            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
          ),
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.equalizer),
              hintText: 'Cantidad',
              labelText: 'Cantidad',
            ),
            onSaved: (value) {
              this.materialinfo.cantidad = value;
            },
            controller: this.cantidad,
            keyboardType: TextInputType.number,
          ),
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.text_fields),
              hintText: 'Nombre del material',
              labelText: 'Nombre del material',
            ),
            controller: this.name,
            enabled: false,
            validator: (value) =>
                value.isEmpty ? 'Nombre Material requerido' : null,
            keyboardType: TextInputType.text,
          ),
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.color_lens),
              hintText: 'Color',
              labelText: 'Color',
            ),
            controller: this.color,
            //validator: (value) => value.isEmpty ? 'Color' : null,
            keyboardType: TextInputType.number,
            enabled: false,

            inputFormatters: [
              WhitelistingTextInputFormatter.digitsOnly,
            ],
          ),
          new TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.memory),
              hintText: 'Talla',
              labelText: 'Talla',
            ),
            controller: this.talla,
            enabled: false,
            keyboardType: TextInputType.number,
          ),
          new Container(
              padding: const EdgeInsets.only(left: 40.0, top: 20.0),
              child: new RaisedButton(
                child: const Text('Submit'),
                onPressed: _submitForm,
              )),
        ],
      ),
    );
  }

  void _clearcontroller() {
    this.material.text  = "";
    this.name.text = "";
    this.color.text = "";
    this.talla.text = "";
    this.bar_code.text = "";
    this.depto.text = "";
    this.mvgr1.text = "";
    this.cantidad.text = "";
  }

  void _updatecontroller() {
    this.material.text = this.materialinfo.material;
    this.name.text = this.materialinfo.name;
    this.color.text = this.materialinfo.color;
    this.talla.text = this.materialinfo.talla;
    this.bar_code.text = this.materialinfo.bar_code;
    this.depto.text = this.materialinfo.depto;
    this.mvgr1.text = this.materialinfo.mvgr1;
    // this.cantidad.text = this.materialinfo.cantidad
    this.cantidad.text = this._selectedOption;
  // await _submitForm();

  }


  void _submitForm() {
    final FormState form = _formKey.currentState;

    if (!form.validate()) {
      playLocalAsset();
      showMessage('Algo fallo!  Por favor revisar y corregir.');
    } else {
       form.save(); //This invokes each onSaved event
 // print("Voy a entrar agregar ${this.materialinfo.bar_code} y ${this.materialinfo.cantidad} ");
      var now = new DateTime.now();
      String fecha = formatDate(
          DateTime(now.year, now.month, now.day), [yyyy, '-', mm, '-', dd]);
      DatabaseProvider.db.addZonaToDatabase(new Zona_Field(
          zona: this.namezone,
          bar_code: this.materialinfo.bar_code,
          material: this.materialinfo.material,
          name: this.materialinfo.name,
          canti_count: int.parse(this.materialinfo.cantidad),
          date: "" + fecha));

      form.reset();
      _clearcontroller();
      // Navigator.pop(context);

    }
  }

  void showMessage(String message, [MaterialColor color = Colors.red]) {
    _scaffoldKey.currentState.showSnackBar(
        new SnackBar(backgroundColor: color, content: new Text(message)));
  }

  playLocalAsset()  {
    AudioCache audioCache = AudioCache(prefix: 'sound/');
    audioCache.play('crash.mp3' , mode: PlayerMode.LOW_LATENCY);
  }
}
