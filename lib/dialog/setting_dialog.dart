import 'package:avatars/avatars.dart';
import 'package:awesome_notes/models/user_data_model.dart';
import 'package:flutter/material.dart';

enum SettingActions {
  logout,
  cancel,
  deleteAll,
}

Future<SettingActions?> showSettingDialog(
    BuildContext context, UserData user) async {
  return await showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Avatar(
                        name: user.name,
                        border: Border.all(
                          color: const Color.fromRGBO(238, 238, 238, 1),
                          width: 5,
                        ),
                        placeholderColors: [
                          Theme.of(context).colorScheme.primary,
                        ],
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      user.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      user.email,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(SettingActions.logout);
                  },
                  child: const Text('Logout'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(SettingActions.deleteAll);
                  },
                  child: Text(
                    'Delete All',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
