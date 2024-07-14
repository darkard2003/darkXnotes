import 'dart:async';

import 'package:awesome_notes/bloc/auth_bloc/auth_bloc.dart';
import 'package:awesome_notes/dialog/conformation_dialog.dart';
import 'package:awesome_notes/dialog/setting_dialog.dart';
import 'package:awesome_notes/models/note_model.dart';
import 'package:awesome_notes/models/user_data_model.dart';
import 'package:awesome_notes/screens/note_screen/note_screen_state.dart';
import 'package:awesome_notes/screens/note_screen/note_state.dart';
import 'package:awesome_notes/services/auth/local_auth.dart';
import 'package:awesome_notes/services/cloud_database/cloud_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:quick_actions/quick_actions.dart';

class NoteScreenVm extends Cubit<NoteScreenState> {
  final UserData user;
  late final AuthBloc authBloc;
  final BuildContext context;
  final CloudDatabase cloud = CloudDatabase();
  final localAuth = LocalAuth();
  late final StreamSubscription<List<Note>> _noteStreamSubscription;

  NoteScreenVm({
    required this.user,
    required this.context,
  }) : super(const NoteScreenState(
          notes: [],
          loading: true,
        )) {
    authBloc = BlocProvider.of<AuthBloc>(context);
    if (!kIsWeb) _setupQuickActions();
    init();
  }

  Future<void> init() async {
    var noteStream = cloud.getNotes(user.id);
    var notes = await noteStream.first;
    emit(state.copyWith(notes: notes.map((e) => NoteState(e)).toList()));
    _noteStreamSubscription = noteStream.listen((notes) {
      emit(state.copyWith(notes: notes.map((e) => NoteState(e)).toList()));
    });
    emit(state.copyWith(loading: false));
  }

// setup quick actions
  void _setupQuickActions() async {
    const quickActions = QuickActions();
    quickActions.initialize((action) {
      if (action == 'new_note') {
        createNote();
      } else if (action == 'logout') {
        _logout();
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: 'new_note',
        localizedTitle: 'New Note',
        icon: 'newnote',
      ),
      const ShortcutItem(
        type: 'logout',
        localizedTitle: 'Logout',
        icon: 'logout',
      ),
    ]);
  }

  void doSettingAction(SettingActions? action) async {
    if (action != null) {
      switch (action) {
        case SettingActions.logout:
          _logout();
          break;
        case SettingActions.deleteAll:
          _deleteAll();
          break;
        case SettingActions.cancel:
          return;
      }
    }
  }

  Future<void> openSettingsDialog() async {
    final action = await showSettingDialog(context, user);
    if (action != null) doSettingAction(action);
  }

  void _deleteAll() async {
    final shouldDelete = await showConformationDialog(
        context: context,
        title: 'Delete ',
        content: 'Are you sure you want to delete all notes?');
    if (shouldDelete ?? false) {
      emit(state.copyWith(loading: true));
      await cloud.deleteAllNotes(user.id);
      emit(state.copyWith(loading: false));
    }
  }

  void _logout() async {
    final shouldLogout = await showConformationDialog(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
    );
    if (shouldLogout ?? false) {
      authBloc.add(const AuthEventLogout());
    }
  }

  Future<void> openEditNote(Note note, {bool update = true}) async {
    final delete = await Navigator.of(context).pushNamed('/update', arguments: {
      'note': note,
      'uid': user.id,
      'db': cloud,
      'update': update,
    }) as bool?;
    if (delete ?? false) deleteNote(note);
  }

  void createNote({Type type = Type.text}) async {
    final note = Note.newNote(type: type, isHidden: state.hidden);
    await openEditNote(note, update: false);
  }

  void updateNote(Note note) async {
    await openEditNote(note);
  }

  void deleteNote(Note note) async {
    await cloud.deleteNote(note, user.id);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              cloud.createNote(note, user.id);
            }),
      ),
    );
  }

  void toggleHidden() async {
    if (state.hidden) {
      emit(state.copyWith(hidden: !state.hidden));
      return;
    }
    bool authSupported = await localAuth.isSupported();
    if (!authSupported) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Authentication not supported on this device'),
        ),
      );
      return;
    }
    bool authenticated = await localAuth.authenticate();
    if (authenticated) {
      emit(state.copyWith(hidden: !state.hidden));
    }
  }

  @override
  Future<void> close() async {
    await _noteStreamSubscription.cancel();
    super.close();
  }
}
