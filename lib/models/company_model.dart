class CompanyModel {
  String? id;


  CompanyModel(
      {
        this.id,


      });

  CompanyModel.fromMap(Map<dynamic, dynamic> map) {
    id = map["id"];

  }

  Map<String, dynamic> toMap() {
    return {
      "companyId": id,

    };
  }
}
