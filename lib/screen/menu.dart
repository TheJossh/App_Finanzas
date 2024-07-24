import 'package:flutter/material.dart';
import 'pagos_habituales.dart';  // Importa la nueva página



class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 54, 112, 214),
      appBar: AppBar(
        title: Text('Home Page'),
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
                color: Colors.blue,
              ),
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Recordatorio'),
              onTap: () {
                
                Navigator.push(context, MaterialPageRoute(builder: (context)=> PagosHabitualesScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Boton 2'),
              onTap: () {
                
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Boton 3'),
              onTap: () {
                // Acción para el botón 3
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Boton 4'),
              onTap: () {
                
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Boton 5'),
              onTap: () {
                
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Boton 6'),
              onTap: () {
                
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Boton 7'),
              onTap: () {
                
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.alarm),
              title: Text('Boton 8'),
              onTap: () {
                
                Navigator.pop(context);
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
