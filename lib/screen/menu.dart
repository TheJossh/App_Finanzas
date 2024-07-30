// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:aplicacion_finanzas/screen/AccountChartScreen.dart';
import 'package:aplicacion_finanzas/screen/categorias.dart';
import 'package:aplicacion_finanzas/screen/cuenta.dart';
import 'package:aplicacion_finanzas/screen/login_screen.dart';
import 'package:aplicacion_finanzas/screen/notas.dart';
import 'package:flutter/material.dart';
import 'pagos_habituales.dart';  



class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.cyan,
      appBar: AppBar(
        title: Text('Pagina De Inicio'),
        backgroundColor:  const Color.fromARGB(255, 0, 150, 170),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Pagos Recurrentes'),
              onTap: () {
                
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PagosHabitualesScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.account_balance),
              title: Text('Ajustes Cuenta'),
              onTap: () {
                
                Navigator.push(context, MaterialPageRoute(builder: (context) =>AccountListScreen() ));
              },
            ),
            ListTile(
              leading: Icon(Icons.bar_chart),
              title: Text('Graficos de cuenta'),
              onTap: () {
                
                Navigator.push(context, MaterialPageRoute(builder: (context) =>AccountChartScreen() ));
              },
            ),
            ListTile(
              leading: Icon(Icons.speaker_notes),
              title: Text('Notas'),
              onTap: () {
                
                Navigator.push(context, MaterialPageRoute(builder: (context) =>NotesScreen() ));
              },
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Gastos Categoria'),
              onTap: () {
                
                Navigator.push(context, MaterialPageRoute(builder: (context) =>GraficaScreen() ));
              },
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Salir'),
              onTap: () {
                
                Navigator.push(context, MaterialPageRoute(builder: (context) =>LoginScreen() ));
              },
            ),
          ],
        ),
      ),
      body: Center(  
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              
              
              child: Image.network(
                
                "https://picsum.photos/id/870/200/300?grayscale&blur=2",
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                            
              ),
            ),
            
            SizedBox(height: 20),
            Text('Aplicacion de Finanzas Grupo 8'),
          ],
        ),
      ),
    );
  }
       
  }
