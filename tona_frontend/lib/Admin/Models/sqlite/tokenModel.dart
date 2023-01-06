import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Tokening {
  final int? id;
  final String? accesstok;
  final String? refreshtok;
  // final String long;
  // final int age;

  const Tokening({
    @required this.id,
    @required this.accesstok,
    @required this.refreshtok,
  });

  factory Tokening.fromMap(Map<String, dynamic> json) => new Tokening(
        id: json['id'],
        accesstok: json['accesstok'],
        refreshtok: json['refreshtok'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'accesstok': accesstok,
      'refreshtok': refreshtok,
    };
  }
}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'Tokens.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Tokens(
          id INTEGER PRIMARY KEY,
          accesstok TEXT,
          refreshtok TEXT
      )
      ''');
  }

  // Future<List<Tokening>> getTokens() async {
  //   Database db = await instance.database;
  //   var add = await db.query('Tokens', orderBy: 'uid');
  //   List<Tokening> addList =
  //       add.isNotEmpty ? add.map((c) => Tokening.fromMap(c)).toList() : [];
  //   return addList;
  // }

  Future<int> add(Tokening tok) async {
    Database db = await instance.database;
    return await db.insert('Tokens', tok.toMap());
  }

  //deleting
  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('Tokens', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Tokening tok) async {
    Database db = await instance.database;
    return await db
        .update('Tokens', tok.toMap(), where: "id = ?", whereArgs: [tok.id]);
  }
}
