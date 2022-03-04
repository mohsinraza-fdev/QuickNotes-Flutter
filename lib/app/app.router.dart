// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';

import '../ui/views/commit/commit_view.dart';
import '../ui/views/confirmation/confirmation_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/note/note_view.dart';
import '../ui/views/wrapper/wrapper_view.dart';

class Routes {
  static const String wrapper = '/';
  static const String homeView = '/home-view';
  static const String noteView = '/note-view';
  static const String confirmationView = '/confirmation-view';
  static const String commitView = '/commit-view';
  static const all = <String>{
    wrapper,
    homeView,
    noteView,
    confirmationView,
    commitView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.wrapper, page: Wrapper),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.noteView, page: NoteView),
    RouteDef(Routes.confirmationView, page: ConfirmationView),
    RouteDef(Routes.commitView, page: CommitView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    Wrapper: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const Wrapper(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    NoteView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const NoteView(),
        settings: data,
      );
    },
    ConfirmationView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ConfirmationView(),
        settings: data,
      );
    },
    CommitView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const CommitView(),
        settings: data,
      );
    },
  };
}
