import 'package:hive/hive.dart';

abstract class IHiveModel extends HiveObject{
  /// A custom key specific to the [IHiveModel] object.
  ///
  /// This key is used when putting a [IHiveModel] object into the hive box.
  String get mapKey;
}