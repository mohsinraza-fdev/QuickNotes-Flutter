# Quick Notes
## A simple app to create and store text notes

In order to setup the project all you need to do is is clone the repository as a flutter project and connect your firebase project to it and youre good to go.

- Framework: Flutter
- Architecture: MVVM
- Storage: Cloud Firestore
- State Management: Stacked

## Features

- User can Login/Register into the app.
- All the notes written by the user will be saved into the device locally.
- The notes will be uploaded to cloud once they are closed.
- User can only view, create, edit and delete notes of the account he is authenticated with.
- Incase there is conflict between cloud and local copy of notes when app is run in online mode, user will be asked to make a chioce on which one to keep.
#
#
[![N|Solid](https://style.anu.edu.au/_anu/images/icons/icon-google-play-small.png)](https://play.google.com/store/apps/details?id=com.fdev.mohsinraza.quicknotes)