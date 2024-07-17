// lib/controllers/table_controller.dart
import 'package:get/get.dart';
import 'package:mobile_food_delivery/data/repository/area_repo.dart';
import 'package:mobile_food_delivery/data/repository/table_repo.dart';
import 'package:mobile_food_delivery/models/table.dart';
import 'package:mobile_food_delivery/models/area.dart';

class TableController extends GetxController {
  final TableRepo tableRepo;
  final AreaRepo areaRepo;
  TableController({required this.tableRepo, required this.areaRepo});

  Tables? selectedTable;
  final RxList<Area> areas = <Area>[].obs;
  final RxMap<String, Tables> tablesMap = <String, Tables>{}.obs;

  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  Future<void> getAreas() async {
    Response response = await areaRepo.getAreas();
    if (response.statusCode == 200) {
      areas.clear();
      List<dynamic> areaList = response.body['content'];
      for (var area in areaList) {
        areas.add(Area.fromJson(area));
      }
      await fetchTablesForAreas();
      _isLoaded = true;
      update();
    } else {
      print("Could not get areas");
    }
  }

  Future<void> fetchTablesForAreas() async {
    for (Area area in areas) {
      if (area.tableIdList != null) {
        for (String tableId in area.tableIdList!) {
          await getTableById(tableId);
        }
      }
    }
  }

  Future<void> getTableById(String id) async {
    Response response = await tableRepo.getTableById(id);
    if (response.statusCode == 200) {
      Tables table = Tables.fromJson(response.body['content']);
      tablesMap[id] = table;
    } else {
      print("Could not get table with id: $id");
    }
  }

  List<Tables> getTablesForArea(Area area) {
    if (area.tableIdList == null) return [];
    return area.tableIdList!
        .map((id) => tablesMap[id])
        .where((table) => table != null)
        .cast<Tables>()
        .toList()
      ..sort((a, b) {
        // Extract the numeric part from the table names
        int aNum = int.tryParse(a.name!.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        int bNum = int.tryParse(b.name!.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        return aNum.compareTo(bNum);
      });
  }

  void toggleTableSelection(Tables table) {
    if (table.isAvailable == true) {
      if (selectedTable?.tableId == table.tableId) {
        selectedTable = null;
      } else {
        selectedTable = table;
      }
      update();
    }
  }

  Area? getUpstairsArea() {
    return areas.firstWhereOrNull((area) => area.name?.toLowerCase() == 'upstairs');
  }

  List<Area> getCenterAreas() {
    return areas
        .where(
            (area) => area.name?.toLowerCase() != 'upstairs' && area.name?.toLowerCase() != 'side')
        .toList();
  }

  Area? getSideArea() {
    return areas.firstWhereOrNull((area) => area.name?.toLowerCase() == 'side');
  }

  bool isTableSelected(Tables table) {
    return selectedTable?.tableId == table.tableId;
  }

  void resetSelectedTable() {
    selectedTable = null;
    update();
  }
}
