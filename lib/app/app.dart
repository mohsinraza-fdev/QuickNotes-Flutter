import 'package:quicknotes/ui/views/home/home_view.dart';
import 'package:quicknotes/ui/views/note/note_view.dart';
import 'package:quicknotes/ui/views/wrapper/wrapper_view.dart';
import 'package:stacked/stacked_annotations.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: Wrapper, initial: true),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: NoteView),
  ],
)
class App {}
