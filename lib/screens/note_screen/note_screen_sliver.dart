import 'package:awesome_notes/bloc/auth_bloc/auth_bloc.dart';
import 'package:awesome_notes/dialog/alart_dialog.dart';
import 'package:awesome_notes/dialog/conformation_dialog.dart';
import 'package:awesome_notes/dialog/setting_dialog.dart';
import 'package:awesome_notes/screens/note_screen/sliver_grid_note.dart';
import 'package:awesome_notes/services/cloud_database/cloud_database.dart';
import 'package:awesome_notes/models/user_data_model.dart';
import 'package:awesome_notes/models/note_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../services/auth/local_auth.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:avatars/avatars.dart';

class NotesScreenSliver extends StatefulWidget {
  final UserData user;
  const NotesScreenSliver({super.key, required this.user});

  @override
  State<NotesScreenSliver> createState() => _NotesScreenSliverState();
}

class _NotesScreenSliverState extends State<NotesScreenSliver> {
  late final CloudDatabase cloud;
  late final auth = LocalAuth();
  bool _hidden = false;

// Settings actions
  void _doSettingAction(SettingActions? action) async {
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

  void _deleteAll() async {
    final shouldDelete = await showConformationDialog(
        context: context,
        title: 'Delete ',
        content: 'Are you sure you want to delete all notes?');
    if (shouldDelete ?? false) {
      await cloud.deleteAllNotes(hidden: _hidden);
    }
  }

  void _logout() async {
    final shouldLogout = await showConformationDialog(
      context: context,
      title: 'Logout',
      content: 'Are you sure you want to logout?',
    );
    if (!mounted) return;
    if (shouldLogout ?? false) {
      BlocProvider.of<AuthBloc>(context).add(const AuthEventLogout());
    }
  }

// Create note
  void _createNote({Type type = Type.text}) async {
    final note = Note.newNote(type: type, isHidden: _hidden);
    if (!mounted) return;
    final delete = await Navigator.of(context)
        .pushNamed('/update', arguments: note) as bool?;
    if (delete ?? false) _deleteNote(note);
  }

// Delete note
  _deleteNote(Note note) {
    cloud.deleteNote(note);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              note.id = '';
              cloud.createOrUpdateNote(note);
            }),
      ),
    );
  }

// setup quick actions
  void _setupQuickActions() async {
    const quickActions = QuickActions();
    quickActions.initialize((action) {
      if (action == 'new_note') {
        _createNote();
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

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _setupQuickActions();
    }
    cloud = CloudDatabase.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              elevation: 8,
              title: Text(_hidden ? 'Hidden notes' : 'Notes'),
              actions: [
                Avatar(
                  shape: AvatarShape.circle(18),
                  border: Border.all(
                    color: const Color.fromRGBO(245, 245, 245, 1),
                    width: 2,
                  ),
                  margin: const EdgeInsets.all(10),
                  name: widget.user.name,
                  onTap: () async {
                    try {
                      final action =
                          await showSettingDialog(context, widget.user);
                      if (!mounted) return;
                      _doSettingAction(action);
                    } on Exception catch (e) {
                      if (!mounted) return;
                      showAlartDialog(
                          title: 'Error',
                          content: e.toString(),
                          context: context);
                    }
                  },
                  placeholderColors: [
                    Theme.of(context).colorScheme.primary,
                  ],
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(8),
              sliver: StreamBuilder(
                stream: cloud.getNotes(hidden: _hidden),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(snapshot.error.toString()),
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(),
                    );
                  }
                  final notes = snapshot.data as List<Note>;
                  return SliverNoteGrid(
                      notes: notes,
                      onPress: (note) async {
                        final delete = await Navigator.pushNamed(
                            context, '/update',
                            arguments: note) as bool?;
                        if (delete ?? false) {
                          _deleteNote(note);
                        }
                      },
                      onDismiss: (index) => _deleteNote(notes[index]));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onDoubleTap: () async {
          final isSupported = await auth.isSupported();
          if (!mounted) return;
          if (isSupported) {
            if (_hidden) {
              setState(() {
                _hidden = false;
              });
            } else {
              final authenticated = await auth.authenticate();
              setState(() {
                _hidden = authenticated;
              });
            }
          } else {
            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Authentication not supported'),
                action: SnackBarAction(
                    label: 'Ok',
                    onPressed: () {
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    }),
              ),
            );
          }
        },
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: _createNote,
          child: const Icon(Icons.edit_outlined),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
