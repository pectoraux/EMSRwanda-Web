import 'dart:async';

import 'package:angular/core.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class WeeksService {
  List<String> mockWeeksList = <String>[];

  Future<List<String>> getWeeksList() async => mockWeeksList;
}
