import 'dart:io';
import 'package:flutter/foundation.dart'; // kIsWeb pour détecter le Web
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Alternative Web

class FileManager {
  /// Récupère le chemin du fichier (Mobile & Desktop)
  static Future<String?> getFilePath(String fileName) async {
    if (kIsWeb) {
      print("⚠️ Stockage local non disponible sur le Web. Utilisation de SharedPreferences.");
      return null;
    }

    try {
      final directory = await getApplicationDocumentsDirectory();
      return "${directory.path}/$fileName";
    } catch (e) {
      print("❌ Erreur lors de l'obtention du chemin du fichier : $e");
      return null;
    }
  }

  /// Sauvegarde du texte (Mobile & Web)
  static Future<void> saveTextToFile(String fileName, String content) async {
    if (content.isEmpty) {
      print("⚠️ Texte vide, sauvegarde annulée.");
      return;
    }

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(fileName, content);
      print("✅ Texte sauvegardé dans SharedPreferences sur le Web.");
      return;
    }

    try {
      final path = await getFilePath(fileName);
      if (path != null) {
        final file = File(path);
        await file.writeAsString(content);
        print("✅ Fichier sauvegardé : $fileName");
      } else {
        print("❌ Échec de la sauvegarde : chemin invalide.");
      }
    } catch (e) {
      print("❌ Erreur lors de la sauvegarde du fichier : $e");
    }
  }

  /// Lecture du texte (Mobile & Web)
  static Future<String> readTextFromFile(String fileName) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(fileName) ?? "⚠️ Aucun texte trouvé.";
    }

    try {
      final path = await getFilePath(fileName);
      if (path != null) {
        final file = File(path);
        return file.existsSync() ? await file.readAsString() : "⚠️ Fichier introuvable.";
      } else {
        return "❌ Chemin du fichier invalide.";
      }
    } catch (e) {
      print("❌ Erreur lors de la lecture du fichier : $e");
      return "⚠️ Impossible de lire le fichier.";
    }
  }
}
