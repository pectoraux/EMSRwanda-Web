// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:angular_components/src/material_tree/material_tree_expand_state.dart';
import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';
import 'package:angular_components/utils/async/async.dart';

final _commonOptionList = [
  'Pinocchio',
  'Fantasia',
  'The Reluctant Dragon',
  'Dumbo',
  'Bambi',
  'Saludos Amigos',
  'Victory Through Air Power',
  'The Three Caballeros',
  'Make Mine Music',
  'Song of the South',
  'Fun and Fancy Free',
  'Melody Time',
  'So Dear to My Heart',
  'The Adventures of Ichabod and Mr. Toad'
];

/// An example data set of non-hierarchical data.
final SelectionOptions simpleFlatOptions =
SelectionOptions.fromList(_commonOptionList);

/// An example data set of non-hierarchical data that is [Filterable].
final SelectionOptions filterableFlatOptions =
StringSelectionOptions(_commonOptionList);

final _commonParentChildrenMap = {
  'August': [
    OptionGroup([
      'August - Week3',
      'August - Week4'
    ])
  ],
  'September': [
    OptionGroup(
        ['September - Week1', 'September - Week2', 'September - Week3', 'September - Week4'])
  ],
  'October': [
    OptionGroup(
        ['October - Week1', 'October - Week2', 'October - Week3', 'October - Week4'])
  ],
  'November': [
    OptionGroup(
        ['November - Week1', 'November - Week2', 'November - Week3', 'November - Week4'])
  ],
  'December': [
    OptionGroup(
        ['December - Week1', 'December - Week2', 'December - Week3', 'December - Week4'])
  ],
};

/// An example data set of hierarchical data.
final SelectionOptions nestedOptions = _NestedSelectionOptions([
  OptionGroup(
      ['August', 'September', 'October', 'November', 'December'])
], _commonParentChildrenMap);

/// A slight restructure of [nestedOptions] to separate "Animated Feature Films"
/// with the other two option groups.
final SelectionOptions nestedOptionsVariation = _NestedSelectionOptions([
  OptionGroup(['Animated Feature Films']),
  OptionGroup(['Live-Action Films']),
  OptionGroup(['Documentary Films']),
], _commonParentChildrenMap);

final SelectionOptions filterableNestedOptions =
_NestedFilterableSelectionOptions([
  OptionGroup(
      ['Animated Feature Films', 'Live-Action Films', 'Documentary Films'])
], _commonParentChildrenMap);

/// An example implementation of [SelectionOptions] with [Parent].
class _NestedSelectionOptions<T> extends SelectionOptions<T>
    implements Parent<T, List<OptionGroup<T>>> {
  final Map<T, List<OptionGroup<T>>> _children;

  _NestedSelectionOptions(List<OptionGroup<T>> options, this._children)
      : super(options);

  @override
  bool hasChildren(T item) => _children.containsKey(item);

  @override
  DisposableFuture<List<OptionGroup<T>>> childrenOf(T parent, [_]) {
    return DisposableFuture<List<OptionGroup<T>>>.fromValue(_children[parent]);
  }
}

class _NestedFilterableSelectionOptions<T extends String>
    extends _NestedSelectionOptions<T> with Filterable {
  @override
  int currentLimit = -1;

  @override
  String currentQuery;

  List<OptionGroup<T>> _unfilteredOptionGroups;

  _NestedFilterableSelectionOptions(
      List<OptionGroup<T>> options, Map<T, List<OptionGroup<T>>> children)
      : super(options, children) {
    _unfilteredOptionGroups = options;
  }

  @override
  DisposableFuture<bool> filter(Object filterQuery, {int limit = -1}) {
    var filteredResults = <OptionGroup<T>>[];
    for (var optionGroup in _unfilteredOptionGroups) {
      var resultOptionGroup = _filterGroup(filterQuery, optionGroup);
      if (resultOptionGroup != null) {
        filteredResults.add(resultOptionGroup);
      }
    }
    super.optionGroups = filteredResults;
    return DisposableFuture.fromValue(true);
  }

  OptionGroup<T> _filterGroup(String filterQuery, OptionGroup<T> group) {
    var options = <T>[];
    for (var option in group) {
      if (option.toLowerCase().startsWith(filterQuery.toLowerCase())) {
        options.add(option);
      }
    }
    return options.isNotEmpty ? OptionGroup(options) : null;
  }

  @override
  set optionGroups(List<OptionGroup<T>> optionGroups) {
    _unfilteredOptionGroups = optionGroups;
    if (currentQuery != null) {
      filter(currentQuery, limit: currentLimit);
    } else {
      super.optionGroups = _unfilteredOptionGroups;
    }
  }
}

/// Example option class to show restoring expansion state.
///
/// The data is stored in a tree of [CategoryNodes] extending [Category], which
/// is provided as an option tree to the Material Tree through
/// [NestedCategoryOptions] by implementing [Parent].

class Category {
  String name;
  bool isSelected = false;
  Category(this.name);
}

class CategoryNode extends Category with MaterialTreeExpandState {
  List<CategoryNode> children;
  CategoryNode(String name, this.children) : super(name);
}

class NestedCategoryOptions extends SelectionOptions<CategoryNode>
    implements Parent<CategoryNode, List<OptionGroup<CategoryNode>>> {
  NestedCategoryOptions(List<OptionGroup<CategoryNode>> options)
      : super(options);
  @override
  DisposableFuture<List<OptionGroup<CategoryNode>>> childrenOf(
      CategoryNode parent,
      [_]) =>
      DisposableFuture.fromValue([OptionGroup(parent.children)]);

  @override
  bool hasChildren(CategoryNode item) => item.children.isNotEmpty;
}

var _ctn = (String name,
    [List<CategoryNode> subCategories = const <CategoryNode>[]]) =>
    CategoryNode(name, subCategories);

NestedCategoryOptions expandStateOptions() => NestedCategoryOptions([
  OptionGroup([
    _ctn('Action/Adventure', [
      _ctn('Adventure', [
        _ctn('Survival'),
        _ctn('Fantasy', [_ctn('Medieval'), _ctn('Modern-day Fantasy')])
      ]),
      _ctn('Action', [_ctn('Thriller'), _ctn('Chessboxing')])
    ]),
    _ctn('Animated', [
      _ctn('2D Animated',
          [_ctn('Childrens\' Animation'), _ctn('Adults\' Animation')]),
      _ctn('3D Animated', [_ctn('Disney Movies'), _ctn('Pixar Movies')]),
      _ctn('Claymation')
    ]),
    _ctn('Horror',
        [_ctn('Paranormal'), _ctn('Disaster'), _ctn('Psychological')])
  ])
]);