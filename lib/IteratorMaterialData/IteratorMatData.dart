import 'package:retailappcount/Interface/IIterator.dart';
import 'package:retailappcount/models/masterdata.dart';

class IteratorMatData implements IIterator {
  List<Material_data> list = null;
  int posi = 0;
  int unida = 0;
 // String tienda;
  IteratorMatData(this.list);

  @override
  getNext() {
    //  print( list[posi].material+ " sume " + list[posi].cantidad);
    unida = unida + int.parse(list[posi].cantidad);
    // print( list[posi].material+ " EN $unida");
    return list[posi++];
  }

  @override
  bool hasNext() {
    return (posi < list.length) ? true : false;
  }

  calculate() {

    for (var value in list) {

      unida = unida + int.parse(value.cantidad);
      posi++;
    }
  }
}
