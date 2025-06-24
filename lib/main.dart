import 'package:flutter/material.dart';
import 'audiototextscreen.dart';
import 'texttoaudioscreen.dart';
import 'permissions.dart'; // Ajout de l'importation correcte pour les permissions

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PermissionsManager.requestPermissions(); // Gestion des permissions

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
    home: HomeScreen(),
    theme: ThemeData(
      primarySwatch: Colors.blue, // Ajout d'un thème
      scaffoldBackgroundColor: Colors.white, // Fond de l’application
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AudioText Converter",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Couleur améliorée
        elevation: 4, // Ombre sous l'AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300], // Dégradé de couleur
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Ajout d’un padding
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCustomButton(
                  text: "🎙️ Audio vers Texte",
                  onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => AudioToTextScreen())),
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 20),
                _buildCustomButton(
                  text: "📜 Texte vers Audio",
                  onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => TextToAudioScreen())),
                  color: Colors.greenAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget personnalisé pour les boutons stylisés
  Widget _buildCustomButton({required String text, required VoidCallback onPressed, required Color color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 4, // Ajout d'une ombre
        backgroundColor: color,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
