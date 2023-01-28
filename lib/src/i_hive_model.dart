import 'package:hive/hive.dart';

/// A type which is used by ICacheManager class.
///
/// Custom model classes should be extended by this class in order to be used by the ICacheManager.
abstract class IHiveModel extends HiveObject {
  /// A custom key specific to the [IHiveModel] object.
  ///
  /// This key is used when putting a [IHiveModel] object into the hive box.
  String get mapKey;
}
