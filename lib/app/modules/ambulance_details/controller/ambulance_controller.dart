import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ambu_go_user/app/modules/ambulance_details/view/emergency_type_dialog.dart';
import 'package:ambu_go_user/helper/loading.dart';
import 'package:ambu_go_user/helper/shared_preference.dart';
import 'package:ambu_go_user/utils/colors.dart';

class AmbulanceDetailsController extends GetxController {

  TextEditingController preferredHospital=TextEditingController();
  TextEditingController oxygen=TextEditingController();
  TextEditingController otherEmergencyType=TextEditingController();


  //ambulance details
  RxString dateOfRide = 'Dec 13th 2022, 14:47'.obs;
  RxString rideId = 'LM000000000001'.obs;
  RxString ambulanceNumber = 'XY 19 BP 1111'.obs;

  //driver details
  RxString nameOfDriver = 'Part-timer'.obs;
  RxString phoneNumberOfDriver = ''.obs;

  //nurse details
  RxString nameOfNurse = 'Natasha'.obs;
  RxString phoneNumberOfNurse = ''.obs;

  //next page
  //final _additionaldata = false.obs;
  bool additionalData=false;

  onPageChanged(bool x) {
    
    additionalData=x;
    update();
    
    
  }
  bool informationUpdated=false;
  onInformationUpdated(bool x)async{
    List<String> emergencyType=[];
    if(breathing){
             emergencyType.add('labor');
          }
          if(asthmaAttack){
            emergencyType.add('asthmaAttack');
          }
          if(bleeding){
            emergencyType.add('motorAccident');
          }
          if(heartAttack){
            emergencyType.add('heartAttack');
          }
          if(otherEmergencyType.text!=''){
            emergencyType.add(otherEmergencyType.text);
          }
    LoadingUtils.showLoader();
    await FirebaseFirestore.instance.collection('emergencies').doc(SPController().getUserId()).update({
      'additionalData':{
        'Is Oxygen neeeded':oxygen.text,
        'hospitalType':value,
        'emergencyType':emergencyType
      }
    });
    informationUpdated=x;
    update();
    LoadingUtils.hideLoader();
  }

  //type of hospital
  String value = 'Private and Public' ;
  List<String> dropDownList = ['Private', 'Public', 'Private and Public'];
  onChangedHospitalType(String x) {
    value = x;
    update();
  }


  //emergency
  bool breathing=false;
  onlaborChange(bool x){
    breathing=x;
    update();

  }
  bool asthmaAttack=false;
  onAsthmaAttackChanged(bool x){
    asthmaAttack=x;
    update();
  }
  bool bleeding=false;
  onmotorAccidentChanged(bool x){
    bleeding=x;
    update();
  }
  bool heartAttack=false;
  onHeartAttackChanged(bool x){
    heartAttack=x;
    update();
  }
  onOpenEmergency() {
    Get.defaultDialog(
        title: 'EMERGENCY TYPE',
        titleStyle: const TextStyle(color: AppColors.pink, fontFamily: 'RedHatBold'),
        content: const EmergencyTypeDialog());
  }
}
