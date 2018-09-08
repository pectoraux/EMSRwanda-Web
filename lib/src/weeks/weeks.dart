import 'dart:async';
import 'package:components_codelab/src/services/database_service.dart';

import 'material_tree_demo_options.dart' as data;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:date_utils/date_utils.dart';
import 'weeks_service.dart';

@Component(
  selector: 'weeks-component',
  styleUrls: ['weeks.css'],
  templateUrl: 'weeks.html',
  directives: [
    MaterialTreeComponent,
    MaterialCheckboxComponent,
    MaterialFabComponent,
    MaterialIconComponent,
    materialInputDirectives,
    NgFor,
    NgIf,
  ],
  providers: [ClassProvider(WeeksService), DatabaseService],
)
class WeeksComponent implements OnInit {
  final WeeksService weeksService;

  @Input()
  DatabaseService dbService;

  List<String> items = [];
  List<dynamic> _list;

  WeeksComponent(this.weeksService);

  @override
  Future<Null> ngOnInit() async {
    _list = await dbService.list;
  }

bool isItemEmpty(){
  for(int e = 0; e < _list.length; e++){
    items.add(_list[e].toString());
  }
  return items.isEmpty;
}

  String remove(int index) => items.removeAt(index);
//
//  // See material_tree_nested_multi_demo.dart
//  final SelectionOptions nestedOptions = data.expandStateOptions;
//
//  final SelectionModel multiSelection = new SelectionModel.multi();
//  final ItemRenderer<data.CategoryTargetNode> nameRenderer = (node) => node.name;
//  String itemRenderer(item) => nameRenderer(item);

  // See material_tree_nested_single_parent_selectable_demo.dart
  final SelectionOptions nestedOptions = data.nestedOptions;

  final SelectionModel singleSelection = new SelectionModel.single();
  List<String> months = <String>[
    "",
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  int this_year = DateTime.now().year;
  int this_month = DateTime.now().month;
  int this_day = DateTime.now().day;
  void add() {
    String value = singleSelection.selectedValues.toString();
    List options = [];
    int mextra = 0;
    for (int i = 0; i < 5 + mextra; i++) {
      int idx = (DateTime
          .now()
          .month + i) % 13;
      if (idx != 0) {
        String currMonth = months[idx];
//        print("MONTHS ${idx}");
        options.add('[' + currMonth + ']');
      } else if (idx == 0) {
        mextra = 1;
      }
    }
//    List options = ['[August]', '[September]', '[October]', '[November]', '[December]'];

    if (!options.contains(value) && !items.contains(value) && value != '[]') {
      items.add(value);
      String newWeek = '';
    }
  }

  List getCalendar(){
    List<int> week_from_now = [], months_in_weeks = [];

    for(String wk in items){
      String currMth = wk.split('-')[0].replaceAll('[', '').trim();
      String currWk = wk.split('-')[1].replaceAll(' ', '').replaceAll(']', '').replaceAll('Week', '');
      months_in_weeks.add(monthsFromNow(currMth));
      week_from_now.add(int.parse(currWk)+monthsFromNow(currMth)-1);
    }
//    print("OPTIONS ${items} Week ${week_from_now} Months ${months_in_weeks}");
    return week_from_now;
  }


  void save(){
    List<int> week_from_now = getCalendar();
    List<int> reversed = [];
    week_from_now.add(0);
//    print("UNSORTED ${week_from_now}");
    week_from_now.sort();
    for(int i = week_from_now.length-1; i>= 0; i--){
      reversed.add(week_from_now[i]);
    }
//    print("SORTED ${week_from_now}");
    List<int> _list2 = [];
    for(int i = reversed.first+1; i >= 0; i--){
      _list2.add(i);
    }
//    print("LIST2 ${_list2}");
    dbService.updateCalendar(reversed, _list2);
  }

  int monthsFromNow(String mth){
    int num = 0;
//    print("THIS MONTH ${this_month}");
    for(int k = this_month; k < this_month+5; k++){
      if(k == months.indexOf(mth)){
//        print("${mth} is ${(num*30/7).floor()} weeks away");
        break;
      }else{
//        print("INCREASING k is ${k} mth is ${mth}");
        num += 1;
      }
    }
    return (num*30/7).floor();
  }
}
