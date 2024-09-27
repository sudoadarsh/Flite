A lightweight SQLite ORM for Flutter.

## Getting started

This package automatically creates extensions for your Dart classes (which reflect database tables) with SQLite CRUD operations, as well as serialization and deserialization capabilities. Simply mix your classes with the [`FliteProvider`](https://pub.dev/documentation/flite/latest/flite/FliteProvider-mixin.html) mixin and annotate it with the [`Schema`](https://pub.dev/documentation/flite/latest/flite/Schema-class.html).

## Usage

Let's assume a SQLite table named `Task` with the following structure.

| Column       | Type           | Constraints                               |
|--------------|----------------|-------------------------------------------|
| id           | INT            | NOT NULL                                  |
| title        | TEXT           | NOT NULL                                  |
| description  | TEXT           |                                           |
| userId       | INT            | FOREIGN KEY REFERENCES User(id) ON DELETE CASCADE ON UPDATE CASCADE |

### Step 1: Create a Dart Class

Define a Dart class that mirrors the structure of the `Task` table.
```dart
import 'package:flite/flite.dart';
part 'task_model.g.dart'; // Required for generating the extension.

@Schema(name: 'Task')
class TaskModel with FliteProvider {
  @primary
  final int id;

  final String title;

  final String? description;

  @Foreign("User", "id")
  final int? userId;

  @ignore
  bool isSelected = false;

  // A constructor with named parameters is required.
  TaskModel(
      {required this.id, required this.title, this.description, this.userId});
}
```
### Step 2: Add flite_generator package

Run the following command to add [`flite_generator`](https://pub.dev/packages/flite_generator) as a development dependency.
```
flutter pub add --dev flite_generator
```
### Step 3: Auto generate the extension.

Run the following command to auto generate the extension for `TaskModel` class.
```
dart run build_runner build
```
The following file would be generated.
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// Generator: SchemaBuilder
// **************************************************************************

extension TaskModelFliteExtension on TaskModel {
  /// The name of the table.
  String get table => 'Task';

  /// The SQLite schema for creating the `Task` table.
  static String get schema {
    return '''CREATE TABLE IF NOT EXISTS Task(
		id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
		title TEXT NOT NULL,
		description TEXT,
		userId INTEGER,,
		FOREIGN KEY (userId) REFERENCES User(id) ON DELETE CASCADE ON UPDATE CASCADE
		''';
  }

  /// Create the `Task` table.
  static Future<void> init(final Database database) async {
    return FliteProvider.create_(database, schema);
  }

  /// Deserializes a Json into a `TaskModel`.
  static TaskModel deserialize(final Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      userId: json['userId'],
    );
  }

  /// Serializes the `TaskModel` into Json.
  Map<String, dynamic> serialize() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId
    };
  }

  /// Inserts into the table and returns the id of the last created row.
  Future<int> insert(final InsertParameters params) async {
    return insert_(table, serialize(), params);
  }

  /// Update the rows of the table and returns the number of changes made.
  Future<int> update(final UpdateParameters params) async {
    return update_(table, serialize(), params);
  }
}
```