// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:purer/address/district/controller.dart';
import 'package:purer/address/division/controller.dart';
import 'package:purer/address/state/controller.dart';
import 'package:purer/address/state/model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var districtController = Get.put(DistrictController());
var stateController = Get.put(StateController());
DivisionController divisionController =Get.put(DivisionController());
var data = stateController.statetList[0].stateName;


///////////////////////////////////////////////////////////////////////
sataetName(State1 state) => state.stateName.toString();
///////////////////////////////////////////////////////////////////////
List<String> deviceTypesdivision = List.generate(
    divisionController.statetList.length,
    (index) => divisionController.statetList[index].divisionName.toString());
//////////////////////////////////////////////////////////////////////
List<String> deviceTypesdistrict = List.generate(
    districtController.statetList.length,
    (index) => districtController.statetList[index].districtName.toString());
////////////////////////////////////////////////////////////////////
// List<String> stateName = List.generate(
//     stateController.statetList.length,
//     (index) => stateController.statetList[index].stateName.toString());
///////// ຈັນທະບູລີ
List<String> village1 = List.generate(
    stateController.statetList.where((p0) => p0.districtId.toString()== '1').length,
    (index) => stateController.statetList[index].stateName.toString());
    /////////ຫາດຊາຍຟອງ
List<String> village2 = List.generate(
    stateController.statetList.where((p0) => p0.districtId.toString() == '2').length,
    (index) => stateController.statetList[index+31].stateName.toString());
////// ນາຊາຍທອງ
List<String> village3 = List.generate(
    stateController.statetList.where((p0) => p0.districtId.toString() == '3').length,
    (index) =>  stateController.statetList[index+90].stateName.toString());
////// ສີໂຄດຕະບອງ
List<String> village4 = List.generate(
    stateController.statetList.where((p0) => p0.districtId.toString() == '4').length,
    (index) =>  stateController.statetList[index+146].stateName.toString());

///////// ສີສັດຕະນາກ
List<String> village5 = List.generate(
    stateController.statetList.where((p0) => p0.districtId.toString() == '5').length,
    (index) =>  stateController.statetList[index+205].stateName.toString());

///////// ໄຊເສດຖາ
List<String> village6 = village3 = List.generate(
    stateController.statetList.where((p0) => p0.districtId.toString()== '6').length,
    (index) =>  stateController.statetList[index+243].stateName.toString());
//////// ໄຊທານີ
List<String> village7 = List.generate(
    stateController.statetList.where((p0) => p0.districtId.toString() == '7').length,
    (index) => stateController.statetList[index+295].stateName.toString());

