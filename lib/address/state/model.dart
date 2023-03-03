import 'dart:convert';

List<State1> stateFromJson(String str) =>
    List<State1>.from(json.decode(str).map((x) => State1.fromJson(x)));
class State1 {
  int? id;
  String? stateName;
  String? divisionId;
  String? districtId;
  String? createdAt;

  State1(
      {this.id,
      this.stateName,
      this.divisionId,
      this.districtId,
      this.createdAt,});

  State1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateName = json['state_name'];
    divisionId = json['division_id'];
    districtId = json['district_id'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state_name'] = this.stateName;
    data['division_id'] = this.divisionId;
    data['district_id'] = this.districtId;
    data['created_at'] = this.createdAt;
    return data;
  }
}
