class Tables {
  String? tableId;
  String? name;
  bool? isAvailable;
  DateTime? createdDate;
  String? createdBy;
  DateTime? updatedDate;
  String? updatedBy;
  String? areaId;

  Tables({
    this.tableId,
    this.name,
    this.isAvailable,
    this.createdDate,
    this.createdBy,
    this.updatedDate,
    this.updatedBy,
    this.areaId,
  });

  Tables.fromJson(Map<String, dynamic> json) {
    tableId = json['tableId'];
    name = json['name'];
    isAvailable = json['isAvailable'];
    createdDate = json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null;
    createdBy = json['createdBy'];
    updatedDate = json['updatedDate'] != null ? DateTime.parse(json['updatedDate']) : null;
    updatedBy = json['updatedBy'];
    areaId = json['areaId'];
  }

  Map<String, dynamic> toJson() {
    return {
      'tableId': tableId,
      'name': name,
      'isAvailable': isAvailable,
      'createdDate': createdDate?.toIso8601String(),
      'createdBy': createdBy,
      'updatedDate': updatedDate?.toIso8601String(),
      'updatedBy': updatedBy,
      'areaId': areaId,
    };
  }
}
