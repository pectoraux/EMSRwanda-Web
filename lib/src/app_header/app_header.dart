import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import '../services/database_service.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_yes_no_buttons/material_yes_no_buttons.dart';

@Component(selector: 'app-header',
    templateUrl: 'app_header.html',
    styleUrls: ['app_header.css'],
    directives: [MaterialButtonComponent,
                  NgIf,
                  MaterialInputComponent,
                  MaterialYesNoButtonsComponent,
                  formDirectives,
                  materialInputDirectives,
                  MaterialSaveCancelButtonsDirective,],
)
class AppHeader {
  final DatabaseService dbService;

  AppHeader(DatabaseService this.dbService);
  Person person;

  void onSubmit(NgForm form) {
    person = _createPerson(form.value);
    dbService.signIn(person.email, person.password);
  }


  // TODO(alorenzen): Reset form inputs.
  void onClear(NgForm form) {
    person = null;
    form.control.reset();
  }

  Person _createPerson(Map<String, dynamic> values) {
    String userName = values['user-name'];
    return Person(
//      firstName: values['first-name'],
//      lastName: values['last-name'],
      email: userName+'@laterite.com',
      password: values['password'],
    );
  }
}

class Person {
//  final String firstName;
//  final String lastName;
    final String email;
    final String password;

  Person({this.email, this.password,});
}