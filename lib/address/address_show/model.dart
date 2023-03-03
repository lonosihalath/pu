import 'dart:convert';

List<Showaddressmodel> addressFromJson(String str) =>
    List<Showaddressmodel>.from(
        json.decode(str).map((x) => Showaddressmodel.fromJson(x)));

class Showaddressmodel {
  int? id;
  String? userId;
  String? divisionId;
  String? districtId;
  String? stateId;
  String? longtiude;
  String? latitiude;
  String? phone;
  String? notes;
  String? createdAt;
  String? updatedAt;

  Showaddressmodel(
      {this.id,
      this.divisionId,
      this.districtId,
      this.stateId,
      this.phone,
      this.notes,
      this.userId,
      this.latitiude,
      this.longtiude,
      this.createdAt,
      this.updatedAt});

  Showaddressmodel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    divisionId = json['division_id'];
    districtId = json['district_id'];
    stateId = json['state_id'];
    phone = json['phone'];
    notes = json['notes'];
    userId = json['user_id'];
    latitiude = json['latitiude'];
    longtiude = json['longtiude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['division_id'] = this.divisionId;
    data['district_id'] = this.districtId;
    data['state_id'] = this.stateId;
    data['phone'] = this.phone;
    data['notes'] = this.notes;
    data['user_id'] = this.userId;
    data['latitiude'] = this.latitiude;
    data['longtiude'] = this.longtiude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}