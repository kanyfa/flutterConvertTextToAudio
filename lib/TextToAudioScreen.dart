import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';

class TextToAudioScreen extends StatefulWidget {
  @override
  _TextToAudioScreenState createState() => _TextToAudioScreenState();
}

class _TextToAudioScreenState extends State<TextToAudioScreen> {
  FlutterTts flutterTts = FlutterTts();
  GoogleTranslator translator = GoogleTranslator();
  TextEditingController _controller = TextEditingController();
  bool isSpeaking = false;
  String selectedLanguage = "fr"; // Langue cible
  String translatedText = ""; // Texte traduit

  /// Liste des langues disponibles
  final Map<String, String> languages = {
    "Anglais": "en", "Français": "fr", "Espagnol": "es",
    "Allemand": "de", "Italien": "it", "Portugais": "pt",
    "Chinois": "zh", "Japonais": "ja", "Coréen": "ko",
    "Arabe": "ar", "Hindi": "hi", "Russe": "ru",
    "Néerlandais": "nl", "Suédois": "sv", "Turc": "tr",
    "Vietnamien": "vi", "Polonais": "pl", "Indonésien": "id",
    "Thaïlandais": "th", "Ukrainien": "uk"
  };

  void translateText() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚠️ Veuillez entrer du texte à traduire.")));
      return;
    }

    try {
      var translation = await translator.translate(_controller.text, to: selectedLanguage);
      setState(() => translatedText = translation.text);
    } catch (e) {
      print("Erreur lors de la traduction : $e");
    }
  }

  void speakText() async {
    if (translatedText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("⚠️ Aucun texte traduit à lire.")));
      return;
    }

    try {
      await flutterTts.setLanguage(selectedLanguage);
      await flutterTts.speak(translatedText);
    } catch (e) {
      print("Erreur lors de la lecture du texte : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Text Vert Audio"), centerTitle: true, backgroundColor: Colors.blueAccent, elevation: 4),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: selectedLanguage,
                  icon: Icon(Icons.language, color: Colors.blueAccent),
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  onChanged: (String? newValue) {
                    setState(() => selectedLanguage = newValue!);
                  },
                  items: languages.entries.map<DropdownMenuItem<String>>((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.value,
                      child: Text(entry.key),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Entrez du texte",
                    prefixIcon: Icon(Icons.text_fields, color: Colors.blueAccent),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
                SizedBox(height: 20),
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
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: Colors.grey.shade400, blurRadius: 5, spreadRadius: 2)],
                  ),
                  child: Text(
                    translatedText.isNotEmpty ? translatedText : "📄 Aucune traduction disponible",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: speakText,
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
        ),
      ),
    );
  }
}
