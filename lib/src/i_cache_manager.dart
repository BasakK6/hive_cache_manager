import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'i_hive_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

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

  /// The key that is used to store encryption value as a key-value pair in the flutter secure storage.
  final String _encryptionKeyName = '_hive_box_encryption_';

  ICacheManager(this._boxName);

  /// Registers the model specific hive adapters and opens a hive box.
  ///
  /// This method must be explicitly called before calling other methods.
  /// The hive box is encrypted with a secure encryption key if [isEncrypted] is true.
  Future<void> init({required bool isEncrypted}) async {
    registerAdapters();

    // apply encryption to the hive box according to isEncrypted and, open the box
    if (isEncrypted == true) {
      var hiveAesCipher = await _encryptionCipher();
      _hiveBox = await Hive.openBox(_boxName, encryptionCipher: hiveAesCipher);
    } else {
      _hiveBox = await Hive.openBox(_boxName);
    }
  }

  /// Registers the type adapter objects necessary for hive.
  void registerAdapters();

  //------encryption------

  /// Returns a cipher created with the stored encryption key.
  Future<HiveAesCipher> _encryptionCipher() async {
    const secureStorage = FlutterSecureStorage();
    // if key doesn't exist, encryptionValue is null
    String? encryptionValue = await secureStorage.read(key: _encryptionKeyName);
    // if there is no key, create one
    encryptionValue ??= await _generateNewEncryptionKey(secureStorage);
    // decode the value
    final decodedEncryptionValue = base64Url.decode(encryptionValue!);
    // return encryption cipher
    return HiveAesCipher(decodedEncryptionValue);
  }

  /// Generates and stores a secure encryption key using the fortuna random algorithm and flutter secure storage.
  ///
  /// Returns the newly generated and stored key.
  Future<String?> _generateNewEncryptionKey(
      FlutterSecureStorage secureStorage) async {
    //generate a key
    final key = Hive.generateSecureKey();
    // save the key to flutter secure storage
    await secureStorage.write(
      key: _encryptionKeyName,
      value: base64UrlEncode(key),
    );
    //read and return the newly created key
    return await secureStorage.read(key: _encryptionKeyName);
  }

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

  //------state management------

  /// Returns a [ValueListenable] which notifies its listeners when an entry in the box changes.
  ///
  /// If [keys] filter is provided, only changes to entries with the specified [keys] notify the listeners.
  ValueListenable<Box<T>> getListenable({List<dynamic>? keys}){
    return _hiveBox.listenable(keys: keys);
  }

  /// Returns a [ValueListenableBuilder] that is connected to the hive box.
  ///
  /// The [buildLayout] function defines how the [data] is used and shown on the user interface.
  /// If [keys] filter is provided, only changes to entries with the specified [keys] notify the listeners.
  /// In addition, if the [keys] parameter is provided, the entries are filtered by [keys] and only the matching entries are sent to the [buildLayout] function.
  /// If no matching entries found, an empty [List] is passed as [data] to the [buildLayout] function.
  ValueListenableBuilder<Box<T>> getValueListenableBuilder({ required Widget Function(List<T> data) buildLayout, List<dynamic>? keys}){
    return ValueListenableBuilder(
      valueListenable: getListenable(keys:keys),
      builder: (context, box, widget) {
        if (keys?.isNotEmpty ?? false) {
          List<T> data = [];
          //filter the data by keys
          for (dynamic itemKey in keys!) {
            if (getItem(key: itemKey) != null) {
              data.add(getItem(key: itemKey) as T);
            }
          }

          return buildLayout(data);
        }

        return buildLayout(getValues().toList());
      },
    );
  }
}
