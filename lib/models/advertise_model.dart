class AdvertiseModel {
  String? jobId;
  int? jobNo;
  double? pickLatitude;
  double? pickLongitude;
  double? dropLatitude;
  double? dropLongitude;
  String? rejectedBy;
  String? waitingReason;
  String? waitingTime;
  String? vehicleRequired;
  String? vehicleType;
  String? vehicleID;
  String? price;
  String? currency;
  String? paymentType;
  String? pickDate;
  String? pickTime;
  String? actualPickDate;
  String? actualPickTime;
  String? dropDate;
  String? dropTime;
  String? actualDropDate;
  String? actualDropTime;
  String? pickCustomer;
  String? pickEmail;
  String? dropEmail;
  String? dropCustomer;
  String? pickContact;
  String? dropContact;
  String? pickAddress;
  String? dropAddress;
  String? pickSecurity;
  String? dropSecurity;
  String? pickInstructions;
  String? dropInstructions;
  String? pickManifest;
  String? dropManifest;
  String? pickPassword;
  String? pickOverride;
  String? dropPassword;
  String? dropOverride;
  bool? isAdult;
  String? assignedTo;
  String? companyLogo;
  String? cancelledBy;
  String? companyAddress;
  String? companyContact;
  String? companyId;
  String? companyName;
  String? completedBy;
  String? customerSignature;
  bool? isCancel;
  bool? isComplete;
  List? barCodes;
  List? barCodes2;
  String? driverName;
  String? driverImage;
  String? driverCourier;
  String? cancellationReason;
  String? cancelledTime;
  String? pickTimeType;
  String? dropTimeType;
  bool? isPicked;
  bool? isDropped;
  String? waitingReasonDrop;
  String? waitingTimeDrop;
  String? pickImage;
  String? dropImage;
  String? customerAge;
  String? dropScanType;
  String? pickScanType;
  bool? isAdvertised;


  AdvertiseModel({
    this.currency,
    this.price,
    this.jobId,
    this.dropAddress,
    this.dropDate,
    this.dropTime,
    this.pickAddress,
    this.pickTime,
    this.pickDate,
    this.dropContact,
    this.dropCustomer,
    this.dropInstructions,
    this.dropManifest,
    this.dropOverride,
    this.dropPassword,
    this.dropSecurity,
    this.isAdult,
    this.paymentType,
    this.pickContact,
    this.pickCustomer,
    this.pickInstructions,
    this.pickManifest,
    this.pickOverride,
    this.pickPassword,
    this.pickSecurity,
    this.vehicleID,
    this.vehicleRequired,
    this.pickLatitude,
    this.pickLongitude,
    this.companyName,
    this.companyLogo,
    this.companyContact,
    this.companyId,
    this.companyAddress,
    this.dropEmail,
    this.pickEmail,
    this.assignedTo,
    this.cancelledBy,
    this.completedBy,
    this.customerSignature,
    this.isCancel,
    this.isComplete,
    this.jobNo,
    this.rejectedBy,
    this.vehicleType,
    this.waitingReason,
    this.waitingTime,
    this.dropLatitude,
    this.dropLongitude,
    this.barCodes,
    this.driverCourier,
    this.driverImage,
    this.driverName,
    this.cancellationReason,
    this.cancelledTime,
    this.pickTimeType,
    this.dropTimeType,
    this.barCodes2,
    this.isDropped,
    this.isPicked,
    this.waitingReasonDrop,
    this.waitingTimeDrop,
    this.pickImage,
    this.customerAge,
    this.dropImage,
    this.dropScanType,
    this.pickScanType,
    this.isAdvertised,
    this.actualDropDate,
    this.actualDropTime,
    this.actualPickDate,
    this.actualPickTime
  });

  AdvertiseModel.fromMap(Map<dynamic, dynamic> map) {
    currency = map["currency"];
    price = map["price"];
    jobId = map["jobId"];
    dropAddress = map["dropAddress"];
    dropDate = map["dropDate"];
    dropTime = map["dropTime"];
    pickAddress = map["pickAddress"];
    pickTime = map["pickTime"];
    pickDate = map["pickDate"];
    dropContact = map["dropContact"];
    dropCustomer = map["dropCustomer"];
    dropInstructions = map["dropInstructions"];
    dropManifest = map["dropManifest"];
    dropOverride = map["dropOverride"];
    dropPassword = map["dropPassword"];
    dropSecurity = map["dropSecurity"];
    isAdult = map["isAdult"];
    paymentType = map["paymentType"];
    pickContact = map["pickContact"];
    pickCustomer = map["pickCustomer"];
    pickInstructions = map["pickInstructions"];
    pickManifest = map["pickManifest"];
    pickOverride = map["pickOverride"];
    pickPassword = map["pickPassword"];
    pickSecurity = map["pickSecurity"];
    vehicleID = map["vehicleID"];
    vehicleRequired = map["vehicleRequired"];
    pickLatitude = map["pickLatitude"];
    pickLongitude = map["pickLongitude"];
    companyName = map["companyName"];
    companyLogo = map["companyLogo"];
    companyContact = map["companyContact"];
    companyId = map["companyId"];
    companyAddress = map["companyAddress"];
    dropEmail = map["dropEmail"];
    pickEmail = map["pickEmail"];
    assignedTo = map["assignedTo"];
    cancelledBy = map["cancelledBy"];
    completedBy = map["completedBy"];
    customerSignature = map["customerSignature"];
    isCancel = map["isCancel"];
    isComplete = map["isComplete"];
    jobNo = map["jobNo"];
    rejectedBy = map["rejectedBy"];
    vehicleType = map["vehicleType"];
    waitingReason = map["waitingReason"];
    waitingTime = map["waitingTime"];
    dropLatitude = map["dropLatitude"];
    dropLongitude  = map["dropLongitude"];
    barCodes = map["barCodes"];
    barCodes2 = map["barCodes2"];
    driverName = map["driverName"];
    driverImage = map["driverImage"];
    driverCourier = map["driverCourierID"];
    cancellationReason = map["cancellationReason"];
    cancelledTime = map["cancelledTime"];
    pickTimeType = map["pickTimeType"];
    dropTimeType = map["dropTimeType"];
    isPicked = map["isPicked"];
    isDropped = map["isDropped"];
    waitingReasonDrop = map["waitingReasonDrop"];
    waitingTimeDrop = map["waitingTimeDrop"];
    pickImage= map["pickImage"];
    dropImage= map["dropImage"];
    customerAge= map["customerAge"];
    dropScanType = map["dropScanType"];
    pickScanType = map["pickScanType"];
    isAdvertised = map["isAdvertised"];
    actualDropDate = map["actualDropDate"];
    actualDropTime = map["actualDropTime"];
    actualPickDate = map["actualPickDate"];
    actualPickTime = map["actualPickTime"];

  }

  Map<String, dynamic> toMap() {
    return {
      "currency" :currency,
      "price" : price,
      "jobId" : jobId,
      "dropAddress" : dropAddress,
      "dropDate" : dropDate,
      "dropTime" : dropTime,
      "pickAddress" : pickAddress,
      "pickTime" : pickTime,
      "pickDate" : pickDate,
      "dropContact" : dropContact,
      "dropCustomer" : dropCustomer,
      "dropInstructions" : dropInstructions,
      "dropManifest" : dropManifest,
      "dropOverride" : dropOverride,
      "dropPassword" : dropPassword,
      "dropSecurity" : dropSecurity,
      "isAdult" : isAdult,
      "paymentType" : paymentType,
      "pickContact" : pickContact,
      "pickCustomer" : pickCustomer,
      "pickInstructions" :pickInstructions,
      "pickManifest" :pickManifest,
      "pickOverride" :pickOverride,
      "pickPassword" :pickPassword,
      "pickSecurity" :pickSecurity,
      "vehicleID" :vehicleID,
      "vehicleRequired" :vehicleRequired,
      "pickLatitude" :pickLatitude,
      "pickLongitude" :pickLongitude,
      "companyName" :companyName,
      "companyLogo" :companyLogo,
      "companyContact":companyContact,
      "companyId" :companyId,
      "companyAddress" :companyAddress,
      "dropEmail" :dropEmail,
      "pickEmail" :pickEmail,
      "assignedTo" :assignedTo,
      "cancelledBy" :cancelledBy,
      "completedBy" :completedBy,
      "customerSignature" :customerSignature,
      "isCancel" :isCancel,
      "isComplete" :isComplete,
      "jobNo" :jobNo,
      "rejectedBy" :rejectedBy,
      "vehicleType" :vehicleType,
      "waitingReason" :waitingReason,
      "waitingTime" :waitingTime,
      "dropLatitude" :dropLatitude,
      "dropLongitude"  :dropLongitude,
      "barCodes":barCodes,
      "barCodes2":barCodes2,
      "driverName": driverName,
      "driverImage":driverImage,
      "driverCourierID":driverCourier,
      "cancellationReason":cancellationReason,
      "cancelledTime":cancelledTime,
      "pickTimeType":pickTimeType,
      "dropTimeType" : dropTimeType,
      "isPicked":isPicked,
      "isDropped":isDropped,
      "waitingReasonDrop":waitingReasonDrop,
      "waitingTimeDrop":waitingTimeDrop,
      "pickImage" : pickImage,
      "dropImage" : dropImage,
      "customerAge" : customerAge,
      "dropScanType":dropScanType,
      "pickScanType":pickScanType,
      "isAdvertised":isAdvertised,
      "actualDropDate" : actualDropDate,
      "actualDropTime" :actualDropTime,
      "actualPickDate" : actualPickDate,
      "actualPickTime" : actualPickTime
    };
  }
}
