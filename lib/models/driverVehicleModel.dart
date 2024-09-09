// ignore_for_file: file_names

class DriverVehicle {
  String? cc;
  String? image;
  String? name;
  String? reg;
  String? id;
  String? info;

  DriverVehicle(
      {
        this.name,
        this.cc,
        this.image,
        this.reg,
        this.id,
        this.info

      });

  DriverVehicle.fromMap(Map<dynamic, dynamic> map) {
    name = map["name"];
    image = map["image"];
    cc = map["cc"];
    reg = map["reg"];
    id = map["id"];
    info = map["info"];
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "image": image,
      "cc": cc,
      "reg": reg,
      "id":id,
      "info":info
    };
  }
}
