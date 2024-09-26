A lightweight SQLite ORM for Flutter.

## Getting started

This package auto-generates extensions for Dart classes, that is mixed with [`FliteProvider`](https://pub.dev/documentation/flite/latest/flite/FliteProvider-mixin.html) and annotated with [`Schema`](https://pub.dev/documentation/flite/latest/flite/Schema-class.html).

## Usage.

Let's assume a SQLite table `Task` with the following structure.

| Column       | Type           | Constraints                               |
|--------------|----------------|-------------------------------------------|
| id           | INT            | NOT NULL                                  |
| title        | TEXT           | NOT NULL                                  |
| description  | TEXT           |                                           |
| userId       | INT            | FOREIGN KEY REFERENCES User(id) ON DELETE CASCADE ON UPDATE CASCADE |

Create a Dart class that is reflective to the above table.
```dart
@Schema(name: 'Task')
class TaskModel with FliteProvider{
  @primary
  final int id;

  final String title;

  final String? description;

  @Foreign("User","id")
  final int? userId;

  @ignore
  bool isSelected = false;

  // A constructor with named parameters is required.
  const Task({required this.id, required this.title, this.description});
}
```