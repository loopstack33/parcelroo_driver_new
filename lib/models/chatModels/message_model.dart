class MessageModel {
  String? messageid;
  String? sender;
  String? text;
  bool? seen;
  DateTime? createdon;
  String? type;
  String? senderName;

  MessageModel({
    this.messageid,
    this.sender,
    this.text,
    this.seen,
    this.createdon,
    this.type,
    this.senderName,
  });

  MessageModel.fromMap(Map<String, dynamic> map) {
    messageid = map["messageid"];
    sender = map["sender"];
    text = map["text"];
    seen = map["seen"];
    createdon = map["createdon"].toDate();
    type = map["type"];
    senderName = map["senderName"];
  }

  Map<String, dynamic> toMap() {
    return {
      "messageid": messageid,
      "sender": sender,
      "text": text,
      "seen": seen,
      "createdon": createdon,
      "type": type,
      "senderName": senderName,
    };
  }
}
