import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aplicacion_finanzas/screen/cuenta.dart';

class AccountChartScreen extends StatelessWidget {
  final CollectionReference accountsCollection =
      FirebaseFirestore.instance.collection('accounts');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfica de Cuentas'),
        backgroundColor: Colors.cyan,
      ),
      body: StreamBuilder(
        stream: accountsCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final accounts = snapshot.data!.docs.map((doc) {
            return Account(
              id: doc.id,
              name: doc['name'],
              balance: doc['balance'],
              icon: doc['icon'],
            );
          }).toList();

          List<PieChartSectionData> pieChartSections = accounts.map((account) {
            return PieChartSectionData(
              value: account.balance,
              title: '${account.balance.toStringAsFixed(2)} L',
              color: Colors.primaries[accounts.indexOf(account) % Colors.primaries.length],
              radius: 100,
              titleStyle: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 300,
                            child: PieChart(
                              PieChartData(
                                sections: pieChartSections,
                                centerSpaceRadius: 50,
                                sectionsSpace: 2,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Distribución de Saldos',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Cuentas',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  SizedBox(height: 10),
                  ...accounts.map((account) {
                    Color accountColor = Colors.primaries[accounts.indexOf(account) % Colors.primaries.length];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: accountColor,
                          child: Icon(
                            Icons.account_balance_wallet,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          account.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Text(
                          '${account.balance.toStringAsFixed(2)} L',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
