

import 'dart:convert';

List<UserAll> userFromJson(String str) =>
    List<UserAll>.from(json.decode(str).map((x) => UserAll.fromJson(x)));

class UserAll {
  int? id;
  String? userId;
  String? name;
  String? surname;
  String? phone;
  String? secondPhoneNumber;
  String? type;
  String?statusMonthly;
  String? profile;
  String? status;
  String ?depositStatus;
  String? email;
  String? emailVerifiedAt;
  String? twoFactorConfirmedAt;
  String? currentTeamId;
  String? createdAt;
  String? updatedAt;
  String? profilePhotoUrl;

  UserAll(
      {this.id,
      this.userId,
      this.name,
      this.surname,
      this.phone,
      this.secondPhoneNumber,
      this.type,
      this.statusMonthly,
      this.profile,
      this.status,
      this.depositStatus,
      this.email,
      this.emailVerifiedAt,
      this.twoFactorConfirmedAt,
      this.currentTeamId,
      this.createdAt,
      this.updatedAt,
      this.profilePhotoUrl});

  UserAll.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    surname = json['surname'];
    phone = json['phone'];
    secondPhoneNumber = json['second_phone_number'];
    type = json['type'];
    statusMonthly = json['status_monthly'];
    profile = json['profile'];
    status = json['status'];
    depositStatus = json['deposit_status'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    twoFactorConfirmedAt = json['two_factor_confirmed_at'];
    currentTeamId = json['current_team_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profilePhotoUrl = json['profile_photo_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['surname'] = this.surname;
    data['phone'] = this.phone;
    data['second_phone_number'] = this.secondPhoneNumber;
    data['type'] = this.type;
    data['status_monthly'] = this.statusMonthly;
    data['profile'] = this.profile;
    data['status'] = this.status;
    data['deposit_status'] = this.depositStatus;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['two_factor_confirmed_at'] = this.twoFactorConfirmedAt;
    data['current_team_id'] = this.currentTeamId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_photo_url'] = this.profilePhotoUrl;
    return data;
  }
}
