// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:components_codelab/src/services/database_service.dart';

@Component(
  selector: 'requests-component',
  templateUrl: 'requests.html',
  styleUrls: ['requests.css'],
  directives: [
    materialDirectives,
    NgSwitch,
    NgSwitchWhen,
    NgSwitchDefault,
    MaterialCheckboxComponent,
    MaterialExpansionPanel,
    MaterialExpansionPanelSet,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    MaterialButtonComponent,
    NgFor
  ],
  providers: [materialProviders, DatabaseService],
)
class RequestsComponent {
  @Input()
  String content;
  final yearsOptions = [1,2,3];
  int years;
  final idxOptions = [0,1,2,3,4,5];
  int index;
  final projectOptions = ['FSI', 'MISM', 'GER', 'Student\'s Project', 'ELI', 'VIM'];
  String project;
  final locationOptions = ['Made To You', 'Made By You', 'Made By You', 'Made To You', 'Made By You', 'Made To You'];
  String location;

  @Input()
  DatabaseService dbService;

  void settingsUpdated() {
  }
}
