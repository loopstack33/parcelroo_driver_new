class PaymentTypes {
  String? id;
  String? name;
  bool? enabled;

  PaymentTypes(
      {
        this.name,
        this.id,
        this.enabled,

      });

  PaymentTypes.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];
    name = map["name"];
    enabled = map["enabled"];

  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "enabled": enabled,


    };
  }
}
