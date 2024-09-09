// ignore_for_file: file_names

class DriverModel {
  String? address1;
  String? address2;
  String? address3;
  String? city;
  String? contact;
  String? country;
  String? courierID;
  String? deviceToken;
  String? password;
  String? zip;
  String? email;
  String? gender;
  String? image;
  String? uid;
  String? dob;
  String? name;
  String? middleName;
  String? surName;
  bool? isActive;
  bool? isBan;
  String? status;
  String? activeVehicle;
  String? selectedVehicle;
  String? chatroomID;
  String? onlineFor;
  bool? emailVerified;
  String? reasonForBan;
  double? lat;
  double? lng;

  DriverModel({
    this.address1,
    this.address2,
    this.address3,
    this.city,
    this.contact,
    this.country,
    this.courierID,
    this.zip,
    this.email,
    this.gender,
    this.image,
    this.uid,
    this.dob,
    this.name,
    this.middleName,
    this.surName,
    this.isActive,
    this.status,
    this.activeVehicle,
    this.selectedVehicle,
    this.chatroomID,
    this.isBan,
    this.deviceToken,
    this.password,
    this.onlineFor,
    this.emailVerified,
    this.reasonForBan,
    this.lng,
    this.lat
  });

  DriverModel.fromMap(Map<String, dynamic> map) {
    address1 = map["address1"];
    address2 = map["address2"];
    address3 = map["address3"];
    city = map["city"];
    contact = map["contact"];
    country = map["country"];
    courierID = map["courierID"];
    zip = map["zip/postal"];
    email = map["email"];
    gender = map["gender"];
    image = map["image"];
    uid = map["uid"];
    dob = map["dob"];
    name = map["name"];
    middleName = map["middleName"];
    surName = map["surName"];
    isActive = map["isActive"];
    status = map["status"];
    activeVehicle = map["activeVehicle"];
    selectedVehicle = map["selectedVehicle"];
    chatroomID=map["chatroomID"];
    isBan = map["isBan"];
    deviceToken = map["deviceToken"];
    password = map["password"];
    onlineFor = map["onlineFor"];
    emailVerified = map["emailVerified"];
    reasonForBan = map["reasonForBan"];
    lat = map["lat"];
    lng = map["lng"];
  }

  Map<String, dynamic> toMap() {
    return {
      'address1': address1,
      'address2': address2,
      'address3': address3,
      'city': city,
      'contact': contact,
      'country':country,
      'courierID': courierID,
      'zip/postal':zip,
      'email': email,
      'gender':gender,
      'image': image,
      'uid':uid,
      'dob':dob,
      'name': name,
      'middleName': middleName,
      'surName': surName,
      'isActive': isActive,
      'status': status,
      "activeVehicle": activeVehicle,
      "selectedVehicle":selectedVehicle,
      "chatroomID":chatroomID,
      "isBan":isBan,
      "deviceToken":deviceToken,
      "password":password,
      "onlineFor":onlineFor,
      "emailVerified":emailVerified,
      "reasonForBan":reasonForBan,
      "lat":lat,
      "lng":lng
    };
  }
}
