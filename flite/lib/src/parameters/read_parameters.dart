class ReadParameters {
  /// When set to true ensures each row is unique.
  final bool? distinct;

  /// The columns to return
  final List<String>? columns;

  /// Filters which rows to return. Passing null will return all rows
  /// for the given URL. '?'s are replaced with the items in the
  /// [whereArgs] field.
  final String? where;
  final List<Object?>? whereArgs;

  // Declares how to group rows. Passing null
  /// will cause the rows to not be grouped.
  final String? groupBy;

  /// Declares which row groups to include in the cursor,
  /// if row grouping is being used. Passing null will cause
  /// all row groups to be included, and is required when row
  /// grouping is not being used.
  final String? having;

  // Declares how to order the rows,
  /// Passing null will use the default sort order,
  /// which may be unordered.
  final String? orderBy;

  /// Limits the number of rows returned by the query
  final int? limit;

  /// Specifies the starting index.
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
