// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

class Paginator<T> {
  final int limit;
  final int offSet;
  final String sort;
  final int totalRows;
  final int totalPages;
  final int page;
  final List<T> rows;
  Paginator({
    required this.limit,
    required this.offSet,
    required this.sort,
    required this.totalRows,
    required this.totalPages,
    required this.page,
    required this.rows,
  });

  factory Paginator.fromMap(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic>) fromMapT,
  ) {
    return switch (map) {
      {
        'limit': final int limit,
        'offset': final int offSet,
        'sort': final String sort,
        'total_rows': final int totalRows,
        'total_pages': final int totalPages,
        'page': final int page,
        'rows': final List rows
      } =>
        Paginator(
          limit: limit,
          offSet: offSet,
          sort: sort,
          totalRows: totalRows,
          totalPages: totalPages,
          page: page,
          rows: rows
              .map<T>(
                (e) => fromMapT(e),
              )
              .toList(),
        ),
      _ => throw ArgumentError()
    };
  }

  factory Paginator.fromJson(
    String source,
    T Function(Map<String, dynamic>) fromMapT,
  ) =>
      Paginator.fromMap(json.decode(source) as Map<String, dynamic>, fromMapT);
}
