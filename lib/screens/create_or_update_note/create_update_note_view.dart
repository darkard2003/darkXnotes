import 'package:awesome_notes/screens/create_or_update_note/create_update_note_vm.dart';
import 'package:detectable_text_field/widgets/detectable_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateUpdateNoteView extends StatelessWidget {
  const CreateUpdateNoteView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateUpdateNoteVM>();
    final state = vm.state;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: vm.share,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: vm.deleteNote,
          ),
          IconButton(
            onPressed: vm.toggleHidden,
            icon: state.note.isHidden
                ? const Icon(Icons.lock_outline)
                : const Icon(Icons.lock_open),
          ),
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
              controller: vm.titleController,
              maxLines: null,
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
                controller: vm.contentController,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
