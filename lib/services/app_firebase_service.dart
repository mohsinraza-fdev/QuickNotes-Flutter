import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:quicknotes/app/app.router.dart';
import 'package:quicknotes/app/locator.dart';
import 'package:quicknotes/models/note_model.dart';
import 'package:quicknotes/models/user_model.dart';
import 'package:quicknotes/services/misc_service.dart';
import 'package:quicknotes/services/storage_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@lazySingleton
class AppFirebaseService {
  final _storageService = locator<StorageService>();
  final _navigator = locator<NavigationService>();
  final _miscService = locator<MiscService>();

  final _authInstance = FirebaseAuth.instance;
  final _firestoreInstace = FirebaseFirestore.instance;

  register({required String email, required String password}) async {
    try {
      UserCredential result = await _authInstance
          .createUserWithEmailAndPassword(email: email, password: password);
      _storageService.user = AppUser(
        email: result.user!.email.toString(),
        password: password,
        uid: result.user!.uid,
      );

      //Save User to local storage
      _miscService.showLoadingMessage = 'Creating account';
      await _storageService.saveDataLocal();

      //Create cloud storage profile
      await _firestoreInstace
          .collection('Users')
          .doc(_storageService.user!.uid)
          .set({'email': email});
      await _firestoreInstace
          .collection('Users')
          .doc(_storageService.user!.uid)
          .collection('Notes')
          .add({});
      _navigator.clearStackAndShow(Routes.wrapper);
      _miscService.newlyRegistered = true;
      //Navigate to wrapper
    } on FirebaseException catch (e) {
      //dynamic x = RegExp(r" (.*)").firstMatch(e.toString());
      //throw (e.toString().substring(x.start, x.end));

      try {
        await _authInstance.currentUser!.delete();
        await _storageService.reset();
      } catch (e) {}
      throw (e);
    }
  }

  saveDataCloud() async {
    var onlineWith = await (Connectivity().checkConnectivity());
    if (onlineWith == ConnectivityResult.mobile ||
        onlineWith == ConnectivityResult.wifi) {
      try {
        List<InternetAddress> result =
            await InternetAddress.lookup('example.com')
                .timeout(Duration(seconds: 2));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          final CollectionReference userNotes = _firestoreInstace
              .collection('Users')
              .doc(_storageService.user!.uid)
              .collection('Notes');
          await userNotes.get().then((snapshot) {
            for (DocumentSnapshot ds in snapshot.docs) {
              ds.reference.delete();
            }
          });
          final CollectionReference usernotes = _firestoreInstace
              .collection('Users')
              .doc(_storageService.user!.uid)
              .collection('Notes');
          int counter = -1;
          for (Note note in _storageService.user!.notes) {
            counter++;
            usernotes.doc(counter.toString()).set({
              'text': note.text,
              'title': note.title,
              'color': note.colorName,
              'index': counter
            });
          }
          _storageService.commitChanges(false);
        }
      } catch (e) {
        throw (e);
      }
    }
  }

  login({required String email, required String password}) async {
    try {
      UserCredential result = await _authInstance.signInWithEmailAndPassword(
          email: email, password: password);
      _storageService.user = AppUser(
        email: result.user!.email.toString(),
        password: password,
        uid: result.user!.uid,
      );
      _miscService.showLoadingMessage = 'Loading Data';
      await loadDataCloud();
      await _storageService.saveDataLocal();
      _navigator.clearStackAndShow(Routes.wrapper);
    } on FirebaseException catch (e) {
      throw (e);
    }
  }

  loadDataCloud() async {
    try {
      List<Note> finalList = <Note>[];
      final CollectionReference noteList = _firestoreInstace
          .collection('Users')
          .doc(_storageService.user!.uid)
          .collection('Notes');
      await noteList.orderBy('index').get().then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          finalList.add(Note(
              text: ds.get('text'),
              title: ds.get('title'),
              colorName: ds.get('color')));
        }
      });
      _storageService.user!.setNotes(finalList);
    } on FirebaseException catch (e) {
      throw (e);
    }
  }

  logout() async {
    _miscService.showLoadingMessage = 'Saving Data';
    if (_miscService.saveDataOnline == true) {
      await saveDataCloud();
    }
    await _authInstance.signOut();
    _miscService.saveDataOnline = true;
  }

  forceLogout() async {
    await _authInstance.signOut();
    _firestoreInstace.clearPersistence();
    _miscService.saveDataOnline = true;
  }
}
