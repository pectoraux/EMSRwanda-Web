// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:components_codelab/src/services/database_service.dart';

@Component(
  selector: 'projects-component',
  templateUrl: 'projects.html',
  styleUrls: ['projects.css'],
  directives: [
    materialDirectives,
    formDirectives,
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
    MaterialCheckboxComponent,
    MaterialExpansionPanel,
    MaterialExpansionPanelSet,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    MaterialSaveCancelButtonsDirective,
    NgModel,
    NgFor
  ],
  providers: [materialProviders, DatabaseService],
)
class ProjectsComponent {
  @Input()
  String content;
  final yearsOptions = [1,2,3];
  int years;
  int index;
  String project;
  String location;
  bool isStaff = false;

  @Input()
  DatabaseService dbService;

  void onSave(int idx) {
    dbService.sendWorkRequest(idx);
  }

}
