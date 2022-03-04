import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/src/widgets/scroll_notification.dart';
import 'package:quicknotes/app/locator.dart';
import 'package:quicknotes/services/app_firebase_service.dart';
import 'package:quicknotes/services/misc_service.dart';
import 'package:quicknotes/services/storage_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.router.dart';
import '../../../models/note_model.dart';
import '../../../models/user_model.dart';

class HomeViewModel extends ReactiveViewModel {
  final _storageService = locator<StorageService>();
  final _navigator = locator<NavigationService>();
  final _miscService = locator<MiscService>();
  final _fbService = locator<AppFirebaseService>();
  final _snackbarService = locator<SnackbarService>();

  bool get showLoading => _miscService.showLoadingScreen;
  AppUser get user => _storageService.user!;
  bool get saveDataOnline => _miscService.saveDataOnline;

  List<Note> _filteredNotes = <Note>[];
  List<Note> get filteredNotes => _filteredNotes;

  String searchBarValue = '';

  reorder(int oldIndex, int newIndex) {
    /* if (newIndex > oldIndex) {
      newIndex--;
    } */
    if (filteredNotes.length == user.notes.length) {
      Note o = _storageService.user!.notes[oldIndex];
      _storageService.user!.notes.removeAt(oldIndex);
      _storageService.user!.notes.insert(newIndex, o);
    }
  }

  //int x = 0;

  bool clearController = false;

  void navigateTo(Note item) {
    clearController = true;
    int index = _storageService.user!.notes.indexOf(item);
    _miscService.selectedNoteIndex = index;
    notifyListeners();
    _navigator.navigateTo(Routes.noteView)!.then((value) async {
      filter('');
      if (_miscService.saveDataOnline == true) {
        var onlineWith = await (Connectivity().checkConnectivity());
        if (onlineWith == ConnectivityResult.mobile ||
            onlineWith == ConnectivityResult.wifi) {
          try {
            _fbService.saveDataCloud();
          } catch (e) {}
        }
      }
    });
  }

  void addNote() {
    clearController = true;
    _storageService.user!.addNote();
    _miscService.selectedNoteIndex = 0;
    notifyListeners();
    _storageService.saveDataLocal();
    _storageService.commitChanges(true);
    _navigator.navigateTo(Routes.noteView)!.then((value) async {
      filter('');
      if (_miscService.saveDataOnline == true) {
        var onlineWith = await (Connectivity().checkConnectivity());
        if (onlineWith == ConnectivityResult.mobile ||
            onlineWith == ConnectivityResult.wifi) {
          try {
            _fbService.saveDataCloud();
          } catch (e) {}
        }
      }
    });
    //notifyListeners();
    /* x += 1;
    List<Note> notes = _storageService.user!.notes;
    notes.insert(
        0,
        Note(
            text:
                'Hellasdvdsv sdvf sdv fvsd fvds vfdsgsg sdf gfdsg dfgsd vf sdvf asvd f ear aer ag esr a ehr ads gra g rah d rf sa dfg sdo$x',
            title: 'Title$x'));
    _storageService.user!.setNotes(notes);
 */
    //  filter('');
  }

  void deleteNote(Note item) async {
    /* List<Note> notes = _storageService.user!.notes;
    notes.removeAt(index);
    _storageService.user!.setNotes(notes); */
    int index = _storageService.user!.notes.indexOf(item);
    _storageService.user!.deleteNote(index);
    filter(searchBarValue);
    _storageService.saveDataLocal();
    _storageService.commitChanges(true);
    if (_miscService.saveDataOnline == true) {
      var onlineWith = await (Connectivity().checkConnectivity());
      if (onlineWith == ConnectivityResult.mobile ||
          onlineWith == ConnectivityResult.wifi) {
        try {
          _fbService.saveDataCloud();
        } catch (e) {}
      }
    }
  }

  bool _isLogoutButtonselected = false;
  bool get isLogoutButtonselected => _isLogoutButtonselected;
  set isLogoutButtonSelected(value) {
    _isLogoutButtonselected = value;
    notifyListeners();
  }

  bool noDataFound = false;

  void filter(String value) {
    searchBarValue = value;
    _filteredNotes = <Note>[];
    if (user.notes.length == 0) {
      noDataFound = true;
    } else if (value == '') {
      _filteredNotes = user.notes;
      noDataFound = false;
    } else {
      user.notes.forEach((note) {
        List<String> words = note.text!.split(' ') + note.title!.split(' ');
        List<String> tags = value.split(' ');
        int tagCount = tags.length;
        tags.forEach((tag) {
          bool matched = false;
          words.forEach((word) {
            if (word.toLowerCase().startsWith(tag.toLowerCase())) {
              matched = true;
            }
          });
          if (matched == true) {
            tagCount--;
          }
        });
        if (tagCount == 0) {
          _filteredNotes.add(note);
        }
      });
    }
    notifyListeners();
  }

  double _percentage = 1;
  double get percentage => _percentage;
  set percentage(value) {
    if (value <= 65) {
      if (value == 0.0) {
        _percentage = 1.0;
      } else
        _percentage = 1.0 - (value / 65);
    } else {
      _percentage = 0.0;
    }
    notifyListeners();
  }

  void searchBarHandler(ScrollNotification notification) {
    var x = notification.metrics.extentBefore;
    percentage = x;
  }

  logout() async {
    _miscService.showLoadingMessage = 'Connecting to server';
    _miscService.showLoadingScreen = true;
    var onlineWith = await (Connectivity().checkConnectivity());
    if (onlineWith == ConnectivityResult.mobile ||
        onlineWith == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('example.com')
            .timeout(Duration(seconds: 2));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          await _fbService.logout();
          await _storageService.reset();
          _miscService.showLoadingMessage = '';
          _miscService.showLoadingScreen = false;
          _navigator.clearStackAndShow(Routes.wrapper);
        }
      } catch (_) {
        print('not connected');
        _miscService.showLoadingMessage = '';
        _miscService.showLoadingScreen = false;
        _snackbarService.showSnackbar(
            message: 'Not connected to internet',
            title: 'Logout failed',
            duration: Duration(seconds: 3),
            mainButtonTitle: 'Force',
            onMainButtonTapped: () async {
              await _storageService.reset();
              await _fbService.forceLogout();
              _navigator.clearStackAndShow(Routes.wrapper);
            });
      }
    } else {
      _miscService.showLoadingMessage = '';
      _miscService.showLoadingScreen = false;
      _snackbarService.showSnackbar(
          message: 'Not connected to internet',
          title: 'Logout failed',
          duration: Duration(seconds: 3),
          mainButtonTitle: 'Force',
          onMainButtonTapped: () async {
            await _storageService.reset();
            await _fbService.forceLogout();
            _navigator.clearStackAndShow(Routes.wrapper);
          });
    }
  }

  setUp() {
    if (_miscService.newlyRegistered == true) {
      _snackbarService.showSnackbar(
        title: 'Status',
        message: 'Registration Complete',
        duration: Duration(seconds: 3),
      );
      notifyListeners();
      _miscService.newlyRegistered = false;
    }
  }

  @override
  List<ReactiveServiceMixin> get reactiveServices => [_miscService];
}
