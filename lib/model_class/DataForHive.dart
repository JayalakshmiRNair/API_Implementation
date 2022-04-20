

import 'package:hive/hive.dart';

part 'DataForHive.g.dart';

@HiveType(typeId: 0)
class DataForHive {
  @HiveField (2)
  late String url;

  @HiveField (3)
  late int width;

  @HiveField (4)
  late int height;

  DataForHive(this.url, this.width, this.height);
}
