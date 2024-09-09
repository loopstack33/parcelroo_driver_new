// ignore_for_file: use_build_context_synchronously, prefer_final_fields

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import '../../../enums/gobals.dart';
import '../../../utils/app_routes.dart';
import '../../../widgets/simple_dialog.dart';

class UpdateVehicleProvider extends ChangeNotifier{

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<TextEditingController> controllers = [];
  List<bool> _selected = [];
  List<bool> get selected => _selected;


  void checkLength(BuildContext context,index,cc,name,image,id,info,reg) async{
    _isLoading=true;
    notifyListeners();
    await firebaseFireStore.collection('drivers').doc(Globals.uid)
        .get().then((value) {
      //int arrayLength = value.data()!["vehicles"].length;
      List queue=value.data()!["vehicles"];
      List item = queue
          .where((element) => element['id'].contains(id))
          .toList();

      if(item.isEmpty){
        addVehicle(context,index,cc,name,image,id,info,reg);
      }
      else{
        _isLoading=false;
        notifyListeners();
        showDialog(context: context, builder: (context){
          return const MySimpleDialog(title: "Error", msg: "Vehicle Already Added",
            icon:FeatherIcons.alertTriangle,);
        });
      }

      // if(arrayLength!=3){
      //   if(item.isEmpty){
      //     addVehicle(context,index,cc,name,image,id,info,reg);
      //   }
      //   else{
      //     _isLoading=false;
      //     notifyListeners();
      //     showDialog(context: context, builder: (context){
      //       return const MySimpleDialog(title: "Error", msg: "Vehicle Already Added",
      //         icon:FeatherIcons.alertTriangle,);
      //     });
      //   }
      //
      // }
      // else{
      //   _isLoading=false;
      //   notifyListeners();
      //   showDialog(context: context, builder: (context){
      //     return const MySimpleDialog(title: "Error", msg: "MAX 3 Vehicles Allowed Only.",
      //       icon:FeatherIcons.alertTriangle,);
      //   });
      // }
    });
  }

  void addVehicle(context,index,cc,name,image,id,info,reg){
    _selected[index] = !_selected[index];
    notifyListeners();

    if(_selected[index]){
      List item = [{
        "cc":cc,
        "image":image,
        "name":name,
        "reg":reg,
        "id":id,
        "info":info
      }];

      firebaseFireStore.collection("drivers").doc(Globals.uid).update({
        "vehicles":FieldValue.arrayUnion(item)
      }).then((value) {
        _isLoading = false;
        _selected[index]=false;
        controllers.clear();
        _selected.clear();
        notifyListeners();
        showDialog(context: context, builder: (context){
          return const MySimpleDialog(title: "Success", msg: "Your Vehicle Has Been Successfully Added!",
            icon: FeatherIcons.checkCircle,);
        });
      }).catchError((e){
        _isLoading=false;
        notifyListeners();
        showDialog(context: context, builder: (context){
          return  MySimpleDialog(title: "Error", msg: e.toString(),
            icon: FeatherIcons.xCircle,);
        });
      });
    }

  }


  void deleteVehicle(BuildContext context,name) async {

    _isLoading = true;
    notifyListeners();
    final data = firebaseFireStore.collection("drivers").doc(Globals.uid);
    final docSnap=await data.get();
    List queue=docSnap.get('vehicles');

    List item = queue
        .where((element) => element['id'].contains(name))
        .toList();
    log(item.toString());

    data.update({
      "vehicles":FieldValue.arrayRemove(item)
    }).then((value) {
      _isLoading = false;
      notifyListeners();
      AppRoutes.pop(context);
      showDialog(context: context, builder: (context){
        return const MySimpleDialog(title: "Success", msg: "Your Vehicle Has Been Successfully Deleted!",
          icon: FeatherIcons.checkCircle,);
      });
    }).catchError((e){
      _isLoading=false;
      notifyListeners();
      showDialog(context: context, builder: (context){
        return  MySimpleDialog(title: "Error", msg: e.toString(),
          icon: FeatherIcons.xCircle,);
      });
    });
  }

}