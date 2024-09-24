import 'package:flite/flite.dart' show ConflictAlgorithm;

enum TransactionType { insert, update, delete }

class TransactionParameters<T extends Object> {
  final TransactionType type;

  final T? data;

  final ConflictAlgorithm? conflictAlgorithm;

  final String? nullColumnHack;

  final String? where;

  final List<Object?>? whereArgs;

  TransactionParameters.insert(
      {this.data, this.conflictAlgorithm, this.nullColumnHack})
      : type = TransactionType.insert,
        where = null,
        whereArgs = null;

  TransactionParameters.update(
      {this.data, this.conflictAlgorithm, this.where, this.whereArgs})
      : type = TransactionType.update,
        nullColumnHack = null;

  TransactionParameters.delete()
      : type = TransactionType.delete,
        data = null,
        conflictAlgorithm = null,
        nullColumnHack = null,
        where = null,
        whereArgs = null;
}
