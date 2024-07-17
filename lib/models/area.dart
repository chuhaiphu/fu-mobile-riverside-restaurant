class Area {
  String? areaId;
  String? name;
  bool? isAvailable;
  DateTime? createdDate;
  String? createdBy;
  DateTime? updatedDate;
  String? updatedBy;
  List<String>? tableIdList;

  Area({
    this.areaId,
    this.name,
    this.isAvailable,
    this.createdDate,
    this.createdBy,
    this.updatedDate,
    this.updatedBy,
    this.tableIdList,
  });

  Area.fromJson(Map<String, dynamic> json) {
    areaId = json['areaId'];
    name = json['name'];
    isAvailable = json['isAvailable'];
    createdDate = json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null;
    createdBy = json['createdBy'];
    updatedDate = json['updatedDate'] != null ? DateTime.parse(json['updatedDate']) : null;
    updatedBy = json['updatedBy'];
    tableIdList = json['tableIdList'] != null ? List<String>.from(json['tableIdList']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'areaId': areaId,
      'name': name,
      'isAvailable': isAvailable,
      'createdDate': createdDate?.toIso8601String(),
      'createdBy': createdBy,
      'updatedDate': updatedDate?.toIso8601String(),
      'updatedBy': updatedBy,
      'tableIdList': tableIdList,
    };
  }
}
