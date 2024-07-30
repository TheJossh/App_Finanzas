// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _addNote() {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('notes').add({
        'titulo': _titleController.text,
        'descripcion': _descriptionController.text,
        'tiempo': Timestamp.now(),
      });
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  void _editNote(DocumentSnapshot doc) {
    _titleController.text = doc['titulo'];
    _descriptionController.text = doc['descripcion'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Nota'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _titleController.clear();
              _descriptionController.clear();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              FirebaseFirestore.instance.collection('notes').doc(doc.id).update({
                'titulo': _titleController.text,
                'descripcion': _descriptionController.text,
              });
              Navigator.of(context).pop();
              _titleController.clear();
              _descriptionController.clear();
            },
            child: Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(String id) {
    FirebaseFirestore.instance.collection('notes').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addNote,
                      child: Text('Agregar Nota'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('notes').orderBy('tiempo', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Card(
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: ListTile(
                        title: Text(doc['titulo'], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(doc['descripcion']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editNote(doc),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteNote(doc.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
