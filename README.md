
A wrapper package that lets you write minimum amount of cache related code

![Description Gif](https://github.com/BasakK6/hive_cache_manager/blob/master/readme_assets/hive_cache_manager_description.gif?raw=true)

## Features

* 🤩️ Simple & fast coding
* ❤️ Uses [hive](https://docs.hivedb.dev/#/) for caching
* 🗂 Uses [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) to store encryption key
* 📸 Uses <ins>ValueListenableBuilder</ins> to listen data changes
* 🥳 Makes it easy to store custom models

## Getting started
Add this package to your pubspec.yaml file
```yaml
dependencies:
  hive_cache_manager: latest
```

## Usage

```dart
import 'package:hive_cache_manager/hive_cache_manager.dart';
```

### 1) Create your custom model

Let's say that we want to  store information about books. We can name the dart file **book.dart**

```dart
class Book {
   String isbn;
   String title;
   String author;
   int year;

   //constructor
   Book({required this.title, required this.author,
     required this.year, required this.isbn});
}
```
### 2) Use hive annotations and define the name of your type adapter file 
These steps are necessary for using the [hive](https://pub.dev/packages/hive) package.
* Use **@HiveType** and **@HiveField** annotations. 

* Put <ins>part 'model_file_name.g.dart'</ins> on the top of your model file. 
* (model_file_name must match exactly to your model file's name)

```dart
part 'book.g.dart';

@HiveType(typeId: 1)
class Book {
   @HiveField(0)
   String isbn;
   
   @HiveField(1)
   String title;
   
   @HiveField(2)
   String author;
   
   @HiveField(3)
   int year;

   //constructor
   Book({required this.title, required this.author,
     required this.year, required this.isbn});
}
```
### 3) Generate the type adapter file
Run the command below in your terminal to generate the type adapter for the Book object.
This step is also necessary for using the [hive](https://pub.dev/packages/hive) package.
```
flutter packages pub run build_runner build
```

This will create the model_file_name.g.dart next to your model file. 

![Type Adapter File SS](https://github.com/BasakK6/hive_cache_manager/blob/master/readme_assets/type_adapter_file_ss.png?raw=true)

👍  No need to add "**build_runner**" or "**hive_generator**" packages in your pubspec.yaml. These packages are already included in the hive_cache_manager. Just run the command above.

### 4) Extend your model from IHiveModel

* IHiveModel is a special abstract class in the hive_cache_manager.
* When extended from this class, your model must override the **"mapKey"** computed property. 
* If you want to store your objects with model specific keys, you can use this property to set which key will be used when saving the model object in the hive box.
  * For example, we may select ISBN number as key for the key-value pairs in the hive box.

  > The International Standard Book Number (ISBN) is a numeric commercial book identifier that is intended to be unique.
```dart
import 'package:hive_cache_manager/hive_cache_manager.dart';

@HiveType(typeId: 1)
class Book extends IHiveModel{
  @HiveField(0)
  String isbn;

  @HiveField(1)
  String title;

  @HiveField(2)
  String author;

  @HiveField(3)
  int year;

  //constructor
  Book({required this.title, required this.author,
    required this.year, required this.isbn});

  //define your unique key here
  @override
  String get mapKey => isbn;
}
```

* Alternatively, you can use combination of your properties or any string  you like.
```dart
@override
String get mapKey => "$isbn - $title";
```

* If you want to store your objects with **auto incremented** keys, you may just return an empty string (or any string). In this case, this property <ins>will not be used</ins>. So, it doesn't matter what you return in the mapKey.
```dart
@override
String get mapKey => "";
```

### 5) Create a cache manager class for your model

* **ICacheManager\<T extends IHiveModel>** is a special abstract class in the hive_cache_manager.
* In order to handle hive box operations create one manager class for your model.
* Since we extended our Book class from IHiveModel, we can use it instead of T.
* When extended from ICacheManager, <ins>registerAdapters</ins> method must be overridden.
  * Register an object from your generated type adapter class in this method.
  
```dart
import 'package:hive_cache_manager/hive_cache_manager.dart';
import '../model/book.dart';
import 'package:hive/hive.dart';

class BookCacheManager extends ICacheManager<Book>{
  BookCacheManager(super.boxName);
  
  @override
  void registerAdapters() {
    if(!Hive.isAdapterRegistered(1)){ //1 is the type id of the Book class
      Hive.registerAdapter(BookAdapter()); // If not registered, register the generated BookAdapter here.
    }
  }
}
```

* 🎊 Now, **BookCacheManager** class can handle all the box operations such as putting or deleting a Book object.
* 🎉 **BookCacheManager** also provides a <ins>ValueListenableBuilder</ins> that is connected to the hive box which you put your Book objects into. This way you can listen to the changes on the box without using setState((){}).


### 6) Initialize Hive before using

* This step is also necessary for using the [hive](https://docs.hivedb.dev/#/basics/hive_in_flutter) package.
  * You can initialize it in main before the runApp .

```dart
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
   await Hive.initFlutter("hive_db");
   
   runApp(const MyApp());
}
```

### 7) Create a manager object and explicitly call its init method

* init method runs the registerAdapters() method of the BookCacheManager and then opens a hive box that can store Book objects.
* If the **isEncrypted** parameter is true, it creates an encrypted box without making you write any encryption or flutter_secure_storage related code.
* Use <ins>isEncrypted: false</ins> if you don't want to encrypt your data.
```dart
BookCacheManager bookCacheManager = BookCacheManager("books_hive_box");

// put true if you want an encrypted box
await bookCacheManager.init(isEncrypted: true);
```

### 8) Create some model objects

```dart
Book firstBook = Book(
   title: 'Lord of The Rings - The Fellowship of the Ring',
   author: 'J. R. R. Tolkien',
   year: 1954,
   isbn: '9780618260515',
);

Book secondBook = Book(
   title: 'Lord of The Rings - The Two Towers',
   author: 'J. R. R. Tolkien',
   year: 1954,
   isbn: '9780261102361',
);

Book thirdBook = Book(
   title: 'Lord of The Rings - The Return of the King',
   author: 'J. R. R. Tolkien',
   year: 1955,
   isbn: '9780007136575',
);
```

* 🙋🏼‍♀️Any other Lord of The Rings fan here??

### 9) Do any operation you want on the hive box via the Cache Manager

* <ins>addItem</ins> and <ins>addItems</ins> methods add value(s) with autoincremented keys.
* <ins>putItem</ins> and <ins>putItems</ins> methods add value(s) with model specific keys (uses the <ins>mapKey</ins> property).

Put Examples:

```dart
await bookCacheManager.putItem(item: firstBook);

await bookCacheManager.putItems(items: [firstBook, secondBook, thirdBook]);

//access an item with its mapKey property
await bookCacheManager.removeItem(key: secondBook.mapKey);

await bookCacheManager.removeItems(keys: [firstBook.mapKey, thirdBook.mapKey]);

await bookCacheManager.clearAll();

await bookCacheManager.closeBox();

print(bookCacheManager.getItem(key: thirdBook.mapKey)?.year);

print(bookCacheManager.getValues().length);

print(bookCacheManager.hiveBoxLength);

print(bookCacheManager.isHiveBoxOpen);

print(bookCacheManager.isHiveBoxEmpty);

print(bookCacheManager.isHiveBoxNotEmpty);
```

Add Examples:
```dart
List<Book> books = [firstBook, secondBook, thirdBook];
await bookCacheManager.addItems(items: books);
  
print("${bookCacheManager.getValues().first.isbn} is equal to 9780618260515");

// remove the object named "thirdBook" from the hive box
// since the objects were added with autoincremented keys, the key of the "thirdBook" should be 2 
// (the first item's key is 0)
await bookCacheManager.removeItem(key: 2);

// read the values whose keys start at 0 and ends at 1 (inclusive)
Iterable<Book> otherBooks = bookCacheManager.getValuesBetween(startKey: 0, endKey: 1);
  
// put the remaining model objects in an Iterable
Iterable<Book> remainingBooks = [firstBook, secondBook];

// "otherBooks" and "remainingBooks" should be equal
// override the toString() method in Book class in order to print pretty iterables.
print("$otherBooks  is equal to  $remainingBooks");
```

For more detailed code samples check the Github repo of this project (related links are below):
* [hive_autoincrement_keys_test.dart](https://github.com/BasakK6/hive_cache_manager/blob/master/example/test/hive_autoincrement_keys_test.dart)
* [hive_model_specific_keys_test.dart](https://github.com/BasakK6/hive_cache_manager/blob/master/example/test/hive_model_specific_keys_test.dart) 
* [Example](https://github.com/BasakK6/hive_cache_manager/tree/master/example/lib) project

### 10) Show the data on the UI

<img src="https://github.com/BasakK6/hive_cache_manager/blob/master/readme_assets/book_ui_screen_recording.gif?raw=true" alt="UI screen recording" width="250"/>

<br/>

Here is a screen recording of the [Example](https://github.com/BasakK6/hive_cache_manager/tree/master/example) project. 
The **+** button on the App Bar adds 3 Book objects to the hive box. 
With the help of ValueListenableBuilder, we can listen to the changes on the box. 
On the body of the Scaffold, the data in the box is shown using 3 different ways. 

* The first list shows all the data in the hive box
* The second list was filtered by the keys (Books that have "9780618260515", "9780007136575" <ins>keys</ins> were shown)
* The third list was filtered by a property of the Model Class (only the books that have "1955" in their <ins>year</ins> information were shown)

✔️ Deleting an item from one list is instantly recognized and the change is reflected in all lists.

### How to Use ValueListenableBuilder

Access the ValueListenableBuilder by the "getValueListenableBuilder" method of the cache manager.
```dart
bookCacheManager.getValueListenableBuilder(
   buildLayout: buildBooksLayout,
   keys: filterKeys,
)
```
This method requires 2 parameters. The first one (buildLayout) is a Function that uses the data that is being listened to. Here is the type of the buildLayout parameter: 

```dart
Widget Function(List<T> data) buildLayout
```

In the example project, it was implemented as below:

```dart
Widget buildBooksLayout(List<Book> books) {
    // consume the data here
    // show the data on UI and define your business logic
    return books.isEmpty
        ? const Center(child: Text("There is no data to show"))
        : buildListView(books);
}

Widget buildListView(List<Book> books){
    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        final item = books.elementAt(index);
        return  _BookCard(book: item); 
      },
    );
}
```
(_BookCard is a Stateless widget that defines the UI layout of a Book object. It uses Card and ListTile widgets. You can create any design/layout you like. Check the [_BookCard](https://github.com/BasakK6/hive_cache_manager/blob/master/example/lib/features/books/view/widget/book_card.dart) widget on Github to see the codes.)

The second parameter controls the filtering by key. It's an <ins>optional</ins> parameter. If given, the data in the hive box is filtered by the given keys. And only the filtered data is passed to the buildLayout function.
### Show all the data in the hive box:

Don't provide any keys to show all the data in the hive box.

```dart
Container(
  child: bookCacheManager.getValueListenableBuilder(
      buildLayout: buildBooksLayout,
  ),
)
```

### Filter only specific books and show them:

Provide the keys parameter to filter by keys.
<br/>
<br/>
It automatically filters the Books by their keys and only listens to the changes related to the filtered objects.

```dart
Container(
  child: bookCacheManager.getValueListenableBuilder(
      buildLayout: buildBooksLayout, 
      keys: ["9780618260515", "9780007136575"], //ISBN of The Fellowship of the Ring & The Return of the King
  ),
)
```

### Alternatively, create your own filters in your custom ValueListenableBuilder widget:

Use the cache manager's <ins>getListenable</ins> method to get the ValueListenable. Filter or order your data in the builder method.


```dart
Container(
  child: ValueListenableBuilder(
      valueListenable: bookCacheManager.getListenable(),
      builder: (context, box, widget) {
          List<Book> data = [];

          for (Book book in bookCacheManager.getValues()) {
          //filter the books whose year information is 1995
          //change this filter as needed
              if (book.year == 1955) {
                  data.add(book);
              }
          }
          // you can order your data here as well

          return buildLayout(data);
      },
  ),
)
```


## Additional information

* This package depends on the [<ins>flutter_secure_storage</ins>](https://pub.dev/packages/flutter_secure_storage) package in order the store the encryption key. Be sure to make all the necessary configurations for all platforms (eg. Web and Linux). 
* Also, flutter_secure_storage currently obliges the **minSdkVersion** to be  **>=18**.
* You can also get a **compileSdkVersion** incompatibility while using flutter_secure_storage (it obliges **minSdkVersion >= 33**)
  * Change these properties in your gradle file (/android/app/build.gradle) accordingly. For Flutter 2.8 or later, do the steps below:
  
  1) add these lines in your local.properties file(/android/local.properties):
  ```
      flutter.compileSdkVersion=33
      flutter.minSdkVersion=18
  ```
  2) reference to the newly added version numbers in your gradle file:
  ```
      compileSdkVersion localProperties.getProperty('flutter.compileSdkVersion').toInteger()
      
      minSdkVersion localProperties.getProperty('flutter.minSdkVersion').toInteger()
  ```
* If you find any improvements, consider contributing to this project. All the contributions are welcome & appreciated! Github link: [hive_cache_manager](https://github.com/BasakK6/hive_cache_manager). 
* Lastly, please give a like & star if you find this package helpful 💫

### Licence
The MIT License (MIT)
