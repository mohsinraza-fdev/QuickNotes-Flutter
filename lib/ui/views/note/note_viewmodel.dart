import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:quicknotes/app/locator.dart';
import 'package:quicknotes/models/note_model.dart';
import 'package:quicknotes/services/app_firebase_service.dart';
import 'package:quicknotes/services/misc_service.dart';
import 'package:quicknotes/services/storage_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NoteViewModel extends BaseViewModel {
  final _storageService = locator<StorageService>();
  final _miscService = locator<MiscService>();
  final _navigator = locator<NavigationService>();
  final _fbService = locator<AppFirebaseService>();

  int get noteIndex => _miscService.selectedNoteIndex;
  Note get note => _storageService.user!.notes[noteIndex];

  final scrollController = ScrollController();

  bool titleInitialized = false;
  bool textInitialized = false;
  FocusNode node1 = FocusNode();
  FocusNode node2 = FocusNode();

  // Try removing await from save dara local call if app starts lagging

  setTitle(String value) async {
    if (value != note.title) {
      Note updatedNote =
          Note(title: value, text: note.text, colorName: note.colorName);
      _storageService.user!.updateNote(noteIndex, updatedNote);
      await _storageService.saveDataLocal();
      _storageService.commitChanges(true);
      notifyListeners();
    }
  }

  setText(String value) async {
    if (value != note.text) {
      Note updatedNote =
          Note(title: note.title, text: value, colorName: note.colorName);
      _storageService.user!.updateNote(noteIndex, updatedNote);
      await _storageService.saveDataLocal();
      _storageService.commitChanges(true);
      notifyListeners();
    }
  }

  setColor(String value) async {
    if (value != note.colorName) {
      Note updatedNote =
          Note(title: note.title, text: note.text, colorName: value);
      _storageService.user!.updateNote(noteIndex, updatedNote);
      await _storageService.saveDataLocal();
      _storageService.commitChanges(true);
      notifyListeners();
    }
  }

  navigateBack() async {
    _navigator.back();
  }

  bool _isPalletBoxOpen = false;
  bool get isPalletBoxOpen => _isPalletBoxOpen;
  set isPalletBoxOpen(bool value) {
    _isPalletBoxOpen = false;
  }

  togglePalletBox() {
    _isPalletBoxOpen = !_isPalletBoxOpen;
  }

  disposeControllers() {
    scrollController.dispose();
    node1.dispose();
    node2.dispose();
  }
}
