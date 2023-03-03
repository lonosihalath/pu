import 'dart:convert';

List<StaffOrder> orderFromJson(String str) =>
    List<StaffOrder>.from(json.decode(str).map((x) => StaffOrder.fromJson(x)));


class StaffOrder {
  String? userId;
  String? divisionId;
  String? districtId;
  String? stateId;
  String? longitudeId;
  String? latitiudeId;
  String? phone;
  String? notes;
  String? day;
  String? truckId;
 String? onepayImage;
  String? amountCash;
  String? amountOnepayBottle;
  String? paidStatus;
  String? orderDate;
  String? orderMonth;
  String? orderYear;
  String? pendingDate;
  String? confirmedDate;
  String? processingDate;
  String? orderNo;
  String? orderType;
  String? status;
  List<OrderItem>? orderItem;
  List<Deposit>? deposit;

  StaffOrder(
      {this.userId,
      this.divisionId,
      this.districtId,
      this.stateId,
      this.longitudeId,
      this.latitiudeId,
      this.phone,
      this.notes,
      this.day,
      this.truckId,
      this.onepayImage,
      this.amountCash,
      this.amountOnepayBottle,
      this.paidStatus,
      this.orderDate,
      this.orderMonth,
      this.orderYear,
      this.pendingDate,
      this.confirmedDate,
      this.processingDate,
      this.orderNo,
      this.orderType,
      this.status,
      this.orderItem,
      this.deposit});

  StaffOrder.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    divisionId = json['division_id'];
    districtId = json['district_id'];
    stateId = json['state_id'];
    longitudeId = json['longitude_id'];
    latitiudeId = json['latitiude_id'];
    phone = json['phone'];
    notes = json['notes'];
    day = json['day'];
    truckId = json['truck_id'];
    onepayImage = json['onepay_image'];
    amountCash = json['amount_cash'];
    amountOnepayBottle = json['amount_onepay_bottle'];
    paidStatus = json['paid_status'];
    orderDate = json['order_date'];
    orderMonth = json['order_month'];
    orderYear = json['order_year'];
    pendingDate = json['pending_date'];
    confirmedDate = json['confirmed_date'];
    processingDate = json['processing_date'];
    orderNo = json['order_no'];
    orderType = json['order_type'];
    status = json['status'];
    if (json['order_item'] != null) {
      orderItem = <OrderItem>[];
      json['order_item'].forEach((v) {
        orderItem!.add(new OrderItem.fromJson(v));
      });
    }
    if (json['deposit'] != null) {
      deposit = <Deposit>[];
      json['deposit'].forEach((v) {
        deposit!.add(new Deposit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['division_id'] = this.divisionId;
    data['district_id'] = this.districtId;
    data['state_id'] = this.stateId;
    data['longitude_id'] = this.longitudeId;
    data['latitiude_id'] = this.latitiudeId;
    data['phone'] = this.phone;
    data['notes'] = this.notes;
    data['day'] = this.day;
    data['truck_id'] = this.truckId;
    data['onepay_image'] = this.onepayImage;
    data['amount_cash'] = this.amountCash;
    data['amount_onepay_bottle'] = this.amountOnepayBottle;
    data['paid_status'] = this.paidStatus;
    data['order_date'] = this.orderDate;
    data['order_month'] = this.orderMonth;
    data['order_year'] = this.orderYear;
    data['pending_date'] = this.pendingDate;
    data['confirmed_date'] = this.confirmedDate;
    data['processing_date'] = this.processingDate;
    data['order_no'] = this.orderNo;
    data['order_type'] = this.orderType;
    data['status'] = this.status;
    if (this.orderItem != null) {
      data['order_item'] = this.orderItem!.map((v) => v.toJson()).toList();
    }
    if (this.deposit != null) {
      data['deposit'] = this.deposit!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItem {
  int? id;
  String? type;
  Attributes? attributes;

  OrderItem({this.id, this.type, this.attributes});

  OrderItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    attributes = json['attributes'] != null
        ? new Attributes.fromJson(json['attributes'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.toJson();
    }
    return data;
  }
}

class Attributes {
  int? orderId;
  String? image;
  String? productName;
  String? size;
  String? price;
  String? amount;
  String? totalAmount;

  Attributes(
      {this.orderId,
      this.image,
      this.productName,
      this.size,
      this.price,
      this.amount,
      this.totalAmount});

  Attributes.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    image = json['image'];
    productName = json['product_name'];
    size = json['size'];
    price = json['price'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['image'] = this.image;
    data['product_name'] = this.productName;
    data['size'] = this.size;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['total_amount'] = this.totalAmount;
    return data;
  }
}

class Deposit {
  int? id;
  String? depositNumber;
  String? amountBottle;
  String? price;
  String? date;
  String? orderId;
  String? userId;
  String? approverName;
  String? approverSurname;
  String? customerSignature;
  String? createdAt;
  String? updatedAt;

  Deposit(
      {this.id,
      this.depositNumber,
      this.amountBottle,
      this.price,
      this.date,
      this.orderId,
      this.userId,
      this.approverName,
      this.approverSurname,
      this.customerSignature,
      this.createdAt,
      this.updatedAt});

  Deposit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    depositNumber = json['deposit_number'];
    amountBottle = json['amount_bottle'];
    price = json['price'];
    date = json['date'];
    orderId = json['order_id'];
    userId = json['user_id'];
    approverName = json['approver_name'];
    approverSurname = json['approver_surname'];
    customerSignature = json['customer_signature'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['deposit_number'] = this.depositNumber;
    data['amount_bottle'] = this.amountBottle;
    data['price'] = this.price;
    data['date'] = this.date;
    data['order_id'] = this.orderId;
    data['user_id'] = this.userId;
    data['approver_name'] = this.approverName;
    data['approver_surname'] = this.approverSurname;
    data['customer_signature'] = this.customerSignature;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

