import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

class mUser {
  final String userName;
  String userRole, firstName, lastName, dob, country, nationalID, passportNo, mainPhone, sex, altPhone1, altPhone2, email1, email2, tin, cvStatusElec;

//  mUser(this.userName, this.firstName, this.lastName, this.dob, this.country, this.nationalID, this.passportNo, this.mainPhone, this.sex, this.altPhone1, this.altPhone2, this.email1, this.email2, this.tin, this.cvStatusElec) {
//  }
mUser(this.userName);

  String get userId => "$userName";
//  mUser.fromMap(Map map): this(map['userName'],
//    map['firstName'],
//    map['lastName'],
//    map['dob'],
//    map['country'],
//    map['nationalID'],
//    map['passportNo'],
//    map['mainPhone'],
//    map['sex'],
//    map['altPhone1'],
//    map['altPhone2'],
//    map['email1'],
//    map['email2'],
//    map['tin'],
//    map['cvStatusElec']);

  Map toMap() => {
    "userName": userName,
    "firstName": firstName,
    "lastName": lastName,
    "dob": dob,
    "country": country,
    "nationalID": nationalID,
    "passportNo": passportNo,
    "mainPhone": mainPhone,
    "sex":sex,
    "altPhone1":altPhone1,
    "altPhone2":altPhone2,
    "email1": email1,
    "email2": email2,
    "tin": tin,
    "cvStatusElec":cvStatusElec
  };
}