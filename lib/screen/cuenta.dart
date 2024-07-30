// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, no_leading_underscores_for_local_identifiers, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_types_as_parameter_names, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  String id;
  String name;
  double balance;
  String icon;

  Account({required this.id, required this.name, required this.balance, required this.icon});
}

class AccountListScreen extends StatefulWidget {
  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final CollectionReference accountsCollection =
      FirebaseFirestore.instance.collection('accounts');

  void _addAccount(Account account) async {
    await accountsCollection.add({
      'name': account.name,
      'balance': account.balance,
      'icon': account.icon,
    });
  }

  void _updateAccount(String id, Account account) async {
    await accountsCollection.doc(id).update({
      'name': account.name,
      'balance': account.balance,
      'icon': account.icon,
    });
  }

  void _deleteAccount(String id) async {
    await accountsCollection.doc(id).delete();
  }

  Future<void> _showAccountDialog({Account? account, required bool isEditing}) async {
    final _formKey = GlobalKey<FormState>();
    String _name = account?.name ?? '';
    double _balance = account?.balance ?? 0.0;
    String _selectedIcon = account?.icon ?? 'assets/icons/money.png';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditing ? 'Editar cuenta' : 'Añadir cuenta'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la cuenta',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.account_balance),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduzca un nombre de cuenta';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  initialValue: _balance.toString(),
                  decoration: InputDecoration(
                    labelText: 'Balance',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Introduzca un balance';
                    }
                    try {
                      double.parse(value);
                    } catch (e) {
                      return 'Introduzca un número válido';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _balance = double.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Icono',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.money),
                  ),
                  value: _selectedIcon,
                  items: [
                    DropdownMenuItem(value: 'assets/icons/money.png', child: Text('Dinero')),
                    
                    // aqui se podrian agregar mas iconos
                  ],
                  onChanged: (value) {
                    _selectedIcon = value!;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (isEditing) {
                    _updateAccount(account!.id, Account(id: account.id, name: _name, balance: _balance, icon: _selectedIcon));
                  } else {
                    _addAccount(Account(id: '', name: _name, balance: _balance, icon: _selectedIcon));
                  }
                  Navigator.pop(context);
                }
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuentas'),
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

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Total: ${accounts.fold<double>(0.0, (sum, item) => sum + item.balance).toStringAsFixed(2)} L',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 54, 112, 214)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4,
                      child: ListTile(
                        title: Text(accounts[index].name, style: TextStyle(fontSize: 18)),
                        subtitle: Text('${accounts[index].balance.toStringAsFixed(2)} L'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showAccountDialog(account: accounts[index], isEditing: true);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _deleteAccount(accounts[index].id);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAccountDialog(isEditing: false);
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 54, 112, 214),
      ),
    );
  }
}
