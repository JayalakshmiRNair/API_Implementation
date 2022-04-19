

import 'package:hive/hive.dart';

part 'DataForHive.g.dart';

@HiveType(typeId: 0)
class DataForHive {

  @HiveField (0)
  late Assets assets;

  DataForHive(this.assets);
}

@HiveType(typeId: 1)
class Assets {

  @HiveField (1)
  late Preview1000 _preview1000;

  Assets(this._preview1000);
}


@HiveType(typeId: 2)
class Preview1000 {

  @HiveField (2)
  late String url;

  @HiveField (3)
  late int width;

  @HiveField (4)
  late int height;

  Preview1000(this.url, this.width, this.height);
}