import 'package:awesome_notes/dialog/alart_dialog.dart';
import 'package:awesome_notes/models/note_model.dart';
import 'package:awesome_notes/models/user_data_model.dart';
import 'package:awesome_notes/services/cloud_database/cloud_database.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_editing_controller.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNote extends StatefulWidget {
  const CreateUpdateNote({super.key});

  @override
  State<CreateUpdateNote> createState() => _CreateUpdateNoteState();
}

class _CreateUpdateNoteState extends State<CreateUpdateNote> {
  TextNote? _note;
  late final TextEditingController titleController;
  late final DetectableTextEditingController contentController;
  late final CloudDatabase cloud;
  late final UserData user;
  late bool _hidden;

  void _init() {
    cloud = CloudDatabase.currentUser();
    titleController = TextEditingController();
    contentController = DetectableTextEditingController(
      regExp: urlRegex,
      detectedStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Future<void> _initNote() async {
    try {
      _note ??= ModalRoute.of(context)!.settings.arguments as TextNote;
      _hidden = _note!.isHidden;
      titleController.text = _note!.title;
      contentController.text = _note!.content;
      _note = await cloud.createOrUpdateNote(_note!) as TextNote;
    } catch (e) {
      if (!context.mounted) return;
      showAlartDialog(title: 'Error', content: e.toString(), context: context);
    }
  }

  void _dltIfEmp() {
    try {
      if (_note == null) return;
      if (_note!.id.isEmpty) return;
      if (_note!.title.isEmpty && _note!.content.isEmpty) {
        cloud.deleteNote(_note!);
      }
    } catch (e) {
      showAlartDialog(title: 'Error', content: e.toString(), context: context);
    }
  }

  void _share() async {
    try {
      if (_note == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No note selected'),
          ),
        );
      }
      if (_note!.content.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note is empty'),
          ),
        );
        return;
      }
      await Share.share(
        _note!.content,
        subject: _note!.title,
      );
    } catch (e) {
      if (!context.mounted) return;
      showAlartDialog(title: 'Error', content: e.toString(), context: context);
    }
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _dltIfEmp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _initNote();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _share,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          IconButton(
              onPressed: () async {
                _note!.isHidden = !_note!.isHidden;
                await cloud.createOrUpdateNote(_note!);
                setState(
                  () {
                    _hidden = _note!.isHidden;
                  },
                );
              },
              icon: _hidden
                  ? const Icon(Icons.lock_outline)
                  : const Icon(Icons.lock_open)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            TextField(
              style: const TextStyle(fontSize: 20),
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                hintText: 'Title',
                hintStyle: TextStyle(fontSize: 20),
                border: InputBorder.none,
              ),
              controller: titleController,
              maxLines: null,
              onChanged: (text) async {
                try {
                  _note!.title = text;
                  _note = await cloud.createOrUpdateNote(_note!) as TextNote;
                } catch (e) {
                  if (!context.mounted) return;
                  showAlartDialog(
                      title: 'Error', content: e.toString(), context: context);
                }
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: DetectableTextField(
                autofocus: true,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  hintText: 'Content',
                  border: InputBorder.none,
                ),
                controller: contentController,
                maxLines: null,
                onChanged: (text) async {
                  try {
                    _note!.content = text;
                    _note = await cloud.createOrUpdateNote(_note!) as TextNote;
                  } catch (e) {
                    if (!context.mounted) return;
                    showAlartDialog(
                        title: 'Error',
                        content: e.toString(),
                        context: context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
