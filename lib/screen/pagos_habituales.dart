import 'package:flutter/material.dart';

void main() {
  runApp(PagosHabitualesApp());
}

class PagosHabitualesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pagos Habituales',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: PagosHabitualesScreen(),
    );
  }
}

class PagosHabitualesScreen extends StatefulWidget {
  @override
  _PagosHabitualesScreenState createState() => _PagosHabitualesScreenState();
}

class _PagosHabitualesScreenState extends State<PagosHabitualesScreen> {
  List<Reminder> reminders = [];

  void _agregarRecordatorio() async {
    final Reminder? newReminder = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RecordatorioScreen()),
    );

    if (newReminder != null) {
      setState(() {
        reminders.add(newReminder);
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
      setState(() {
        reminders[index] = editedReminder;
      });
    }
  }

  void _eliminarRecordatorio(int index) {
    setState(() {
      reminders.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pagos Habituales'),
      ),
      body: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          final reminder = reminders[index];
          return ListTile(
            title: Text(reminder.nombre),
            subtitle: Text(
              'Fecha Inicio: ${reminder.fechaInicio.day}/${reminder.fechaInicio.month}/${reminder.fechaInicio.year} '
              'Hora: ${reminder.hora.hour}:${reminder.hora.minute} '
              'Banco: ${reminder.cuenta} '
              'Categoría: ${reminder.categoria}',
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarRecordatorio,
        tooltip: 'Crear Recordatorio',
        child: Icon(Icons.alarm),
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

  final List<String> _categorias = ['Ahorros ', 'Plan de Vida'];

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
                  decoration: InputDecoration(labelText: 'Nombre del recordatorio'),
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
                  decoration: InputDecoration(labelText: 'Banco'),
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
                      _categoria = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Seleccione una categoría',
                  ),
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  initialValue: _cantidad,
                  decoration: InputDecoration(labelText: 'Cantidad'),
                  keyboardType: TextInputType.number,
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
                  child: Text(widget.reminder == null ? 'Crear Recordatorio' : 'Guardar Cambios'),
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
  final String nombre;
  final DateTime fechaInicio;
  final TimeOfDay hora;
  final DateTime? fechaFin;
  final String? cuenta;
  final String? categoria;
  final String cantidad;

  Reminder({
    required this.nombre,
    required this.fechaInicio,
    required this.hora,
    this.fechaFin,
    this.cuenta,
    this.categoria,
    required this.cantidad,
  });
}