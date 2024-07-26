import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GraficaScreen extends StatefulWidget {
  @override
  _GraficaScreenState createState() => _GraficaScreenState();
}

class _GraficaScreenState extends State<GraficaScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, double> categorias = {};

  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    QuerySnapshot querySnapshot = await _firestore.collection('recordatorios').get();
    Map<String, double> tempCategorias = {};
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String categoria = data['categoria'] ?? 'No especificado';
      double cantidad = double.tryParse(data['cantidad']) ?? 0;
      if (tempCategorias.containsKey(categoria)) {
        tempCategorias[categoria] = tempCategorias[categoria]! + cantidad;
      } else {
        tempCategorias[categoria] = cantidad;
      }
    }
    setState(() {
      categorias = tempCategorias;
    });
  }

  List<PieChartSectionData> _getPieChartSections() {
    return categorias.entries.map((entry) {
      return PieChartSectionData(
        color: Colors.primaries[categorias.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        value: entry.value,
        title: '${entry.key}: ${entry.value.toStringAsFixed(2)}',
        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color.fromARGB(185, 54, 54, 54)),
        radius: 70, 
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Gráficas de Categorías'),
      ),
      body: categorias.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  flex: 3, 
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: PieChart(
                          PieChartData(
                            sections: _getPieChartSections(),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 0, 
                            centerSpaceRadius: 40, 
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: categorias.length,
                    itemBuilder: (context, index) {
                      String key = categorias.keys.elementAt(index);
                      double value = categorias[key]!;
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.primaries[index % Colors.primaries.length],
                          ),
                          title: Text(key),
                          trailing: Text('L. ${value.toStringAsFixed(2)}'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
