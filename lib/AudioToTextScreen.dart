import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'filemanager.dart';

/// Écran principal permettant la conversion de l'audio en texte.
class AudioToTextScreen extends StatefulWidget {
  @override
  _AudioToTextScreenState createState() => _AudioToTextScreenState();
}

class _AudioToTextScreenState extends State<AudioToTextScreen> {
  SpeechToText speechToText = SpeechToText(); // Initialisation du moteur de reconnaissance vocale
  String _transcribedText = ""; // Variable pour stocker le texte transcrit
  bool _isListening = false; // Indicateur d'état d'écoute

  /// Fonction pour démarrer la reconnaissance vocale
  void startListening() async {
    bool available = await speechToText.initialize(); // Vérifie si la reconnaissance est disponible
    if (available && !_isListening) {
      setState(() {
        _isListening = true; // Met à jour l'état d'écoute
      });

      speechToText.listen(onResult: (result) {
        setState(() {
          _transcribedText = result.recognizedWords; // Stocke les mots transcrits
        });
      });
    }
  }

  /// Fonction pour arrêter l'écoute
  void stopListening() {
    if (_isListening) {
      speechToText.stop(); // Arrête la reconnaissance vocale
      setState(() {
        _isListening = false; // Met à jour l'état d'écoute
      });
    }
  }

  /// Fonction pour sauvegarder la transcription dans un fichier
  void saveTranscription() async {
    if (_transcribedText.isNotEmpty) {
      await FileManager.saveTextToFile("transcription.txt", _transcribedText); // Sauvegarde le texte
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Transcription sauvegardée avec succès !")), // Affiche une confirmation
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Audio vers Texte",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent, // Couleur améliorée
        elevation: 4, // Ombre sous l'AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300], // Dégradé de couleur pour un design attrayant
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Ajout d’un padding pour espacer les éléments
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCustomButton(
                  text: _isListening ? "🎙️ Écoute en cours..." : "🎙️ Démarrer", // Bouton pour lancer l'écoute
                  onPressed: startListening,
                  color: Colors.blueAccent,
                ),
                SizedBox(height: 20), // Espacement entre les éléments
                _buildCustomButton(
                  text: "⏹️ Arrêter", // Bouton pour stopper l'écoute
                  onPressed: stopListening,
                  color: Colors.redAccent,
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15), // Ajout d'un effet arrondi
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade300, blurRadius: 8, spreadRadius: 2), // Effet d'ombre
                    ],
                  ),
                  child: Text(
                    _transcribedText.isNotEmpty ? _transcribedText : "📄 Aucune transcription disponible", // Affichage du texte transcrit
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                _buildCustomButton(
                  text: "💾 Sauvegarder", // Bouton pour sauvegarder le texte transcrit
                  onPressed: saveTranscription,
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
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Taille du bouton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Bordures arrondies
        ),
        elevation: 4, // Ajout d'une ombre pour un effet esthétique
        backgroundColor: color,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
