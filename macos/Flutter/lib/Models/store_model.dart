//Stores
import 'package:cloud_firestore/cloud_firestore.dart';

class StoresMap {
  late List<dynamic> menu;
  late String name;
  late bool online;
  late String owner;
  late List<dynamic> tables;
  late String id;
  late String imageData;

  StoresMap({
    required this.menu,
    required this.name,
    required this.online,
    required this.owner,
    required this.tables,
    required this.id,
    required this.imageData,
  });

  Map<String, dynamic> toMap() {
    return {
      'menu': menu,
      'name': name,
      'online': online,
      'owner': owner,
      'tables': tables,
      'id': id,
      'imageData': imageData,
    };
  }

  @override
  String toString() {
    return 'StoresMap{menu: $menu, name: $name, online: $online, '
        'owner: $owner, tables: $tables, id: $id, imageData: $imageData}';
  }

  Map<String, dynamic> toJson() {
    return {
      'menu': menu,
      'name': name,
      'online': online,
      'owner': owner,
      'tables': tables,
      'id': id,
    };
  }

  StoresMap.fromMap(Map<String, dynamic> storesMap)
      : menu = storesMap["menu"],
        name = storesMap["name"],
        online = storesMap["online"],
        owner = storesMap["owner"],
        tables = storesMap["tables"],
        id = storesMap["id"],
        imageData = storesMap["imageData"];

  StoresMap.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        menu = doc.data()!["menu"],
        name = doc.data()!["name"],
        online = doc.data()!["online"],
        owner = doc.data()!["owner"],
        tables = doc.data()!["tables"],
        imageData = doc.data()!["imageData"];
}
