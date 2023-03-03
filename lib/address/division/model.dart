
import 'dart:convert';

List<Division> DivisionFromJson(String str) =>
    List<Division>.from(json.decode(str).map((x) => Division.fromJson(x)));

class Division {
  int? id;
  String? divisionName;
  String? createdAt;

  Division({this.id, this.divisionName, this.createdAt});

  Division.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    divisionName = json['division_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['division_name'] = this.divisionName;
    data['created_at'] = this.createdAt;
    return data;
  }
}
