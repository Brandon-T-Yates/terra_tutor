// ignore_for_file: avoid_print, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';
import '/Global_Elements/ui_tiles.dart';

class Reminder {
  final String id;
  final String name;
  final int days;
  final Timestamp timestamp;

  Reminder({
    required this.id,
    required this.name,
    required this.days,
    required this.timestamp,
  });

  factory Reminder.fromDocument(DocumentSnapshot doc) {
    return Reminder(
      id: doc.id,
      name: doc['name'],
      days: doc['days'],
      timestamp: doc['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'days': days,
      'timestamp': timestamp,
    };
  }
}

class WaterReminderWidget extends StatefulWidget {
  final VoidCallback onWidgetUpdated;

  const WaterReminderWidget({super.key, required this.onWidgetUpdated});

  @override
  _WaterReminderWidgetState createState() => _WaterReminderWidgetState();
}

class _WaterReminderWidgetState extends State<WaterReminderWidget> {
  late Stream<List<Reminder>> _reminderStream;
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _reminderStream = getReminders();
    }
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
  }

  Future<void> addReminder(Reminder reminder) async {
    final firestore = FirebaseFirestore.instance;
    final userId = _currentUser?.uid;
    if (userId != null) {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('reminders')
          .add(reminder.toMap());
    }
  }

  Future<void> deleteReminder(String reminderId) async {
    final firestore = FirebaseFirestore.instance;
    final userId = _currentUser?.uid;
    if (userId != null) {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('reminders')
          .doc(reminderId)
          .delete();
    }
  }

  Stream<List<Reminder>> getReminders() {
    final firestore = FirebaseFirestore.instance;
    final userId = _currentUser?.uid;
    if (userId != null) {
      return firestore
          .collection('users')
          .doc(userId)
          .collection('reminders')
          .snapshots()
          .map(
        (snapshot) {
          return snapshot.docs
              .map((doc) => Reminder.fromDocument(doc))
              .toList();
        },
      );
    } else {
      return Stream.value([]);
    }
  }

  void _showReminderDialog({Reminder? reminder}) {
    final nameController = TextEditingController();
    final daysController = TextEditingController();

    if (reminder != null) {
      nameController.text = reminder.name;
      daysController.text = reminder.days.toString();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Provider.of<ThemeNotifier>(context).getTheme();
        return AlertDialog(
          backgroundColor: theme.primaryColor,
          title: Center(
            child: Text(
              reminder != null ? 'Edit Reminder' : 'Add Reminder',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (reminder != null) ...[
                  Row(
                    children: [
                      Checkbox(
                        value: true,
                        onChanged: (value) {},
                      ),
                      Expanded(child: Text(reminder.name)),
                    ],
                  ),
                ],
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Reminder Name'),
                ),
                TextField(
                  controller: daysController,
                  decoration:
                      const InputDecoration(labelText: 'Days Until Next Event'),
                  keyboardType: TextInputType.number,
                ),
                if (reminder != null) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text(
                                  'Are you sure you want to delete this reminder?'),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    deleteReminder(reminder.id)
                                        .then(
                                            (_) => Navigator.of(context).pop())
                                        .catchError((error) => print(
                                            "Failed to delete reminder: $error"));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.cardColor,
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(color: Colors.black),
                                    fixedSize: const Size(100, 25),
                                  ),
                                  child: const Text('Delete',
                                      style: TextStyle(fontSize: 16)),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: theme.cardColor,
                                    foregroundColor: Colors.black,
                                    side: const BorderSide(color: Colors.black),
                                    fixedSize: const Size(100, 25),
                                  ),
                                  child: const Text('Cancel',
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.cardColor,
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                        fixedSize: const Size(100, 25),
                      ),
                      child:
                          const Text('Delete', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.cardColor,
                foregroundColor: Colors.black,
                side: const BorderSide(color: Colors.black),
                fixedSize: const Size(100, 25),
              ),
              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 5),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: ElevatedButton(
                onPressed: () {
                  final name = nameController.text;
                  final days = int.tryParse(daysController.text) ?? 0;
                  final timestamp = Timestamp.now();

                  if (reminder != null) {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(_currentUser?.uid)
                        .collection('reminders')
                        .doc(reminder.id)
                        .update({
                          'name': name,
                          'days': days,
                          'timestamp': timestamp,
                        })
                        .then((_) => Navigator.of(context).pop())
                        .catchError((error) =>
                            print("Failed to update reminder: $error"));
                  } else {
                    final newReminder = Reminder(
                      id: '',
                      name: name,
                      days: days,
                      timestamp: timestamp,
                    );

                    addReminder(newReminder)
                        .then((_) => Navigator.of(context).pop())
                        .catchError(
                            (error) => print("Failed to add reminder: $error"));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.cardColor,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
                  fixedSize: const Size(100, 25),
                ),
                child: Text(reminder != null ? 'Update' : 'Add',
                    style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(
      List<Reminder> reminders, VoidCallback onWidgetUpdated) {
    Map<String, bool> selectedReminders = {};

    for (var reminder in reminders) {
      selectedReminders[reminder.id] = false;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Provider.of<ThemeNotifier>(context).getTheme();
        return AlertDialog(
          backgroundColor: theme.primaryColor,
          title: const Center(
            child: Text(
              'Select Reminders to Delete',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: reminders.map((reminder) {
                    return CheckboxListTile(
                      title: Text(reminder.name),
                      value: selectedReminders[reminder.id],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedReminders[reminder.id] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              );
            },
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.cardColor,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    fixedSize: const Size(90, 25),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 13)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    List<String> remindersToDelete = selectedReminders.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();

                    for (var reminderId in remindersToDelete) {
                      await deleteReminder(reminderId);
                    }

                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.cardColor,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    fixedSize: const Size(90, 25),
                  ),
                  child: const Text('Delete', style: TextStyle(fontSize: 13)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    List<String> remindersToDelete = selectedReminders.entries
                        .where((entry) => entry.value)
                        .map((entry) => entry.key)
                        .toList();

                    for (var reminderId in remindersToDelete) {
                      await deleteReminder(reminderId);
                    }

                    Navigator.of(context).pop();

                    onWidgetUpdated();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.cardColor,
                    foregroundColor: Colors.black,
                    side: const BorderSide(color: Colors.black),
                    fixedSize: const Size(90, 25),
                  ),
                  child: const Text('Delete Widget',
                      style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Reminder>>(
      stream: _reminderStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final reminders = snapshot.data ?? [];

        return GestureDetector(
          onTap: () => _showReminderDialog(),
          onLongPress: () {
            _showDeleteDialog(reminders, () {
              widget.onWidgetUpdated();
            });
          },
          child: UiTile(
            key: ValueKey(reminders.length),
            name: 'Watering Reminder',
            textAlignment: TextAlignOption.center,
            description: reminders.isEmpty
                ? 'No reminders. Please click to add a new reminder :)'
                : reminders
                    .map(
                        (reminder) => '${reminder.name}: ${reminder.days} Days')
                    .join('\n'),
          ),
        );
      },
    );
  }
}
