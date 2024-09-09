import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parcelroo_driver_app/enums/color_constants.dart';
import 'package:uuid/uuid.dart';
import '../../../models/chatModels/chat_room_model.dart';
import '../../../models/chatModels/message_model.dart';
import '../../../models/chatModels/userModel.dart';

class BottomField extends StatefulWidget {
  final UsersModel usersModel;
  final ChatRoomModel chatRoom;
  final UsersModel targetUser;

  const BottomField(
      {Key? key,
      required this.usersModel,
      required this.chatRoom,
      required this.targetUser})
      : super(key: key);

  @override
  State<BottomField> createState() => _BottomFieldState();
}

class _BottomFieldState extends State<BottomField> {
  TextEditingController msgController = TextEditingController();
  bool isShowSendButton = false;
  ChatRoomModel temp = ChatRoomModel();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    updateStatus();

  }

  void sendTextMessage() async {
      if (_formKey.currentState!.validate()) {
        sendMsg("text", msgController.text.trim().toString());
      }
      if (mounted) {
        setState(() {
          msgController.text = '';
        });
      }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding:
            const EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 20),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (builder) => bottomSheet());
              },
              child: Icon(FeatherIcons.plusCircle,color: dashColor,size: 30.sp,)
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.black.withOpacity(0.2), width: 1.w)),
                child: TextFormField(
                  controller: msgController,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(
                      color: dashColor,
                      fontFamily: 'Poppins',
                      fontSize: 16.sp),
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () {
                          if(msgController.text.isNotEmpty){
                            sendTextMessage();
                          }

                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            FeatherIcons.send,
                            size: 25.sp,
                            color:dashColor,
                          ),
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.only(left: 10, bottom: 10),
                      hintText: "Type here...",
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Poppins',
                          fontSize: 16.sp),
                      border: InputBorder.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return SizedBox(
      height: 180.h,
      width: MediaQuery.of(context).size.width,
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.all(18.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              iconCreation(
                  Icons.image, Colors.purple, "Image", getImage2),
              SizedBox(
                width: 40.w,
              ),
              iconCreation(Icons.camera, Colors.pink, "Camera",
                  getCameraImage),

            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(
      IconData icons, Color color, String text, GestureTapCallback tap) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: color,
            child: Icon(
              icons,
              size: 30.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              fontFamily: "Poppins",
              color: dashColor
              // fontWeight: FontWeight.w100,
            ),
          )
        ],
      ),
    );
  }

  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  bool isLoading2 = false;
  File? imageFile;
  String imageUrl = "";
  String videoUrl = "";
  String audioUrl = "";
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UploadTask? uploadTask;
  UploadTask? uploadTask2;

  Future getCameraImage() async {
    Navigator.pop(context);
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.camera).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage2();
      }
    });
  }

  File? imageFile2;
  Future getImage2() async {
    Navigator.pop(context);
    ImagePicker picker = ImagePicker();

    await picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage2();
      }
    });
  }

  Future uploadImage2() async {

    String fileName = const Uuid().v1();
    int status = 1;
    MessageModel newMessage = MessageModel(
      messageid: fileName,
      sender: widget.usersModel.userId.toString(),
      text: "",
      seen: false,
      type: "image",
      createdon: DateTime.now(),
      senderName: widget.usersModel.name.toString(),
    );

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .doc(newMessage.messageid)
        .set(newMessage.toMap());

    final path = 'imageFiles/$fileName';
    final fle = File(imageFile!.path);
    final ref = FirebaseStorage.instance.ref().child(path);

    if (status == 1) {
      if (mounted) {
        setState(() {
          uploadTask = ref.putFile(fle);
        });
      }
      try {
        final snap = await uploadTask!.whenComplete(() => {});
        imageUrl = await snap.ref.getDownloadURL();
        await _firestore
            .collection('chatrooms')
            .doc(widget.chatRoom.chatroomid)
            .collection('messages')
            .doc(fileName)
            .update({"text": imageUrl});

        var msgcount = 1;

        widget.chatRoom.count = widget.chatRoom.count.toString() == "null"
            ? 0
            : widget.chatRoom.count! + msgcount;
        widget.chatRoom.read = false;
        widget.chatRoom.idFrom = widget.usersModel.userId;
        widget.chatRoom.idTo = widget.targetUser.userId;
        widget.chatRoom.timeStamp =
            DateTime.now().millisecondsSinceEpoch.toString();
        widget.chatRoom.lastMessage = "Image File";
        FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(widget.chatRoom.chatroomid)
            .set(widget.chatRoom.toMap());


        if (mounted) {
          setState(() {
            isLoading = false;
            uploadTask = null;
          });
        }
        updateStatus();
      } on FirebaseException {
        if (mounted) {
          setState(() {
            isLoading = false;
            status = 0;
            uploadTask = null;
          });
        }
        //ToastUtils.failureToast( e.message ?? e.toString(), context);
      }
    }
  }

  var uuid = const Uuid();
  sendMsg(String mType, String mText) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    await firebaseFirestore
        .collection('chatrooms')
        .where('chatroomid', isEqualTo: widget.chatRoom.chatroomid)
        .get()
        .then((value) {
      addmessage(mType, mText);
    });
  }

  addmessage(String mType, String mText) {
    log("in");
    MessageModel newMessage = MessageModel(
      messageid: uuid.v1(),
      sender: widget.usersModel.userId.toString(),
      text: mText,
      seen: false,
      type: mType,
      createdon: DateTime.now(),
      senderName: widget.usersModel.name.toString(),
    );
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .collection('messages')
        .doc(newMessage.messageid)
        .set(newMessage.toMap());
    log(msgController.text);
    var msgcount1 = 1;
    widget.chatRoom.lastMessage = mText.toString();
    widget.chatRoom.read = false;
    widget.chatRoom.idFrom = widget.usersModel.userId;
    widget.chatRoom.idTo = widget.targetUser.userId;
    widget.chatRoom.count = widget.chatRoom.count.toString() == "null" ? 0 : widget.chatRoom.count! + msgcount1;
    widget.chatRoom.timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(widget.chatRoom.chatroomid)
        .set(widget.chatRoom.toMap());

    //FCMServices.sendFCM(widget.targetUser.userToken[0].toString(), widget.usersModel.userId.toString(),widget.usersModel.name.toString(),mText.toString());
    //updateStatus();

    msgController.clear();
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  void updateStatus() async {
    if (widget.chatRoom.idFrom != "8") {
      final DocumentReference documentReference =
          _firestore.collection('chatrooms').doc(widget.chatRoom.chatroomid);
      documentReference.update(<String, dynamic>{'read': true, 'count': 0});
      widget.chatRoom.count = 0;

      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.chatroomid)
          .collection("messages")
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.update({
            'seen': true,
          });
        }
      });
    } else {}
  }
}
