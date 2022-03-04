import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';

import '../models/note_model.dart';
import '../models/user_model.dart';

@lazySingleton
class StorageService {
  AppUser? user;

  //Method for saving user data
  saveDataLocal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (user != null) {
      pref.setString('email', user!.email);
      pref.setString('password', user!.password);
      pref.setString('uid', user!.uid);
      List<String> texts = [];
      List<String> titles = [];
      List<String> colors = [];

      for (var note in user!.notes) {
        texts.add(note.text.toString());
        titles.add(note.title.toString());
        colors.add(note.colorName.toString());
      }
      pref.setStringList('texts', texts);
      pref.setStringList('colors', colors);
      pref.setStringList('titles', titles);
    }
  }

  //Method for loading user data
  loadDataLocal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString('email').toString();
    String password = pref.getString('password').toString();
    String uid = pref.getString('uid').toString();
    List<String> titles = pref.getStringList('titles')!;
    List<String> texts = pref.getStringList('texts')!;
    List<String> colors = pref.getStringList('colors')!;

    if (email.contains('.com') && email.contains('@')) {
      AppUser loadedUser = AppUser(email: email, password: password, uid: uid);
      int count = -1;
      for (String title in titles) {
        count++;
        loadedUser.notes.add(Note(
            title: titles[count],
            text: texts[count],
            colorName: colors[count]));
      }
      user = loadedUser;
    } else {
      user = null;
    }
  }

  //Method to reset local storage
  reset() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    await initialize();
    user = null;
  }

  commitChanges(bool change) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('change', change);
  }

  Future<bool> getChanges() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool change = pref.getBool('change')!;
    return change;
  }

  //Method for Initialization
  initialize() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString('email') == null) {
      pref.setString('email', '');
      pref.setString('password', '');
      pref.setString('uid', '');
      pref.setStringList('texts', []);
      pref.setStringList('colors', []);
      pref.setStringList('titles', []);
      pref.setBool('change', false);
    }
  }
}
