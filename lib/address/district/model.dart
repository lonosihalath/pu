
import 'dart:convert';

List<District> DistrictFromJson(String str) =>
    List<District>.from(json.decode(str).map((x) => District.fromJson(x)));

class District {
  int? id;
  String? districtName;
  String? divisionId;
  String? createdAt;

  District(
      {this.id,
      this.districtName,
      this.divisionId,
      this.createdAt});

  District.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    districtName = json['district_name'];
    divisionId = json['division_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['district_name'] = this.districtName;
    data['division_id'] = this.divisionId;
    data['created_at'] = this.createdAt;
    return data;
  }
}
