import 'dart:async';
import 'material_tree_demo_options.dart' as data;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

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
  providers: [const ClassProvider(WeeksService)],
)
class WeeksComponent implements OnInit {
  final WeeksService weeksService;

  List<String> items = [];

  WeeksComponent(this.weeksService);

  @override
  Future<Null> ngOnInit() async {
    items = await weeksService.getWeeksList();
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
  void add() {
    List options = ['[August]', '[September]', '[October]', '[November]', '[December]'];
    String value = singleSelection.selectedValues.toString();
    if(!options.contains(value)) {
      items.add(value);
      String newWeek = '';
    }
  }

}
