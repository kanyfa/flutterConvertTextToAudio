import 'package:flutter/material.dart';
import 'audiototextscreen.dart';
import 'texttoaudioscreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AudioText Converter"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
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
    );
  }

  Widget _buildCustomButton({required String text, required VoidCallback onPressed, required Color color}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 4,
        backgroundColor: color,
      ),
      child: Text(text, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }
}
