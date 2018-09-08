// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:components_codelab/src/lottery/lottery.dart';
import 'package:components_codelab/src/settings/settings.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_yes_no_buttons/material_yes_no_buttons.dart';
import 'package:angular_components/material_datepicker/material_datepicker.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_select/dropdown_button.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:angular_components/material_select/material_select_searchbox.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_model.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular_components/model/ui/display_name.dart';
import 'package:angular_components/model/ui/has_factory.dart';
import 'package:components_codelab/src/services/database_service.dart';
import 'package:components_codelab/src/app_header/app_header.dart';
import 'package:components_codelab/src/settings/settings.dart';
import 'package:components_codelab/src/settings/settings_component.dart';

@Component(
  selector: 'dashboard-component',
  templateUrl: 'dashboard_component.html',
  directives: [
    formDirectives,
    materialInputDirectives,
    MaterialYesNoButtonsComponent,
    MaterialSaveCancelButtonsDirective,
    MaterialIconComponent,
    MaterialDatepickerComponent,
    NgIf,
    MaterialCheckboxComponent,
    MaterialExpansionPanel,
    MaterialExpansionPanelSet,
    MaterialRadioComponent,
    MaterialRadioGroupComponent,
    MaterialSelectItemComponent,
    MaterialSelectComponent,
    DropdownSelectValueAccessor,
    MaterialDropdownSelectComponent,
    NgModel,
    NgFor,
    MaterialCheckboxComponent,
    MaterialDropdownSelectComponent,
    MaterialSelectSearchboxComponent,
    DropdownSelectValueAccessor,
    MultiDropdownSelectValueAccessor,
    DropdownButtonComponent,
    MaterialToggleComponent,
  ],
  providers: [materialProviders, DatabaseService, ClassProvider(Settings),],
)
class DashboardComponent implements OnInit {
  static const List<String> _countries = <String>[
    'Select Nationality',
    'Afghanistan',
    'Albania',
    'Algeria',
    'Andorra',
    'Angola',
    'Anguilla',
    'Antigua & Barbuda',
    'Argentina',
    'Armenia',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bermuda',
    'Bhutan',
    'Bolivia',
    'Bosnia & Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei Darussalam',
    'Bulgaria',
    'Burkina Faso',
    'Myanmar/Burma',
    'Burundi',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Cape Verde',
    'Cayman Islands',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Cyprus',
    'Czech Republic',
    'Democratic Republic of the Congo',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea',
    'Estonia',
    'Ethiopia',
    'Fiji',
    'Finland',
    'France',
    'French Guiana',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Great Britain',
    'Greece',
    'Grenada',
    'Guadeloupe',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Israel and the Occupied Territories',
    'Italy',
    'Ivory Coast (Cote d\'Ivoire)',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kosovo',
    'Kuwait',
    'Kyrgyz Republic (Kyrgyzstan)',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Republic of Macedonia',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Martinique',
    'Mauritania',
    'Mauritius',
    'Mayotte',
    'Mexico',
    'Moldova, Republic of',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Montserrat',
    'Morocco',
    'Mozambique',
    'Namibia',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'Korea, Democratic Republic of (North Korea)',
    'Norway',
    'Oman',
    'Pacific Islands',
    'Pakistan',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Puerto Rico',
    'Qatar',
    'Reunion',
    'Romania',
    'Russian Federation',
    'Rwanda',
    'Saint Kitts and Nevis',
    'Saint Lucia',
    'Saint Vincent\'s & Grenadines',
    'Samoa',
    'Sao Tome and Principe',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Sierra Leone',
    'Singapore',
    'Slovak Republic (Slovakia)',
    'Slovenia',
    'Solomon Islands',
    'Somalia',
    'South Africa',
    'Korea, Republic of (South Korea)',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Swaziland',
    'Sweden',
    'Switzerland',
    'Syria',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Timor Leste',
    'Togo',
    'Trinidad & Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Turks & Caicos Islands',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United States of America (USA)',
    'Uruguay',
    'Uzbekistan',
    'Venezuela',
    'Vietnam',
    'Virgin Islands (UK)',
    'Virgin Islands (US)',
    'Yemen',
    'Zambia',
    'Zimbabwe',
  ];
//  final SelectionModel<String> singleSelectModel = SelectionModel.single(selected: _countries[1]);
//
//  static ItemRenderer<String> _displayNameRenderer = (String item) => item;

//  String get singleSelectLanguageLabel =>
//      singleSelectModel.selectedValues.length > 0
//          ? itemRenderer(singleSelectModel.selectedValues.first)
//          : 'Select Language';
//
//  final SelectionModel<String> multiSelectModel =
//  SelectionModel<String>.multi();

//  String get multiSelectLanguageLabel {
//    var selectedValues = multiSelectModel.selectedValues;
//    if (selectedValues.isEmpty) {
//      return "Select Languages";
//    } else if (selectedValues.length == 1) {
//      return itemRenderer(selectedValues.first);
//    } else {
//      return "${itemRenderer(selectedValues.first)} + ${selectedValues.length - 1} more";
//    }
//  }

//  ItemRenderer<String> get itemRenderer => _displayNameRenderer;

  final initialCashOptions = [0, 10, 100, 1000];

  final dailyDisposableOptions = [0, 2, 4, 10];

  final interestRateOptions = [1, 3, 5, 10];

  final yearsOptions = [0, 0, 0];

  final sexOptions = ['Male', 'Female'];
  String msex;
  final _settingsChanged = StreamController<Null>();

  Date date = Date.today();
  Date optionalDate;
  DateRange limitToRange = DateRange(
      Date.today().add(years: -100), Date.today().add(years: -15));
//  StringSelectionOptions<String> get languageOptions => countryListOptions;
//  ExampleSelectionOptions<String> countryListOptions = ExampleSelectionOptions<String>(_countries);
  String userName = "TUEHNASDKK";
  @Output()
  Stream<Null> get settingsChanged => _settingsChanged.stream;

  @Input()
  Settings settings;

  @Input()
  DatabaseService dbService;

  int initialCash;

  int dailyDisposable;

  bool isInvesting = true;

  int interestRate;

  int years;

  Lottery lottery;

  Strategy strategy;
  String saveText = 'Edit';

  @override
  void ngOnInit() {
    resetWallet();
    resetBetting();
    resetOther();
  }


  bool isDisabled(){
//    print("EDITING  ${dbService.editing}");
    return dbService.editing == false;
  }
  String getSaveText(){
    return (dbService.editing == true) ? 'Save' : 'Edit';
  }

  bool closeOnSave(){
    bool result = (dbService.editing == true) ? true : false;
    return result;
  }

  void onSave1(NgForm form) {
    form.value['sex-edit'] = msex;
    form.value['dob-edit'] = optionalDate;
    form.value['country-edit'] = singleSelectLanguageLabel != 'Select Nationality' ? singleSelectLanguageLabel : null;
    dbService.updatePrimary(form.value);
  }

  void onClear(NgForm form) {
    form.control.reset();
  }
  void toggle(NgForm form){
//    form.control.reset();
    dbService.gotToSaveMode(form.value);
    lottery = settings.lottery;
    strategy = settings.strategy;
  }

  void onSave2(NgForm form) {
    dbService.updateBankDetails(form.value);
  }

  void onSave3(NgForm form) {
    dbService.updateInsuranceDetails(form.value);
  }

  void onSave4(NgForm form) {
    dbService.updateEmergencyDetails(form.value);
  }

  void resetBetting() {
    lottery = settings.lottery;
    strategy = settings.strategy;
  }

  void resetWallet() {
    initialCash = settings.initialCash;
    dailyDisposable = settings.dailyDisposable;
  }

  void resetOther() {
    if (settings.interestRate == 0) {
      isInvesting = false;
    } else {
      isInvesting = true;
      interestRate = settings.interestRate;
    }
    years = settings.years;
  }

  void settingsUpdated() {
    settings.initialCash = initialCash;
    settings.dailyDisposable = dailyDisposable;
    settings.lottery = lottery;
    settings.strategy = strategy;
    settings.interestRate = isInvesting ? interestRate : 0;
    settings.years = years;
    _settingsChanged.add(null);
  }

  static List<Country> fillList(){
    final List<Country> results = <Country>[];
    for(int i = 0; i < _countries.length; i++){
      String curr = _countries[i];
      String code = curr.substring(0,2);
      String label = curr;
      results.add(Country(code, label));
    }
    return results;
  }
  static final List<Country> _languagesList = fillList();

  static List<OptionGroup<Country>> _languagesGroups = <OptionGroup<Country>>[
    OptionGroup<Country>.withLabel(const <Country>[
      Country('en-US', 'US English'),
      Country('fr-CA', 'Canadian English'),
    ], 'North America'),
    OptionGroup<Country>.withLabel(const <Country>[
      Country('ny', 'Chinese (Simplified)'),
      Country('zh', 'Chinese (Traditional)')
    ], 'Asia'),
    OptionGroup<Country>.withLabel(const <Country>[
      Country('en-UK', 'UK English'),
      Country('de', 'German')
    ], 'Europe'),
    OptionGroup<Country>.withLabel(
        const <Country>[], 'Antarctica', 'No languages'),
    // This group will not be rendered.
    OptionGroup<Country>.withLabel(const <Country>[], 'Pangaea')
  ];


  static ItemRenderer<Country> _displayNameRenderer =
      (HasUIDisplayName item) => item.uiDisplayName;

  // Specifying an itemRenderer avoids the selected item from knowing how to
  // display itself.
  static ItemRenderer<Country> _itemRenderer =
  newCachingItemRenderer<Country>(
          (country) => "${country.label} (${country.code})");

  bool useFactoryRenderer = false;
  bool useItemRenderer = false;
  bool useLabelFactory = false;
  bool useOptionGroup = false;
  bool withHeaderAndFooter = false;
  bool popupMatchInputWidth = true;
  bool visible = false;
  bool deselectOnActivate = true;
  String deselectLabel = 'None';

  /// Languages to choose from.
  ExampleSelectionOptions<Country> languageListOptions =
  ExampleSelectionOptions<Country>(_languagesList);

  ExampleSelectionOptions<Country> languageGroupedOptions =
  ExampleSelectionOptions<Country>.withOptionGroups(_languagesGroups);

  StringSelectionOptions<Country> get languageOptions =>
      useOptionGroup ? languageGroupedOptions : languageListOptions;

  /// Single Selection Model
  final SelectionModel<Country> singleSelectModel =
  SelectionModel.single(selected: _languagesList[0]);

  /// Label for the button for single selection.
  String get singleSelectLanguageLabel =>
      singleSelectModel.selectedValues.length > 0
          ? itemRenderer(singleSelectModel.selectedValues.first)
          : 'Select Nationality';

  /// Multi Selection Model
  final SelectionModel<Country> multiSelectModel =
  SelectionModel<Country>.multi();

  String get singleSelectedLanguage =>
      singleSelectModel.selectedValues.isNotEmpty
          ? singleSelectModel.selectedValues.first.uiDisplayName
          : null;

  /// Currently selected language for the multi selection model
  String get multiSelectedLanguages =>
      multiSelectModel.selectedValues.map((l) => l.uiDisplayName).join(',');

  ItemRenderer<Country> get itemRenderer =>
      useItemRenderer ? _itemRenderer : _displayNameRenderer;

//  FactoryRenderer get factoryRenderer =>
//      useFactoryRenderer ? (_) => demo.ExampleRendererComponentNgFactory : null;
//
//  FactoryRenderer get labelFactory => useLabelFactory
//      ? (_) => demo.ExampleLabelRendererComponentNgFactory
//      : null;

  /// Label for the button for multi selection.
  String get multiSelectLanguageLabel {
    var selectedValues = multiSelectModel.selectedValues;
    if (selectedValues.isEmpty) {
      return 'Select Nationality';
    } else if (selectedValues.length == 1) {
      return itemRenderer(selectedValues.first);
    } else {
      return "${itemRenderer(selectedValues.first)} + ${selectedValues.length - 1} more";
    }
  }


  Country selectionValue;
  List<Country> selectionValues = [];
  String get selectionValuesLabel {
    final size = selectionValues.length;
    if (size == 0) {
      return 'Select Nationality';
    } else if (size == 1) {
      return itemRenderer(selectionValues.first);
    } else {
      return "${itemRenderer(selectionValues.first)} + ${size - 1} more";
    }
  }

  String selectionOption;
}

class Country implements HasUIDisplayName {
  final String code;
  final String label;
  const Country(this.code, this.label);
  @override
  String get uiDisplayName => label;

  @override
  String toString() => uiDisplayName;
}

/// If the option does not support toString() that shows the label, the
/// toFilterableString parameter must be passed to StringSelectionOptions.
class ExampleSelectionOptions<T> extends StringSelectionOptions<T> implements Selectable {
  ExampleSelectionOptions(List<T> options)
      : super(options, toFilterableString: (T option) => option.toString());
  ExampleSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups)
      : super.withOptionGroups(optionGroups,
      toFilterableString: (T option) => option.toString());
  @override
  SelectableOption getSelectable(item) =>
      item is String
          ? SelectableOption.Disabled
          : SelectableOption.Selectable;
}

