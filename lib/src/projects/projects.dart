// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
  selector: 'projects-component',
  templateUrl: 'projects.html',
  styleUrls: ['projects.css'],
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
    NgFor
  ],
)
class ProjectsComponent {
  @Input()
  String content;
  final yearsOptions = [1,2,3];
  int years;
  final idxOptions = [0,1,2,3,4,5];
  int index;
  final projectOptions = ['FSI', 'MISM', 'GER', 'Student\'s Project', 'ELI', 'VIM'];
  String project;
  final locationOptions = ['Kigali', 'Gisenyi', 'Gaculiro', 'Kacyiru', 'Kisimenti', 'Remera'];
  String location;
}
