// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
}

class PagosHabitualesScreen extends StatefulWidget {
  @override
  _PagosHabitualesScreenState createState() => _PagosHabitualesScreenState();
}

class _PagosHabitualesScreenState extends State<PagosHabitualesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Reminder> reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    QuerySnapshot querySnapshot = await _firestore.collection('recordatorios').get();
    setState(() {
      reminders = querySnapshot.docs.map((doc) {
        return Reminder.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  void _agregarRecordatorio() async {
    final Reminder? newReminder = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecordatorioScreen()),
    );

    if (newReminder != null) {
      DocumentReference docRef = await _firestore.collection('recordatorios').add(newReminder.toMap());
      setState(() {
        reminders.add(newReminder.copyWith(id: docRef.id));
      });
    }
  }

  void _editarRecordatorio(int index) async {
    final Reminder? editedReminder = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordatorioScreen(reminder: reminders[index]),
      ),
    );

    if (editedReminder != null) {
      await _firestore.collection('recordatorios').doc(reminders[index].id).update(editedReminder.toMap());
      setState(() {
        reminders[index] = editedReminder;
      });
    }
  }

  void _eliminarRecordatorio(int index) async {
    await _firestore.collection('recordatorios').doc(reminders[index].id).delete();
    setState(() {
      reminders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagos Habituales'),
         backgroundColor: Colors.cyan,
      ),
      body: reminders.isEmpty
          ? Center(child: Text('No hay recordatorios', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(reminder.nombre, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha Inicio: ${reminder.fechaInicio.day}/${reminder.fechaInicio.month}/${reminder.fechaInicio.year}'),
                        Text('Hora: ${reminder.hora.hour}:${reminder.hora.minute}'),
                        Text('Banco: ${reminder.cuenta ?? 'No especificado'}'),
                        Text('Categoría: ${reminder.categoria ?? 'No especificado'}'),
                        Text('Cantidad: ${reminder.cantidad}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editarRecordatorio(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _eliminarRecordatorio(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarRecordatorio,
        tooltip: 'Crear Recordatorio de Pago',
        child: Icon(Icons.add),
      ),
    );
  }
}

class RecordatorioScreen extends StatefulWidget {
  final Reminder? reminder;

  RecordatorioScreen({this.reminder});

  @override
  _RecordatorioScreenState createState() => _RecordatorioScreenState();
}

class _RecordatorioScreenState extends State<RecordatorioScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  late DateTime _fechaInicio;
  late TimeOfDay _hora;
  DateTime? _fechaFin;
  String? _cuenta;
  String? _categoria;
  late String _cantidad;

  final List<String> _categorias = ['Ahorros', 'Plan de Vida','Entretenimiento','Salud','Domesticos','Seguros','Prestamos'];

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      _nombre = widget.reminder!.nombre;
      _fechaInicio = widget.reminder!.fechaInicio;
      _hora = widget.reminder!.hora;
      _fechaFin = widget.reminder!.fechaFin;
      _cuenta = widget.reminder!.cuenta;
      _categoria = widget.reminder!.categoria;
      _cantidad = widget.reminder!.cantidad;
    } else {
      _nombre = '';
      _fechaInicio = DateTime.now();
      _hora = TimeOfDay.now();
      _fechaFin = null;
      _cuenta = '';
      _categoria = _categorias[0];
      _cantidad = '';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newReminder = Reminder(
        nombre: _nombre,
        fechaInicio: _fechaInicio,
        hora: _hora,
        fechaFin: _fechaFin,
        cuenta: _cuenta,
        categoria: _categoria,
        cantidad: _cantidad,
      );

      Navigator.pop(context, newReminder);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaInicio,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _fechaInicio) {
      setState(() {
        _fechaInicio = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _hora,
    );
    if (picked != null && picked != _hora) {
      setState(() {
        _hora = picked;
      });
    }
  }

  Future<void> _selectDateFin(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaFin ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _fechaFin = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder == null ? 'Crear Recordatorio' : 'Editar Recordatorio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _nombre,
                  decoration: InputDecoration(
                    labelText: 'Nombre del recordatorio',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese un nombre';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _nombre = value!;
                  },
                ),
                SizedBox(height: 16.0),
                Text('Fecha de inicio del recordatorio'),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_fechaInicio.day}/${_fechaInicio.month}/${_fechaInicio.year}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text('Hora'),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_hora.hour}:${_hora.minute}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.access_time),
                      onPressed: () => _selectTime(context),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Text('Fecha de finalización del recordatorio'),
                TextButton(
                  onPressed: () => _selectDateFin(context),
                  child: Text(
                    _fechaFin == null
                        ? 'No se ha seleccionado'
                        : '${_fechaFin!.day}/${_fechaFin!.month}/${_fechaFin!.year}',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  initialValue: _cuenta,
                  decoration: InputDecoration(
                    labelText: 'Banco',
                    border: OutlineInputBorder(),
                  ),
                  onSaved: (value) {
                    _cuenta = value;
                  },
                ),
                SizedBox(height: 16.0),
                Text('Categoría'),
                DropdownButtonFormField<String>(
                  value: _categoria,
                  items: _categorias.map((categoria) {
                    return DropdownMenuItem<String>(
                      value: categoria,
                      child: Text(categoria),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _categoria = value!;
                    });
                  },
                  onSaved: (value) {
                    _categoria = value!;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  initialValue: _cantidad,
                  decoration: InputDecoration(
                    labelText: 'Cantidad',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingrese una cantidad';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _cantidad = value!;
                  },
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.reminder == null ? 'Crear Recordatorio de Pago' : 'Guardar Cambios'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Reminder {
  final String id;
  final String nombre;
  final DateTime fechaInicio;
  final TimeOfDay hora;
  final DateTime? fechaFin;
  final String? cuenta;
  final String? categoria;
  final String cantidad;

  Reminder({
    this.id = '',
    required this.nombre,
    required this.fechaInicio,
    required this.hora,
    this.fechaFin,
    this.cuenta,
    this.categoria,
    required this.cantidad,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'fechaInicio': fechaInicio.toIso8601String(),
      'hora': '${hora.hour}:${hora.minute}',
      'fechaFin': fechaFin?.toIso8601String(),
      'cuenta': cuenta,
      'categoria': categoria,
      'cantidad': cantidad,
    };
  }

  static Reminder fromMap(Map<String, dynamic> map, String documentId) {
    return Reminder(
      id: documentId,
      nombre: map['nombre'],
      fechaInicio: DateTime.parse(map['fechaInicio']),
      hora: TimeOfDay(
        hour: int.parse(map['hora'].split(':')[0]),
        minute: int.parse(map['hora'].split(':')[1]),
      ),
      fechaFin: map['fechaFin'] != null ? DateTime.parse(map['fechaFin']) : null,
      cuenta: map['cuenta'],
      categoria: map['categoria'],
      cantidad: map['cantidad'],
    );
  }

  Reminder copyWith({
    String? id,
    String? nombre,
    DateTime? fechaInicio,
    TimeOfDay? hora,
    DateTime? fechaFin,
    String? cuenta,
    String? categoria,
    String? cantidad,
  }) {
    return Reminder(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      hora: hora ?? this.hora,
      fechaFin: fechaFin ?? this.fechaFin,
      cuenta: cuenta ?? this.cuenta,
      categoria: categoria ?? this.categoria,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}
