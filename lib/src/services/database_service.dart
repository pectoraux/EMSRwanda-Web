//import 'dart:html';
//import 'dart:async';
//
//import 'package:angular/angular.dart';
//import 'package:firebase/firebase.dart' as fb;
//import 'package:firebase/firestore.dart';
//
//@Injectable()
//class DatabaseService {
//  fb.Auth _fbAuth;
//  fb.GoogleAuthProvider _fbGoogleAuthProvider;
//  fb.Database _fbDatabase;
//  fb.Storage _fbStorage;
//  fb.DatabaseReference _fbRefMessages;
//  fb.User user;

//  DatabaseService()   {
//    fb.initializeApp(
//      apiKey: "AIzaSyC8scZmEOm9UrW1-L8KgMvmbrmjkE8MQD4",
//      authDomain: "emsrwanda-app.firebaseapp.com",
//      databaseURL: "https://emsrwanda-app.firebaseio.com",
//      storageBucket: "emsrwanda-app.appspot.com",
//    );
//    _fbGoogleAuthProvider = new fb.GoogleAuthProvider();
//    _fbAuth = fb.auth();
//    _fbAuth.onAuthStateChanged.listen(_authChanged);

//  }


//  void _authChanged(fb.User fbUser) {
//    user = fbUser;
//  }
//
//  Future signIn() async {
//    try {
//      await _fbAuth.signInWithPopup(_fbGoogleAuthProvider);
//    }
//    catch (error) {
//      print("$runtimeType::login() -- $error");
//    }
//  }
//
//  void signOut() {
//    _fbAuth.signOut();
//  }
//}
//
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';
import '../models/User.dart';


@Injectable()
class DatabaseService {
  fb.Auth _fbAuth;
  fb.User user;
  bool submit = false;
  CollectionReference userRef;
  mUser userData;
  String userName, userRole, userStatus, firstName, lastName, country, nationalID, passportNo, mainPhone, sex, altPhone1, altPhone2, email1, email2, tin, cvStatusElec;
  var dob;
  bool editing;
  String bankAcctNo, bankName;
  String emergencyContactPhone, emergencyContactName, insurance, insuranceNo, insuranceCpy;
  List<String> projectOptions = [], projectIds = [], locationOptions = [], requestOptions = [], requestTypes = [], requestProjectIds = [];
  List<int> idxOptions = [], idxOptions2 = [];
  List<bool> isStaff = [], sentWorkRequest = [], madeRequestDecision = [];
  List<String> author = [], startDates = [], endDates = [], descriptions = [], authorIDs = [];
  List<String> requestProjectAuthor = [], requestIds = [], requestProjectStartDates = [], requestProjectEndDates = [], requestProjectDescriptions = [], requestProjectAuthorIDs = [];
  bool invalidPassword;
  String currentGroup, teamCount, staffCount, currentGroupCount, gender;

  DatabaseService()  {

    // Initialize Firebase

    fb.initializeApp(
        apiKey: "AIzaSyCqXzE1MY_ynsEP0edBQDtkGqRFyMrdn8g",
        authDomain: "emsrwanda-26fd6.firebaseapp.com",
        databaseURL: "https://emsrwanda-26fd6.firebaseio.com",
        projectId: "emsrwanda-26fd6",
        storageBucket: "emsrwanda-26fd6.appspot.com",
        messagingSenderId: "726664476062"
    );
    _fbAuth = fb.auth();
    _fbAuth.onAuthStateChanged.listen(_authChanged);
  }



  void _authChanged(fb.User fbUser) {
    user = fbUser;
//    print(" my User is $user");
    if (user != null && invalidPassword == null) {
      fb.firestore().collection("users").where('userName', "==", user.uid).get().then((query){
//        userData = mUser(query.docs.first.data()['userName']);
//        print(" my User is $user");
      userName = query.docs.first.data()['userName'];
        userRole = query.docs.first.data()['userRole'];
        userStatus = query.docs.first.data()['userStatus'];
        firstName = query.docs.first.data()['firstName'];
        lastName = query.docs.first.data()['lastName'];
        dob = query.docs.first.data()['dob'].toString().split(' ')[0];
        country = query.docs.first.data()['country'].toString();
        nationalID = query.docs.first.data()['nationalID'];
        passportNo = query.docs.first.data()['passportNo'];
        mainPhone = query.docs.first.data()['mainPhone'];
        sex = query.docs.first.data()['sex'];
        altPhone1 = query.docs.first.data()['altPhone1'];
        altPhone2 = query.docs.first.data()['altPhone2'];
        email1 = query.docs.first.data()['email1'];
        email2 = query.docs.first.data()['email2'];
        tin = query.docs.first.data()['tin'];
        cvStatusElec = query.docs.first.data()['cvStatusElec'];
        editing = query.docs.first.data()['editing'];
        bankName = query.docs.first.data()['bankName'];
        bankAcctNo = query.docs.first.data()['bankAcctNo'];
        insuranceNo = query.docs.first.data()['insuranceNo'];
        insurance = query.docs.first.data()['insurance'];
        insuranceCpy = query.docs.first.data()['insuranceCpy'];
        emergencyContactName = query.docs.first.data()['emergencyContactName'];
        emergencyContactPhone = query.docs.first.data()['emergencyContactPhone'];
      });

      fb.firestore().collection("projects").get().then((query){
        int i = 0;
        query.docs.forEach((doc){
          projectOptions.add(doc.data()['projectTitle']);
          projectIds.add(doc.id);
          locationOptions.add(doc.data()['locations'].toString());
          idxOptions.add(i);
          isStaff.add(false);
          sentWorkRequest.add(false);
          authorIDs.add(doc.data()['author']);
          startDates.add(doc.data()['startDate'].toString().split(' ')[0]);
          endDates.add(doc.data()['endDate'].toString().split(' ')[0]);
          descriptions.add(doc.data()['projectDescription']);
          i += 1;
        });

        fb.firestore().collection("users/${user.uid}/pending_requests").get().then((query) {
          int k = 0;
          query.docs.forEach((doc) {
            requestOptions.add(doc.data()['projectTitle']);
            requestProjectIds.add(doc.data()['projectId']);
            requestTypes.add(doc.data()['type']);
            requestIds.add(doc.id);
            madeRequestDecision.add(false);
            idxOptions2.add(k);
            k += 1;
          });
        });

      }).whenComplete(() {
        fb.firestore().collection("users/${user.uid}/projects").get().then((
            query) {
          query.docs.forEach((doc) {
            fb.firestore().doc("projects/${doc.id}").get().then((currDoc){
              for (int j = 0; j < projectOptions.length; j++) {
                String user_proj = currDoc.data()['projectTitle'];
                    String proj = projectOptions[j];
                if (proj.trim().toLowerCase() == user_proj.trim().toLowerCase()) {
                  isStaff[j] = true;
                }
              }
            });
          });
        });
          for(int l = 0; l < requestProjectIds.length; l++){
            fb.firestore().doc("projects/${requestProjectIds[l]}").get().then((currProj) {
              requestProjectAuthorIDs.add(currProj.data()['author']);
            });
          }

        });
    }
  }


  Future updatePrimary(Map<String, dynamic> values)async {
    fb.firestore().runTransaction((transaction) async {
    Map<String, Object> data = <String, Object>{};
    DocumentReference reference = fb.firestore().doc("users/${user.uid}");
    DocumentSnapshot snap = await reference.get();
    data = snap.data();
    data['userName'] = values['user-name'];
    data['userRole'] = values['user-role'];
    data['userStatus'] = values['user-status'];
    data['firstName'] = values['first-name'];
    data['lastName'] = values['last-name'];
    data['dob'] = values['dob-edit'] != null ? values['dob-edit'].toString() : values['dob'];
    data['country'] = values['country-edit'] != null ? values['country-edit'] : values['country'];
    data['nationalID'] = values['national-id'];
    data['passportNo'] = values['passport-no'];
    data['mainPhone'] = values['main-phone'];
    data['sex'] = values['sex-edit'] != null ? values['sex-edit'] : values['sex'];
    data['phone1'] = values['alt-phone1'];
    data['phone2'] = values['alt-phone2'];
    data['email1'] = values['email1'];
    data['email2'] = values['email2'];
    data['tin'] = values['tin'];
    data['cvStatusElec'] = values['cvStatusElec'];
    data['editing'] = !data['editing'];
   editing = data['editing'];
   print("DATA => => ${data}");
   await reference.set(data);
    });
  }

  Future sendWorkRequest(int idx) async {
//      print("PROJECT ID ${idx} <= <= <= ${projectIds[idx]}");
      String projectId = projectIds[idx];
      fb.firestore().doc('projects/${projectId}').get().then((doc) {
        Map<String, Object> request_data = <String, Object>{
          'projectId': projectId,
          'projectTitle': doc.data()['projectTitle'],
          'to': doc.data()['author'],
          'page': 'project_details',
          'from': user.uid,};

        fb.firestore().runTransaction((transaction) async {
          DocumentReference reference = fb.firestore().collection('send-work-request').doc();
          await transaction.set(reference, request_data);
          sentWorkRequest[idx] = true;
        });
      });
  }

  void acceptRequest(int idx){
    String requestId = requestIds[idx];
    String projectId = requestProjectIds[idx];
    fb.firestore().runTransaction((transaction) async {
      String mId;
      fb.firestore().doc('users/${user.uid}/pending_requests/${requestId}').get().then((d){
        if(d.data()['page'] == 'project_details'){
          mId = d.data()['from'];
        }else {
          mId = user.uid;
        }
      }).whenComplete(() async {
        //write projectId in user's projects
        DocumentReference reference1 = fb.firestore().doc('users/${mId}/projects/${projectId}');
        await reference1.set({});

        // Get Gender
        DocumentSnapshot userSnap = await (fb.firestore().doc('users/${mId}}')).get();
        String gender = userSnap.data()['sex'].toString();
        print("USER GENDER IS ${gender}");
        // Inserting User's records in project
        DocumentReference reference2 = fb.firestore().doc('projects/${projectId}/users/${mId}');
        await reference2.set({
          'comments': [],
          'userGroup': (currentGroupCount == teamCount) ? int.parse(currentGroup)+1 : int.parse(currentGroup),
          'communicationRating': -1.0,
          'initiativeTakingRating': -1.0,
          'overAllRating': -1.0,
          'punctualityRating': -1.0,
          'reportingRating': -1.0,
          'sex': gender,
        });
      }).whenComplete(() async { // Update currentGroupCount and currentGroup in projects
        fb.firestore().runTransaction((transaction) async {
          DocumentReference reference = fb.firestore().doc('projects/${projectId}');
          Map<String, Object> data = <String, Object>{};
          DocumentReference projectRef = fb.firestore().doc("projects/${projectId}");
          DocumentSnapshot snap = await reference.get();
          data = snap.data();
          data['currentGroupCount'] = (currentGroupCount == teamCount) ? 0 : int.parse(currentGroupCount) + 1;
          data['currentGroup'] = (currentGroupCount == teamCount) ? int.parse(currentGroup) + 1 : int.parse(currentGroup);
          await reference.set(data);
        });
      });
    });

// Delete Pending Requests
    fb.firestore().runTransaction((transaction) async {
      String mId;
      fb.firestore().doc('users/${user.uid}/pending_requests/${requestId}').get().then((d){
        mId =  d.data()['from'];
      }).whenComplete((){
        fb.firestore().doc('users/${user.uid}/pending_requests/${requestId}').delete();
        fb.firestore().doc('users/${mId}/pending_requests/${requestId}').delete();
        madeRequestDecision[idx] = true;
      });
    });
  }

  void cancelRequest(int idx){
    String requestId = requestIds[idx];
    fb.firestore().runTransaction((transaction) async {
      String mId;
      fb.firestore().doc('users/${user.uid}/pending_requests/${requestId}').get().then((d){
        mId =  d.data()['to'];
      }).whenComplete((){
        fb.firestore().doc('users/${user.uid}/pending_requests/${requestId}').delete();
        fb.firestore().doc('users/${mId}/pending_requests/${requestId}').delete();
      });
    }).whenComplete((){
      madeRequestDecision[idx] = true;
    });
  }

  void rejectRequest(int idx){
    String requestId = requestIds[idx];
    fb.firestore().runTransaction((transaction) async {
      String mId;
      fb.firestore().doc('users/${user.uid}/pending_requests/${requestId}').get().then((d){
        mId =  d.data()['from'];
      }).whenComplete((){
        fb.firestore().doc('users/${user.uid}/pending_requests/${requestId}').delete();
        fb.firestore().doc('users/${mId}/pending_requests/${requestId}').delete();
      });
    }).whenComplete((){
      madeRequestDecision[idx] = true;
    });
  }

  Future gotToSaveMode(Map<String, dynamic> values)async{
    fb.firestore().runTransaction((transaction) async {
      Map<String, Object> data = <String, Object>{};
      DocumentReference reference = fb.firestore().doc("users/${user.uid}");
      DocumentSnapshot snap = await reference.get();
      data = snap.data();
      data['editing'] = false;
      editing = data['editing'];
      await reference.set(data);
    });
//    print("==> ${data}");
  }

  Future updateBankDetails(Map<String, dynamic> values)async {
    fb.firestore().runTransaction((transaction) async {
    Map<String, Object> data = <String, Object>{};
    DocumentReference reference = fb.firestore().doc("users/${user.uid}");
    DocumentSnapshot snap = await reference.get();
    data = snap.data();
    data['bankName'] = values['bank-name'];
    data['bankAcctNo'] = values['bank-acct-no'];
    data['editing'] = !data['editing'];
    editing = data['editing'];
    await reference.set(data);
  });
  }

  Future updateInsuranceDetails(Map<String, dynamic> values)async {
    fb.firestore().runTransaction((transaction) async {
    Map<String, Object> data = <String, Object>{};
    DocumentReference reference = fb.firestore().doc("users/${user.uid}");
    DocumentSnapshot snap = await reference.get();
    data = snap.data();
    data['insurance'] = values['insurance'];
    data['insuranceNo'] = values['insurance-no'];
    data['insuranceCpy'] = values['insurance-cpy'];
    data['editing'] = !data['editing'];
    editing = data['editing'];
    await reference.set(data);
    });
  }

  Future updateEmergencyDetails(Map<String, dynamic> values)async {
    fb.firestore().runTransaction((transaction) async {
    Map<String, Object> data = <String, Object>{};
    DocumentReference reference = fb.firestore().doc("users/${user.uid}");
    DocumentSnapshot snap = await reference.get();
    data = snap.data();
    data['emergencyContactName'] = values['emergency-contact-name'];
    data['emergencyContactPhone'] = values['emergency-contact-phone'];
    data['editing'] = !data['editing'];
    editing = data['editing'];
    await reference.set(data);
  });
  }

  Future signIn(String email, String password) async {

    try {
      submit = true;
      String muid = (await _fbAuth.signInWithEmailAndPassword(email, 'Laterite')).user.uid;
      fb.firestore().doc("users/${muid}").get().then((currUser) {
        if(password != currUser.data()['userPassword']) {
          invalidPassword = true;
          signOut();
        }
      });
    }
    catch (error) {
      print("$runtimeType::login() -- $error");
    }
  }
  void signOut() {
    submit = false;
    _fbAuth.signOut();
  }
}
