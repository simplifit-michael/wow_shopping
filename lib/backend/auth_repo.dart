import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/models/user.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as path;

final authProvider = ChangeNotifierProvider<AuthRepo>((_) {
  late final AuthRepo authRepo;
  final apiService = ApiService(() async => authRepo.token);
  authRepo = AuthRepo(apiService);
  return authRepo;
});

class AuthRepo extends ChangeNotifier {
  AuthRepo(this._apiService);

  final ApiService _apiService;
  late final File _file;
  late User _currentUser;

  Timer? _saveTimer;
  late StreamController<User> _userController;

  Stream<User> get streamUser => _userController.stream;

  User get currentUser => _currentUser;

  Stream<bool> get streamIsLoggedIn => _userController.stream //
      .map((user) => user != User.none);

  bool get isLoggedIn => _currentUser != User.none;

  // FIXME: this should come from storage
  String get token => '123';

  Future<void> create() async {
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      _file = File(path.join(dir.path, 'user.json'));
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
    try {
      if (await _file.exists()) {
        _currentUser = User.fromJson(
          json.decode(await _file.readAsString()),
        );
      } else {
        _currentUser = User.none;
      }
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      _file.delete();
      _currentUser = User.none;
    }
    _userController = StreamController<User>.broadcast(
      onListen: () => _emitUser(_currentUser),
    );
  }

  void _emitUser(User value) {
    _currentUser = value;
    _userController.add(value);
    _saveUser();
  }

  Future<void> login(String username, String password) async {
    try {
      _emitUser(await _apiService.login(username, password));
    } catch (error) {
      // FIXME: show user error, change state? rethrow?
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (error) {
      // FIXME: failed to logout? report to server
    }
    _emitUser(User.none);
  }

  void retrieveUser() {
    // currentUser = apiService.fetchUser();
    // _saveUser();
  }

  void _saveUser() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      if (_currentUser == User.none) {
        try {
          await _file.delete();
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        await _file.writeAsString(json.encode(_currentUser.toJson()));
      }
    });
    notifyListeners();
  }
}
