import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:favorite_places/models/place.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, 'places.db'),
    onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 1,
  );
  print('database created at : ' + dbPath);
  return db;
}

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super(const []);

  void deletePlace(String id) async {
    state = state.where((place) => place.id != id).toList();
 
    final db = await _getDataBase();
    await db.delete('user_places', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> loadPlaces() async {
    final db = await _getDataBase();
    final data = await db.query('user_places');
    final places = data
        .map(
          (row) => Place(
            id: row['id'] as String,
            title: row['title'] as String,
            image: File(row['image'] as String),
            location: PlaceLocation(
              lantitude: row['lat'] as double,
              longitude: row['lng'] as double,
              address: row['address'] as String,
            ),
          ),
        )
        .toList();
        print(places);
    state = places;
  }

  void addPlace(String title, File img, PlaceLocation loc) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(img.path);
    final copiedImage = await img.copy('${appDir.path}/$filename');

    final newPlace = Place(title: title, image: copiedImage, location: loc);

    final db = await _getDataBase();
    final i = await db.insert(
      'user_places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'lat': newPlace.location.lantitude,
        'lng': newPlace.location.longitude,
        'address' : newPlace.location.address,
      },
    );
    state = [newPlace, ...state];
  }
}

final userPlacesProvider =
    StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
