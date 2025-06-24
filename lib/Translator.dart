import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Écran principal du traducteur
class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final GoogleTranslator translator = GoogleTranslator(); // Initialisation du service de traduction
  final FlutterTts flutterTts = FlutterTts(); // Initialisation du service de synthèse vocale
  TextEditingController _controller = TextEditingController(); // Contrôleur pour gérer le texte d'entrée
  String translatedText = ""; // Stocke le texte traduit
  String sourceLanguage = "fr"; // Langue source (Français par défaut)
  String targetLanguage = "en"; // Langue cible (Anglais par défaut)

  /// Liste des langues disponibles pour la traduction
  final Map<String, String> languages = {
    "Anglais": "en", "Français": "fr", "Espagnol": "es",
    "Allemand": "de", "Italien": "it", "Portugais": "pt",
    "Chinois": "zh", "Japonais": "ja", "Coréen": "ko",
    "Arabe": "ar", "Hindi": "hi", "Russe": "ru",
    "Néerlandais": "nl", "Suédois": "sv", "Turc": "tr",
    "Vietnamien": "vi", "Polonais": "pl", "Indonésien": "id",
    "Thaïlandais": "th", "Ukrainien": "uk"
  };

  /// Fonction pour traduire un texte
  void translateText() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Veuillez entrer du texte à traduire.")) // Alerte si le texte est vide
      );
      return;
    }

    try {
      var translation = await translator.translate(_controller.text, from: sourceLanguage, to: targetLanguage);
      setState(() => translatedText = translation.text); // Mise à jour du texte traduit
    } catch (e) {
      print("Erreur lors de la traduction : $e"); // Capture et affichage des erreurs éventuelles
    }
  }

  /// Fonction pour lire le texte traduit à voix haute
  void speakTranslation() async {
    if (translatedText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Traduction introuvable.")) // Alerte si aucune traduction disponible
      );
      return;
    }

    try {
      await flutterTts.setLanguage(targetLanguage); // Définit la langue cible pour la lecture
      await flutterTts.speak(translatedText); // Lit le texte traduit
    } catch (e) {
      print("Erreur lors de la lecture du texte : $e"); // Capture et affichage des erreurs éventuelles
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Traducteur"), centerTitle: true, backgroundColor: Colors.blueAccent, elevation: 4),
      body: Padding(
        padding: EdgeInsets.all(16.0), // Ajout de marges pour une meilleure mise en page
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Sélection de la langue source
            DropdownButton<String>(
              value: sourceLanguage,
              icon: Icon(Icons.language, color: Colors.blueAccent),
              onChanged: (String? newValue) {
                setState(() => sourceLanguage = newValue!);
              },  
              items: languages.entries.map((entry) => DropdownMenuItem(
                value: entry.value, child: Text("De ${entry.key}")
              )).toList(),
            ),
            SizedBox(height: 10),

            /// Sélection de la langue cible
            DropdownButton<String>(
              value: targetLanguage,
              icon: Icon(Icons.translate, color: Colors.greenAccent),
              onChanged: (String? newValue) {
                setState(() => targetLanguage = newValue!);
              },
              items: languages.entries.map((entry) => DropdownMenuItem(
                value: entry.value, child: Text("Vers ${entry.key}")
              )).toList(),
            ),
            SizedBox(height: 20),

            /// Zone de texte pour entrer le texte à traduire
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "Entrez du texte",
                prefixIcon: Icon(Icons.text_fields, color: Colors.blueAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            SizedBox(height: 20),

            /// Bouton de traduction
            ElevatedButton(
              onPressed: translateText,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                elevation: 4,
                backgroundColor: Colors.blueAccent,
              ),
              child: Text("🔄 Traduire", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            SizedBox(height: 20),

            /// Affichage du texte traduit
            Text(
              translatedText.isNotEmpty ? translatedText : "📄 Aucune traduction disponible",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            /// Bouton pour écouter la traduction
            ElevatedButton(
              onPressed: speakTranslation,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                elevation: 4,
                backgroundColor: Colors.greenAccent,
              ),
              child: Text("🔊 Lire la traduction", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
