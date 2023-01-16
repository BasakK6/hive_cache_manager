import 'package:hive/hive.dart';
import 'i_hive_model.dart';

abstract class ICacheManager<T extends IHiveModel> {
  /// The name that is used when opening a hive box
  final String _boxName;
  /// The hive box that is used to store key-value pairs
  late Box<T> _hiveBox;

  ICacheManager(this._boxName);

  /// Registers the model specific hive adapters and opens a hive box.
  ///
  /// This method must be explicitly called before calling other methods.
  Future<void> init() async {
    registerAdapters();
    _hiveBox = await Hive.openBox(_boxName);
  }

  /// Registers the type adapter objects necessary for hive.
  void registerAdapters();

  //------add value(s) with autoincrement keys------

  /// Adds a list of [T] type objects to the hive box with autoincrement keys.
  Future<void> addItems(Iterable<T> items) async {
    await _hiveBox.addAll(items);
  }

  /// Adds a [T] type object to the hive box with a autoincrement key.
  Future<void> addItem(T item) async {
    await _hiveBox.add(item);
  }

  //------add value(s) with model specific keys------

  /// Adds a list of [T] type objects to the hive box with model specific keys.
  ///
  /// Model specific key is defined in [mapKey] computed property in the [T] type class (model class).
  Future<void> putItems(Iterable<T> items) async {
    await _hiveBox.putAll(
      Map.fromEntries(
        items.map(
              (e) => MapEntry(e.mapKey, e),
        ),
      ),
    );
  }

  /// Adds a [T] type object to the hive box with a model specific key.
  ///
  /// Model specific key is defined in [mapKey] computed property in the [T] type class (model class).
  Future<void> putItem(T item) async {
    await _hiveBox.put(item.mapKey, item);
  }

  //------read value(s)------

  /// Reads all the [T] type values in the hive box.
  Iterable<T> getValues() {
    return _hiveBox.values;
  }

  /// Reads the [T] type value in the hive box for a given [key].
  ///
  /// If the [key] doesn't exist, null is returned.
  T? getItem(dynamic key) {
    return _hiveBox.get(key);
  }

  //------delete value(s)------

  /// Deletes the given [key] from the hive box.
  ///
  /// If the [key] doesn't exist, nothing happens.
  Future<void> removeItem(dynamic key) async {
    await _hiveBox.delete(key);
  }

  /// Deletes all the key-value pairs from the hive box.
  Future<void> clearAll() async {
    await _hiveBox.clear();
  }
}
