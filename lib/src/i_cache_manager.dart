import 'package:hive/hive.dart';
import 'i_hive_model.dart';

abstract class ICacheManager<T extends IHiveModel> {
  /// The name that is used when opening a hive box.
  final String _boxName;
  /// The hive box that is used to store key-value pairs.
  late Box<T> _hiveBox;

  /// The number of entries in the box.
  int get hiveBoxLength => _hiveBox.length;

  /// Whether this box is currently open.
  ///
  /// Most of the operations on a box require it to be open.
  bool get isHiveBoxOpen => _hiveBox.isOpen;

  /// Whether there are no entries in the hive box.
  bool get isHiveBoxEmpty => _hiveBox.isEmpty;

  /// Whether there are entries in the hive box.
  bool get isHiveBoxNotEmpty => _hiveBox.isNotEmpty;

  /// The location of the box in the file system.
  ///
  /// In the browser, it returns null.
  String? get hiveBoxPath => _hiveBox.path;

  /// The name of the box.
  ///
  /// Names are always lowercase.
  String get hiveBoxName => _hiveBox.name;

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
  Future<void> addItems({required Iterable<T> items}) async {
    await _hiveBox.addAll(items);
  }

  /// Adds a [T] type object to the hive box with a autoincrement key.
  Future<void> addItem({required T item}) async {
    await _hiveBox.add(item);
  }

  //------add value(s) with model specific keys------

  /// Adds a list of [T] type objects to the hive box with model specific keys.
  ///
  /// Model specific key is defined in [mapKey] computed property in the [T] type class (model class).
  Future<void> putItems({required Iterable<T> items}) async {
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
  Future<void> putItem({required T item}) async {
    await _hiveBox.put(item.mapKey, item);
  }

  //------read value(s)------

  /// Reads all the [T] type values in the hive box.
  Iterable<T> getValues() {
    return _hiveBox.values;
  }

  /// Returns all the keys in the hive box.
  ///
  /// The keys are sorted alphabetically in ascending order.
  Iterable<dynamic> getKeys() {
    return _hiveBox.keys;
  }

  /// Reads the [T] type value in the hive box for a given [key].
  ///
  /// If the [key] doesn't exist, null is returned.
  T? getItem({required dynamic key}) {
    return _hiveBox.get(key);
  }

  /// Returns all values starting with the value associated with startKey (inclusive) to the value associated with endKey (inclusive).
  ///
  /// If startKey does not exist, an empty iterable is returned.
  /// If endKey does not exist or is before startKey, it is ignored.
  /// The values are in the same order as their keys
  Iterable<T> getValuesBetween({required dynamic startKey, required dynamic endKey}) {
    return _hiveBox.valuesBetween(startKey: startKey, endKey: endKey);
  }

  /// Checks whether the hive box contains the key.
  bool containsKey({required dynamic key}) {
    return _hiveBox.containsKey(key);
  }

  //------delete value(s)------

  /// Deletes all the given [keys] from the hive box.
  ///
  /// If a key inside the [keys] doesn't exist, nothing happens.
  Future<void> removeItems({required Iterable<dynamic> keys}) async {
    await _hiveBox.deleteAll(keys);
  }

  /// Deletes the given [key] from the hive box.
  ///
  /// If the [key] doesn't exist, nothing happens.
  Future<void> removeItem({required dynamic key}) async {
    await _hiveBox.delete(key);
  }

  /// Deletes all the key-value pairs from the hive box.
  Future<void> clearAll() async {
    await _hiveBox.clear();
  }

  /// Closes all instances of the  hive box.
  ///
  /// The box should not be accessed anywhere else after the [closeBox] method call.
  Future<void> closeBox() async {
    await _hiveBox.close();
  }

  /// Closes and deletes the hive box in the device or IndexedDB.
  Future<void> deleteBox() async {
    await _hiveBox.deleteFromDisk();
  }
}
