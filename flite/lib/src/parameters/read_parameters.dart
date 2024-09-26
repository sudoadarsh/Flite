/// Parameters for reading data from SQLite.
class ReadParameters {
  /// Whether to return only distinct rows.
  final bool? distinct;

  /// The columns to return. If null, returns all columns.
  final List<String>? columns;

  /// The WHERE clause to filter rows.
  final String? where;

  /// Arguments for the WHERE clause.
  final List<Object?>? whereArgs;

  /// The GROUP BY clause to group rows.
  final String? groupBy;

  /// The HAVING clause to filter groups.
  final String? having;

  /// The ORDER BY clause to sort rows.
  final String? orderBy;

  /// The maximum number of rows to return.
  final int? limit;

  /// The offset of the first row to return.
  final int? offset;

  ReadParameters.read({
    this.distinct,
    this.columns,
    this.where,
    this.whereArgs,
    this.groupBy,
    this.having,
    this.orderBy,
    this.limit,
    this.offset,
  });
}
