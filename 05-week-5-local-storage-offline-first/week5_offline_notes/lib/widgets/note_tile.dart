import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/local/note.dart';

class NoteTile extends StatelessWidget {
  const NoteTile({super.key, required this.note});

  final Note note;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: note.id == null ? null : () => context.push('/note/${note.id}'),
      title: Text(note.title),
      subtitle: Text(note.body),
      trailing: note.dirty
          ? const Chip(label: Text('Belum tersinkron'))
          : const Icon(Icons.cloud_done),
    );
  }
}
